import { LightningElement, track, api } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import generateD3ProgramAreaSDJson from "@salesforce/apex/L4LSessionStatsController.generateD3ProgramAreaSDJson";

import D3 from "@salesforce/resourceUrl/d3";

export default class D3NestExperiment extends LightningElement {
  //the clientId from UI
  @api recordId;

  //chart dimensions
  svgWidth = 1400;
  svgHeight = 1200;

  isSelected = false;
  // '{"children":[{"name": "flare","children": [{"name":"2D Matching","children":[{"name":"Matching","children":[{"name":"Identical","value":"20"},{"name":"Non-Identical","value":"20"}]}]},{"name":"3D Matching","children":[{"name":"Abstract Concepts","children":[{"name":"Identical","value":"20"}]},{"name":"Play-Skills","children":[{"name":"Non-identical","value":"20"}]}]},{"name":"3D to 2D Matching","children":[{"name":"Expressive Language","children":[{"name":"Identical","value":"20"}]}]},{"name":"Actions","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":"20"}]},{"name":"Kinder Readiness","children":[{"name":"Receptive Person","value":"20"}]},{"name":"Receptive-Language","children":[{"name":"Expressive","value":"20"}]}]},{"name":"Animal Sounds","children":[{"name":"Expressive Language","children":[{"name":"Expressive Q/A","value":"20"}]}]},{"name":"Arts and Crafts","children":[{"name":"Kinder Readiness","children":[{"name":"Colouring","value":"20"}]}]},{"name":"Associations","children":[{"name":"Self-Care","children":[{"name":"Receptive","value":"20"}]}]},{"name":"Ball Skills","children":[{"name":"Imitation","children":[{"name":"Imitation","value":"20"}]}]},{"name":"Book Labels","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":"20"}]}]},{"name":"Bring Me","children":[{"name":"Self-Care","children":[{"name":"Item","value":"20"}]}]},{"name":"Categories","children":[{"name":"SelfCare","children":[{"name":"Brainstorming","value":"20"}]}]},{"name":"Come Here","children":[{"name":"Play Skills","children":[{"name":"1 person","value":"20"}]}]},{"name":"Communication Temptation","children":[{"name":"Communication","children":[{"name":"Communication opportunity","value":"20"}]}]},{"name":"Fine motor imitation","children":[{"name":"Social Play Skills","children":[{"name":"1 step","value":"20"}]}]}]}]}'
  //'{"children":[{"name": "flare","children": [{"name":"3D Matching","children":[{"name":"Abstract Concepts","children":[{"name":"Identical","value":"20"}]},{"name":"Play-Skills","children":[{"name":"Non-identical","value":"20"}]}]},{"name":"3D to 2D Matching","children":[{"name":"Expressive Language","children":[{"name":"Identical","value":"20"}]}]},{"name":"Actions","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":"20"}]},{"name":"Kinder Readiness","children":[{"name":"Receptive Person","value":"20"}]},{"name":"Receptive-Language","children":[{"name":"Expressive","value":"20"}]}]},{"name":"Animal Sounds","children":[{"name":"Expressive Language","children":[{"name":"Expressive Q/A","value":"20"}]}]},{"name":"Arts and Crafts","children":[{"name":"Kinder Readiness","children":[{"name":"Colouring","value":"20"}]}]},{"name":"Categories","children":[{"name":"SelfCare","children":[{"name":"Brainstorming","value":"20"}]}]}]}]}'
  //'{"children":[{"name": "flare","children": [{"name":"2D Matching","children":[{"name":"Matching","children":[{"name":"Identical","value":"20"},{"name":"Non-Identical","value":"20"}]}]},{"name":"Actions","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":"20"}]},{"name":"Kinder Readiness","children":[{"name":"Receptive Person","value":"20"}]},{"name":"Receptive-Language","children":[{"name":"Expressive","value":"20"}]}]},{"name":"Associations","children":[{"name":"Self-Care","children":[{"name":"Receptive","value":"20"}]}]},{"name":"Ball Skills","children":[{"name":"Imitation","children":[{"name":"Imitation","value":"20"}]}]},{"name":"Book Labels","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":"20"}]}]},{"name":"Bring Me","children":[{"name":"Self-Care","children":[{"name":"Item","value":"20"}]}]},{"name":"Come Here","children":[{"name":"Play Skills","children":[{"name":"1 person","value":"20"}]}]},{"name":"Communication Temptation","children":[{"name":"Communication","children":[{"name":"Communication opportunity","value":"20"}]}]},{"name":"Fine motor imitation","children":[{"name":"Social Play Skills","children":[{"name":"1 step","value":"20"}]}]}]}]}'
  //'{"children":[{"name": "flare","children": [{"name":"2D Matching","children":[{"name":"Matching","children":[{"name":"Identical","value":1 },{"name":"Non-Identical","value":2 }]}]},{"name":"3D Matching","children":[{"name":"Abstract Concepts","children":[{"name":"Identical","value":0 }]},{"name":"Play-Skills","children":[{"name":"Non-identical","value":0 }]}]},{"name":"3D to 2D Matching","children":[{"name":"Expressive Language","children":[{"name":"Identical","value":0 }]}]},{"name":"Actions","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":0 }]},{"name":"Kinder Readiness","children":[{"name":"Receptive Person","value":0 }]},{"name":"Receptive-Language","children":[{"name":"Expressive","value":0 }]}]},{"name":"Animal Sounds","children":[{"name":"Expressive Language","children":[{"name":"Expressive Q/A","value":0 }]}]},{"name":"Arts and Crafts","children":[{"name":"Kinder Readiness","children":[{"name":"Colouring","value":0 }]}]},{"name":"Associations","children":[{"name":"Self-Care","children":[{"name":"Receptive","value":0 }]}]},{"name":"Ball Skills","children":[{"name":"Imitation","children":[{"name":"Imitation","value":0 }]}]},{"name":"Book Labels","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":0 }]}]},{"name":"Bring Me","children":[{"name":"Self-Care","children":[{"name":"Item","value":0 }]}]},{"name":"Categories","children":[{"name":"SelfCare","children":[{"name":"Brainstorming","value":0 }]}]},{"name":"Come Here","children":[{"name":"Play Skills","children":[{"name":"1 person","value":0 }]}]},{"name":"Communication Temptation","children":[{"name":"Communication","children":[{"name":"Communication opportunity","value":0 }]}]},{"name":"Fine motor imitation","children":[{"name":"Social Play Skills","children":[{"name":"1 step","value":0 }]}]}]}]}
  //{"children":[{"name": "flare","children": [{"name":"2D Matching","children":[{"name":"Matching","children":[{"name":"Identical","value":1 },{"name":"Non-Identical","value":2 }]}]},{"name":"3D Matching","children":[{"name":"Abstract Concepts","children":[{"name":"Identical","value":0 }]},{"name":"Play-Skills","children":[{"name":"Non-identical","value":0 }]}]},{"name":"3D to 2D Matching","children":[{"name":"Expressive Language","children":[{"name":"Identical","value":0 }]}]},{"name":"Actions","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":0 }]},{"name":"Kinder Readiness","children":[{"name":"Receptive Person","value":0 }]},{"name":"Receptive-Language","children":[{"name":"Expressive","value":0 }]}]},{"name":"Animal Sounds","children":[{"name":"Expressive Language","children":[{"name":"Expressive Q/A","value":0 }]}]},{"name":"Arts and Crafts","children":[{"name":"Kinder Readiness","children":[{"name":"Colouring","value":0 }]}]},{"name":"Associations","children":[{"name":"Self-Care","children":[{"name":"Receptive","value":0 }]}]},{"name":"Ball Skills","children":[{"name":"Imitation","children":[{"name":"Imitation","value":0 }]}]},{"name":"Book Labels","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":0 }]}]},{"name":"Bring Me","children":[{"name":"Self-Care","children":[{"name":"Item","value":0 }]}]},{"name":"Categories","children":[{"name":"SelfCare","children":[{"name":"Brainstorming","value":0 }]}]},{"name":"Come Here","children":[{"name":"Play Skills","children":[{"name":"1 person","value":0 }]}]},{"name":"Communication Temptation","children":[{"name":"Communication","children":[{"name":"Communication opportunity","value":0 }]}]},{"name":"Fine motor imitation","children":[{"name":"Social Play Skills","children":[{"name":"1 step","value":0 }]}]}]}]}';

