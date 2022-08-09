import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";
import getD3Stats from "@salesforce/apex/L4LSessionStatsController.getD3Stats";
import getD3StatsByProgram from "@salesforce/apex/L4LSessionStatsController.getD3StatsByProgram";
import D3 from "@salesforce/resourceUrl/d3";

export default class D3HeatMap extends LightningElement {
  /* the programs radio group */
  options = [
    { label: "All", value: "All", isChecked: true }
    // { label: "2D Matching", value: "2D Matching" },
    // { label: "Color", value: "Color" },
    // { label: "Bring Me", value: "Bring Me" }
  ];
  optionval = "All"; //default

  //the clientId from UI
  @api recordId;

  //chart dimensions
  svgWidth = 1000;
  svgHeight = 600;

  // the X and Y axes Arrays
  @track sessionXAxisArray = [];
  @track progYAxisArray = [];

  //helper Sets for chart dimensions and radio group buttons
  sessionsSet = new Set([]);
  objsSet = new Set([]);
  progs = new Set([]);

  @track result; //raw returned records from Apex query
  @track gridData = []; //the data that D3 iterates across

  d3Initialized = false; //rendering and control flags
  programsrendered = false;
  isSelected = false;

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
        let result = (this.result = await getD3Stats({
          clientId: this.recordId,
          showAcquired: this.isSelected
        })); //this shenanigans was to get D3 to wait for the Apex to finish
      })
      .then(() => {
        console.log("calling initializeD3()");
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
    console.log("in initializeD3()");

    //these helper sets produce the dimensions and group buttons
    this.sessionsSet = new Set([]);
    this.objsSet = new Set([]);
    this.progsSet = new Set([]);

    //local variables to convert the __r field names received from Apex
    let session;
    let objective;
    let value;
    let previous_status;
    let sessiondate;
    let programName;

    this.sessionXAxisArray = [];
    this.progYAxisArray = [];
    this.gridData = [];

    this.gridData = this.result.map((row) => {
      console.log("=======" + row.Session__r.Name);
      this.sessionsSet.add(row.Session__r.Name);
      this.objsSet.add(row.Objective__r.Name);
      this.progsSet.add(row.Program_Name__c);
      session = row.Session__r.Name;
      objective = row.Objective__r.Name;
      programName = row.Program_Name__c;
      previous_status = row.Previous_Status__c;
      sessiondate = row.Session__r.Date__c;
      value = row.Percent_Correct__c;

      return {
        session,
        objective,
        value,
        previous_status,
        sessiondate,
        programName
      };
    });

    console.log("this.gridData" + JSON.stringify(this.gridData));

    let sessionSetIterator = this.sessionsSet.values();
    // List all Values
    for (const entry of sessionSetIterator) {
      console.log("Session = " + entry);
      let s = this.sessionXAxisArray;
      s.push(entry);
    }

    let objSetIterator = this.objsSet.values();
    for (const entry of objSetIterator) {
      console.log("Objective = " + entry);
      let s = this.progYAxisArray;
      s.push(entry);
    }

    // for the LWC radio group we produce the program buttons once upon rendering
    if (!this.programsrendered) {
      this.options = [{ label: "All", value: "All", isChecked: true }];

      let progSetIterator = this.progsSet.values();
      // List all Values
      for (const entry of progSetIterator) {
        console.log("Program = " + entry);
        this.options.push({ label: entry, value: entry });
      }
      this.programsrendered = true;
    }

    //clean up any previous svg.d3 descendents
    let svg = d3.select(this.template.querySelector(".scatterplot"));
    svg.selectAll("*").remove();

    var margin = { top: 50, right: 30, bottom: 30, left: 200 },
      width = 1000 - margin.left - margin.right,
      height = 600 - margin.top - margin.bottom;

    svg = d3
      .select(this.template.querySelector(".scatterplot"))
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    let d3sessionXAxis = this.sessionXAxisArray;
    let d3progYAxisArray = this.progYAxisArray;

    // Build X scales and axis:
    let x = d3
      .scaleBand()
      .range([0, width])
      .domain(d3sessionXAxis)
      .padding(0.01);
    svg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x));

    // Build Y scales and axis:
    let y = d3
      .scaleBand()
      .range([height, 0])
      .domain(d3progYAxisArray)
      .padding(0.01);
    svg.append("g").call(d3.axisLeft(y));

    // Build color scale
    let myColor = d3.scaleLinear().range(["white", "#69b3a2"]).domain([1, 100]);

    //use the LFL color bands
    let color = d3
      .scaleThreshold()
      .domain([0, 50, 95])
      .range(["#ccc", "red", "orange", "green"]);

    const tooltip = d3
      .select(this.template.querySelector(".scatterplot"))
      .append("span")
      .style("opacity", 0)
      .attr("class", "tooltip")
      .style("font-size", "12px");

    // Three function that change the too
    const mouseover = (e, d) => {
      tooltip.transition().duration(600).style("opacity", 0.9);
      tooltip
        .html(
          `<span style='color:white'>${d.session}<br/>${d.sessiondate}<br/>${d.programName}<br/>Score=${d.value}</span>`
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

    svg
      .append("g")
      .selectAll()
      .data(this.gridData, function (d) {
        return d.session + ":" + d.objective;
      })
      .enter()
      .append("rect")
      .attr("x", function (d) {
        return x(d.session);
      })
      .attr("y", function (d) {
        return y(d.objective);
      })
      .attr("width", x.bandwidth())
      .attr("height", y.bandwidth())
      .style("fill", function (d) {
        return color(d.value);
      })
      .on("mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave);

    svg
      .append("text")
      .attr("x", 0)
      .attr("y", -80)
      .attr("text-anchor", "left")
      .style("font-size", "22px")
      .text("A d3.js heatmap");

    // Add subtitle to graph
    svg
      .append("text")
      .attr("x", 0)
      .attr("y", -20)
      .attr("text-anchor", "left")
      .style("font-size", "16px")
      .style("fill", "grey")
      .style("max-width", 400)
      .text("Objective Mastery per Session - now with tooltips!");
  }

  // the ACQ/ALL handler
  handleClick() {
    this.isSelected = !this.isSelected;
    this.composeOptions();
  }

  //the Program change handler
  handleChange(event) {
    const selectedOption = event.detail.value;
    //record this program as selected
    this.options = this.options.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    this.composeOptions();
  }

  /* assemble and execute the calls to Apex based on selections */
  composeOptions() {
    //find the curent Program
    let optionJson = this.options.find((item) => {
      return item.isChecked == true;
    });
    let calcSelectedOption = optionJson.label;

    //call the Apex
    switch (calcSelectedOption) {
      case "All":
        getD3Stats({
          clientId: this.recordId,
          showAcquired: this.isSelected
        })
          .then((result) => {
            this.result = result;
            this.initializeD3();
          })
          .catch((error) => {
            this.error = error;
          });
        break;
      default:
        getD3StatsByProgram({
          clientId: this.recordId,
          programStr: calcSelectedOption,
          showAcquired: this.isSelected
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

  /* deprecated method */
  // async apexData() {
  //   console.log("APEX DATA calling Apex");
  //   let result = await getD3Stats({
  //     clientId: this.recordId,
  //     showAcquired: this.isSelected
  //   }).then(() => {
  //     console.log("returned");
  //     let session;
  //     let objective;
  //     let value;

  //     this.gridData = result.map((row) => {
  //       console.log("=======" + row.Session__r.Name);
  //       this.sessionsSet.add(row.Session__r.Name);
  //       this.objsSet.add(row.Objective__r.Name);
  //       session = row.Session__r.Name;
  //       objective = row.Objective__r.Name;
  //       value = row.Percent_Correct__c;
  //       return { session, objective, value };
  //     });

  //     console.log("thius.gridData" + JSON.stringify(this.gridData));

  //     let myIterator = this.sessions.values();

  //     // List all Values

  //     for (const entry of myIterator) {
  //       console.log("=========" + entry);
  //       let s = this.sessionXAxisArray;
  //       s.push(entry);
  //     }
  //     console.log("=== mygridsessions ===" + this.sessionXAxisArray);

  //     let myOtherIterator = this.objsSet.values();

  //     for (const entry of myOtherIterator) {
  //       console.log("=========" + entry);
  //       let s = this.progYAxisArray;
  //       s.push(entry);
  //     }

  //     console.log("=== progYAxisArray ===" + this.progYAxisArray);
  //     console.log("returning from Apex");
  //   });
  // }
}
