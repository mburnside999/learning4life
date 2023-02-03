import { LightningElement, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import getClientObjectivesSDCount from "@salesforce/apex/L4LSessionStatsController.getClientObjectivesSDCount";
import getProgramsAndSds from "@salesforce/apex/L4LSessionStatsController.getProgramsAndSds";
import D3 from "@salesforce/resourceUrl/d3";

import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logError } from "c/l4lNebulaUtil";

const COMPONENT = "D3Nest";
const TAG = "L4L-Session-Statistics-D3Nest";

export default class D3Nest extends LightningElement {
  //the clientId from UI
  @api recordId;

  //chart dimensions
  svgWidth = 1400;
  svgHeight = 1200;

  isSelected = false;

  @track result; //raw returned records from Apex query
  @track gridDataTree = []; //the data that D3 iterates across
  @track sdcountarray = [];
  sdcountmap = new Map();
  d3Initialized = false; //rendering and control flags
  programsDisplayed = 0;
  stageoptionval = "All";

  stageoptions = [
    { label: "All", value: "All", isChecked: true },
    { label: "Stage One", value: "Stage One" },
    { label: "Stage Two", value: "Stage Two" },
    { label: "Stage Three", value: "Stage Three" },
    { label: "Stage Four", value: "Stage Four" },
    { label: "Stage Five", value: "Stage Five" },
    { label: "Stage Six", value: "Stage Six" }
  ];