  // @track gridDataTree = JSON.parse(
  //   '{"children":[{"name": "flare","children": [{"name":"2D Matching","children":[{"name":"Matching","children":[{"name":"Identical","value":2 },{"name":"Non-Identical","value":3 }]}]},{"name":"3D Matching","children":[{"name":"Abstract Concepts","children":[{"name":"Identical","value":1 }]},{"name":"Play-Skills","children":[{"name":"Non-identical","value":1 }]}]},{"name":"3D to 2D Matching","children":[{"name":"Expressive Language","children":[{"name":"Identical","value":1 }]}]},{"name":"Actions","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":1 }]},{"name":"Kinder Readiness","children":[{"name":"Receptive Person","value":1 }]},{"name":"Receptive-Language","children":[{"name":"Expressive","value":1 }]}]},{"name":"Animal Sounds","children":[{"name":"Expressive Language","children":[{"name":"Expressive Q/A","value":1 }]}]},{"name":"Arts and Crafts","children":[{"name":"Kinder Readiness","children":[{"name":"Colouring","value":1 }]}]},{"name":"Associations","children":[{"name":"Self-Care","children":[{"name":"Receptive","value":1 }]}]},{"name":"Ball Skills","children":[{"name":"Imitation","children":[{"name":"Imitation","value":1 }]}]},{"name":"Book Labels","children":[{"name":"Learning to Learn","children":[{"name":"Receptive","value":1 }]}]},{"name":"Bring Me","children":[{"name":"Self-Care","children":[{"name":"Item","value":1 }]}]},{"name":"Categories","children":[{"name":"SelfCare","children":[{"name":"Brainstorming","value":1 }]}]},{"name":"Come Here","children":[{"name":"Play Skills","children":[{"name":"1 person","value":1 }]}]},{"name":"Communication Temptation","children":[{"name":"Communication","children":[{"name":"Communication opportunity","value":1 }]}]},{"name":"Fine motor imitation","children":[{"name":"Social Play Skills","children":[{"name":"1 step","value":1 }]}]}]}]}'
  // );

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

