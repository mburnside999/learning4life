import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import getClientObjectivesSDCount from "@salesforce/apex/L4LSessionStatsController.getClientObjectivesSDCount";
import getProgramsAndSds from "@salesforce/apex/L4LSessionStatsController.getProgramsAndSds";
import D3 from "@salesforce/resourceUrl/d3";

export default class D3Nest extends LightningElement {
  //the clientId from UI
  @api recordId;

  //chart dimensions
  svgWidth = 1000;
  svgHeight = 800;

  @track result; //raw returned records from Apex query
  @track gridDataTree = []; //the data that D3 iterates across
  @track sdcountarray = [];
  sdcountmap = new Map();
  d3Initialized = false; //rendering and control flags

  connectedCallback() {
    console.log("in connectedCallback recordId=" + this.recordId);
  }

  renderedCallback() {
    console.log("in renderedCallback recordId=" + this.recordId);

    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;

    //load D3
    Promise.all([loadScript(this, D3 + "/d3.v5.min.js")])
      .then(async () => {
        let _result = (this.result = await getProgramsAndSds({})); //this shenanigans was to get D3 to wait for the Apex to finish
        console.log("NEST RESULT=>" + JSON.stringify(this.result));
      })
      .then(async () => {
        let _sdcountarray = (this.sdcountarray =
          await getClientObjectivesSDCount({ clientId: this.recordId })); //this shenanigans was to get D3 to wait for the Apex to finish
        console.log("SD RESULT=>" + JSON.stringify(this.sdcountarray));
        this.sdcountarray.map((object) => {
          this.sdcountmap.set(
            object.progname + "-" + object.sdname,
            object.sdcount
          );
        });
        console.log("SD MAP=" + this.sdcountmap);
        //let d3test = { children: result };
        //console.log("NEST D3Test=>" + JSON.stringify(d3test));
      })
      .then(() => {
        console.log("NEST calling initializeD3()");
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

    var margin = { top: 10, right: 10, bottom: 20, left: 10 },
      width = 1300 - margin.left - margin.right,
      height = 1000 - margin.top - margin.bottom;

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

    let _gridData = this.result.map((row) => {
      let _sdData = row.SDs__r.map((sd) => {
        let key = row.Name + "-" + sd.Name;
        let _value = this.sdcountmap.has(key)
          ? this.sdcountmap.get(key) + 1
          : 1;
        let _desc =
          sd.Description__c == undefined
            ? "No description recorded for this SD"
            : sd.Description__c;
        return {
          name: this.truncate(sd.Name, 15),
          value: _value,
          progname: row.Name,
          description: _desc,
          allocated: _value - 1,
          fullname: sd.Name
        };
      });

      return { name: this.truncate(row.Name, 15), children: _sdData };
    });

    this.gridDataTree = { children: _gridData };

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
        return d.data.value == 1 ? "#838996" : "green";
        //return d.data.value == 1 ? "#838996	" : "#6AB3A3";
        //return d.data.value == 1 ? "#E7F0F7" : "#91BE5A";
      })
      .style("opacity", 0.8)
      .on("mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave);

    svg
      .selectAll("text")
      .data(root.leaves())
      .enter()
      .append("text")
      .attr("x", function (d) {
        return d.x0 + 5;
      }) // +10 to adjust position (more right)
      .attr("y", function (d) {
        return d.y0 + 20;
      }) // +20 to adjust position (lower)
      .text(function (d) {
        return d.data.name.replace("mister_", "");
      })
      .attr("font-size", "11px")
      .attr("fill", "white")
      .style("font-weight", "bold");

    // and to add the text labels
    svg
      .selectAll("vals")
      .data(root.leaves())
      .enter()
      .append("text")
      .attr("x", function (d) {
        return d.x0 + 5;
      }) // +10 to adjust position (more right)
      .attr("y", function (d) {
        return d.y0 + 35;
      }) // +20 to adjust position (lower)
      .text(function (d) {
        return d.data.value - 1;
      })
      .attr("font-size", "11px")
      .attr("fill", "white");
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

  truncate(string, limit) {
    if (string.length <= limit) {
      return string;
    }
    return string.slice(0, limit) + "...";
  }
}