  connectedCallback() {
    console.log("in connectedCallback recordId=" + this.recordId);
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${TAG}`
        );
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback() returned error: ${error}`,
          `${COMPONENT}.connectedCallback() returned error: ${error}`,
          `${TAG}`
        );
      });
  }

  get resultmessage() {
    if (this.programsDisplayed > 0) {
      return this.isSelected
        ? "Tree contains " + this.programsDisplayed + " assigned programs."
        : "Tree contains " + this.programsDisplayed + " total programs.";
    }
  }

  renderedCallback() {
    console.log("in renderedCallback recordId=" + this.recordId);

    logDebug(
      this.recordId,
      `${COMPONENT}.renderedCallback(): this.d3Initialized=${this.d3Initialized}`,
      `${COMPONENT}.renderedCallback(): this.d3Initialized=${this.d3Initialized}`,
      `${TAG}`
    );

    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;

    //load D3
    Promise.all([loadScript(this, D3 + "/d3.v5.min.js")])
      .then(async () => {
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): calling getProgramsAndSds with stageStr=All`,
          `calling getProgramsAndSds`,
          `${TAG}`
        );
        let _result = (this.result = await getProgramsAndSds({
          stageStr: "All"
        })); //this shenanigans was to get D3 to wait for the Apex to finish
        console.log(_result);
        //console.log("NEST RESULT=>" + JSON.stringify(this.result));
      })
      .then(async () => {
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): getProgramsAndSds returned, this.result has ${this.result.length} items`,
          `getProgramsAndSds returned, this.result has ${this.result.length} items`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): calling getClientObjectivesSDCount`,
          `calling getClientObjectivesSDCount`,
          `${TAG}`
        );
        let _sdcountarray = (this.sdcountarray =
          await getClientObjectivesSDCount({ clientId: this.recordId })); //this shenanigans was to get D3 to wait for the Apex to finish
        console.log(_sdcountarray);
        //console.log("SD RESULT=>" + JSON.stringify(this.sdcountarray));
        this.sdcountarray.map((object) => {
          this.sdcountmap.set(
            object.progname + "-" + object.sdname,
            object.sdcount
          );
        });
        //let d3test = { children: result };
        //console.log("NEST D3Test=>" + JSON.stringify(d3test));
      })
      .then(() => {
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): getClientObjectivesSDCount returned, this.sdcountarray has ${this.sdcountarray.length} items`,
          `getClientObjectivesSDCount returned, this.sdcountarray has ${this.sdcountarray.length} items`,
          `${TAG}`
        );
        console.log("NEST calling initializeD3()");
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): calling initializeD3()`,
          `calling initializeD3()`,
          `${TAG}`
        );
        this.initializeD3();
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading D3",
            message: error.message,
            variant: "error"
          })
        );
      });
  }

  initializeD3() {
    console.log("NEST in initializeD3()");

    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3(): entering `,
      "initializing D3",
      `${TAG}`
    );
    const mycolor = (name) => {
      console.log("name=" + name);
      let colorarray = [
        "#a6cee3",
        "#1f78b4",
        "#b2df8a",
        "#33a02c",
        "#fb9a99",
        "#e31a1c",
        "#fdbf6f",
        "#ff7f00",
        "#cab2d6",
        "#6a3d9a",
        "#ffff99",
        "#b15928"
      ];

      let hash = name
        .split("")
        .reduce(
          (prevHash, currVal) =>
            ((prevHash << 5) - prevHash + currVal.charCodeAt(0)) | 0,
          0
        );

      hash = Math.abs(hash) % 12;
      console.log(
        "name= " + name + " ,hash= " + hash + " color=" + colorarray[hash]
      );

      return colorarray[hash];
    };

    var margin = { top: 10, right: 5, bottom: 20, left: 10 },
      width = 1400 - margin.left - margin.right,
      height = 1200 - margin.top - margin.bottom;

    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3: width=${width} height=${height} margin=${JSON.stringify(
        margin
      )}`,
      `width=${width} height=${height} margin=${JSON.stringify(margin)}`,
      `${TAG}`
    );

    console.log("clean up svg");
    //clean up any previous svg.d3 descendents
    let svg = d3.select(this.template.querySelector(".nest"));
    svg.selectAll("*").remove();

    svg = d3
      .select(this.template.querySelector(".nest"))
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    console.log(
      `entering grid processing, this.result=${JSON.stringify(this.result)}`
    );

    let _gridData = this.result.map((row) => {
      //console.log(`row = ${JSON.stringify(row)}`);
      let _counter = 0;
      let _sdData = row.SDs__r.map((sd) => {
        let key = row.Name + "-" + sd.Name;
        let _value = this.sdcountmap.has(key)
          ? this.sdcountmap.get(key) + 1
          : 1;
        let _desc =
          sd.Description__c == undefined
            ? "No description recorded for this SD"
            : sd.Description__c;
        _counter += _value - 1;
        return {
          name: this.truncate(sd.Name, 50),
          value: _value,
          progname: row.Name,
          description: _desc,
          allocated: _value - 1,
          fullname: sd.Name
        };
      });

      _sdData.sort((a, b) => parseFloat(b.allocated) - parseFloat(a.allocated));

      return {
        name: this.truncate(row.Name, 15),
        counter: _counter,
        children: _sdData
      };
    });

    _gridData.sort((a, b) => parseFloat(b.counter) - parseFloat(a.counter));

    if (this.isSelected) {
      _gridData = _gridData.filter((d) => d.counter > 0);
    }

    //c/d3HeatMapconsole.log(`_gridData=${JSON.stringify(_gridData)}`);

    this.programsDisplayed = _gridData.length;

    this.gridDataTree = { children: _gridData };

    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3: this.gridDataTree=${JSON.stringify(
        this.gridDataTree
      )}`,
      `draw a d3.hierarchy using gridDataTree (logged)`,
      `${TAG}`
    );

    var root = d3.hierarchy(this.gridDataTree).sum(function (d) {
      return d.value;
    });

    const tooltip = d3
      .select(this.template.querySelector(".nest"))
      .append("span")
      .style("opacity", 0)
      .attr("class", "tooltip")
      .style("font-size", "12px");

    const mouseover = (e, d) => {
      tooltip.transition().duration(600).style("opacity", 0.9);
      tooltip
        .html(
          `<span style='color:white'>${d.data.progname}<br/>${d.data.fullname}<br>${d.data.description}<br/>No of related Client Objectives= ${d.data.allocated} </span>`
        )
        .style("left", d3.pointer(e)[0] + 30 + "px")
        .style("top", d3.pointer(e)[1] + 30 + "px");
    };
    const mousemove = (e) => {
      tooltip
        .style("left", d3.pointer(e)[0] + 30 + "px")
        .style("top", d3.pointer(e)[1] + 30 + "px");
    };
    const mouseleave = (e) => {
      tooltip.transition().duration(200).style("opacity", 0);
    };

    d3
      .treemap()
      .size([width, height])
      .paddingTop(28)
      .paddingRight(10)
      .paddingInner(4)(
      // Padding between each rectangle
      //.paddingOuter(6)
      //.padding(20)
      root
    );

    svg
      .selectAll("rect")
      .data(root.leaves())
      .enter()
      .append("rect")
      .attr("x", function (d) {
        return d.x0;
      })
      .attr("y", function (d) {
        return d.y0;
      })
      .attr("width", function (d) {
        return d.x1 - d.x0;
      })
      .attr("height", function (d) {
        return d.y1 - d.y0;
      })
      .style("stroke", "black")
      .style("fill", function (d) {
        return mycolor(d.parent.data.name);
        //return d.data.value == 1 ? "#EBF5F2" : "#72B9A8";
        //return d.data.value == 1 ? "#838996	" : "#6AB3A3";
        //return d.data.value == 1 ? "#E7F0F7" : "#91BE5A";
      })
      .style("opacity", function (d) {
        return d.data.value == 1 ? 0.1 : 0.8;
      })
      .on("mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave);

    svg
      .selectAll("text")
      .data(root.leaves())
      .enter()
      .append("text")
      .selectAll("tspan")
      .data((d) => {
        let val = d.data.value - 1;
        d.data.name = "[" + val + "]  " + d.data.name;
        return d.data.name
          .split(" ") //
          .map((v) => {
            return {
              text: v,
              x0: d.x0, // keep x0 reference
              y0: d.y0 // keep y0 reference
            };
          });
      })
      .enter()
      .append("tspan")
      .attr("x", (d) => d.x0 + 5)
      .attr("y", (d, i) => d.y0 + 15 + i * 10) // offset by index
      .text((d) => d.text)
      .attr("font-size", "10px")
      .attr("fill", "black");
    //.style("font-weight", "bold");

    // and to add the text labels
    // svg
    //   .selectAll("vals")
    //   .data(root.leaves())
    //   .enter()
    //   .append("text")
    //   .attr("x", function (d) {
    //     return d.x0 + 5;
    //   }) // +10 to adjust position (more right)
    //   .attr("y", function (d) {
    //     return d.y0 + 50;
    //   }) // +20 to adjust position (lower)
    //   .text(function (d) {
    //     return d.data.value - 1;
    //   })
    //   .attr("font-size", "10px")
    //   .attr("fill", "white");
    svg
      .selectAll("titles")
      .data(
        root.descendants().filter(function (d) {
          return d.depth == 1;
        })
      )
      .enter()
      .append("text")
      .attr("x", function (d) {
        return d.x0;
      })
      .attr("y", function (d) {
        return d.y0 + 21;
      })
      .text(function (d) {
        return d.data.name;
      })
      .attr("font-size", "12px")
      .attr("fill", "black");

    // Add title for the 3 groups
  }

  handleClick() {
    console.log("click");
    this.isSelected = !this.isSelected;
    this.composeOptions();
  }

  handleStageChange(event) {
    console.log("in handleSDChange " + event.detail.value);
    const selectedOption = event.detail.value;
    this.stageoptions = this.stageoptions.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    console.log("in handleStageChange " + JSON.stringify(this.stageoptions));

    this.composeOptions();
  }

  truncate(string, limit) {
    if (string.length <= limit || this.isSelected == true) {
      return string;
    }
    return string.slice(0, limit) + "...";
  }

  /* assemble and execute the calls to Apex based on selections */
  composeOptions() {
    console.log("in composeOptions");

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): entering `,
      "composeOptions()",
      `${TAG}`
    );
    //find the curent Stage
    let stageoptionJson = this.stageoptions.find((item) => {
      return item.isChecked == true;
    });
    let stageStr = stageoptionJson.label;
    console.log("stageStr=" + stageStr);

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): calling Apex getProgramsAndSds,stageStr=${stageStr} `,
      "calling Apex getProgramsAndSds",
      `${TAG}`
    );

    getProgramsAndSds({
      stageStr: stageStr
    })
      .then((result) => {
        logDebug(
          this.recordId,
          `${COMPONENT}.composeOptions(): returned from Apex call, ${result.length} items returned`,
          `returned ${result.length} items`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.composeOptions(): result=${JSON.stringify(result)}`,
          `setting this.result, calling initializeD3()`,
          `${TAG}`
        );

        this.result = result;
        console.log("filtered result=" + JSON.stringify(result));
        this.initializeD3();
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.composeOptions(): Apex call returned error: ${error}`,
          `${COMPONENT}.composeOptions(): Apex call returned error: ${error}`,
          `${TAG}`
        );
      });
  }
}