  @track gridDataTree;
  @track result; //raw returned records from Apex query
  @track sdcountarray = [];
  sdcountmap = new Map();
  d3Initialized = false; //rendering and control flags
  programsDisplayed = 0;
  stageoptionval = "All";

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
        let _result = (this.result = await generateD3ProgramAreaSDJson({
          clientId: this.recordId,
          stageStr: "All"
        })); //this shenanigans was to get D3 to wait for the Apex to finish
        console.log(_result);
        //console.log("NEST RESULT=>" + JSON.stringify(this.result));
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
    this.gridDataTree = JSON.parse(this.result);

    console.log("NEST in initializeD3()");

    var margin = { top: 10, right: 10, bottom: 10, left: 10 },
      width = 1400 - margin.left - margin.right,
      height = 800 - margin.top - margin.bottom;

    // clean up any previous svg.d3 descendents
    let svg = d3.select(this.template.querySelector(".nest"));
    svg.selectAll("*").remove();

    svg = d3
      .select(this.template.querySelector(".nest"))
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var root = d3.hierarchy(this.gridDataTree).sum(function (d) {
      return d.value;
    });

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
      .style("fill", function (d) {
        return d.data.value == 1 ? "#EBF5F2" : "#72B9A8";
        //return d.data.value == 1 ? "#838996	" : "#6AB3A3";
        //return d.data.value == 1 ? "#E7F0F7" : "#91BE5A";
      })
      .style("stroke", "black");

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
        return d.data.name;
      })
      .attr("font-size", "12px")
      .attr("fill", "black");
    //.style("font-weight", "bold");

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
      .attr("font-size", "10px")
      .attr("fill", "black");

    // Add title for the 3 groups
    svg
      .selectAll("titles")
      .data(
        root.descendants().filter(function (d) {
          return d.depth == 3;
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
      .attr("fill", function (d) {
        return color(d.data.name);
      });

    // Add title for the 3 groups
    svg
      .append("text")
      .attr("x", 0)
      .attr("y", 14) // +20 to adjust position (lower)
      .text("Three group leaders and 14 employees")
      .attr("font-size", "19px")
      .attr("fill", "grey");
  }

  /* assemble and execute the calls to Apex based on selections */
  handleStageChange(event) {
    console.log("in handleSDChange " + event.detail.value);
    const selectedOption = event.detail.value;
    this.stageoptions = this.stageoptions.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    console.log("in handleStageChange " + JSON.stringify(this.stageoptions));

    this.composeOptions();
  }

  composeOptions() {
    console.log("in composeOptions");

    //find the curent Stage
    let stageoptionJson = this.stageoptions.find((item) => {
      return item.isChecked == true;
    });
    let stageStr = stageoptionJson.label;
    console.log("stageStr=" + stageStr);

    generateD3ProgramAreaSDJson({
      clientId: this.recordId,
      stageStr: stageStr
    })
      .then((result) => {
        this.result = result;
        console.log("filtered result=" + JSON.stringify(result));
        this.initializeD3();
      })
      .catch((error) => {
        this.error = error;
      });
  }
}
