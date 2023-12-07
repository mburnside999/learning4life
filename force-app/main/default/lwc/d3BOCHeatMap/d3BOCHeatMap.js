// Mikes D3 based heatmap
import { LightningElement, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import generateD3BOCJson from "@salesforce/apex/L4LSessionStatsController.generateD3BOCJson";

import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";

const COMPONENT = "D3BOCHeatMap";
const TAG = "L4L-Session-Statistics-D3BOCHeatMap";
const SCENARIO = "View D3BOCHeatMap - LWC";
const UI_EVENT_TRACKING_SCENARIO = "d3BOCHeatMap LWC UI Event Tracking";
const APEX_EVENT_TRACKING_SCENARIO = "d3BOCHeatMap LWC APEX Event Tracking";
export default class D3BOCHeatMap extends LightningElement {
  @api lwcTitle = "Client BOC Analysis";
  @api chartTitle = "D3 Chart";
  @api chartSubTitle = "D3 Chart";

  low = 1;
  high = 3; //actual values come from custom metadata

  periodoptions = [
    { label: "All", value: "All" },
    { label: "1 Day", value: "1" },
    { label: "7 Days", value: "7" },
    { label: "14 Days", value: "14" },
    { label: "30 Days", value: "30", isChecked: true },
    { label: "60 Days", value: "60" },
    { label: "90 Days", value: "90" },
    { label: "180 Days", value: "180" },
    { label: "365 Days", value: "365" }
  ];

  periodval = "30";

  //the clientId from UI
  @api recordId;

  //chart dimensions
  svgWidth = 1200;
  svgHeight = 900;

  // the X and Y axes Arrays
  @track sessionXAxisArray = [];
  @track behaviourYAxisArray = [];

  //helper Sets for chart dimensions and radio group buttons
  sessionsSet = new Set([]);
  behavioursSet = new Set([]);

  @track result; //raw returned records from Apex query
  @track resultObj;
  @track gridData = []; //the data that D3 iterates across

  d3Initialized = false; //rendering and control flags

  connectedCallback() {
    console.log("in connectedCallback recordId=" + this.recordId);
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback()`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, call to L4LNebulaComponentController setupCache completed `,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  renderedCallback() {
    console.log("in renderedCallback recordId=" + this.recordId);

    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LSessionStatsController.generateD3BOCJson`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    //load D3
    Promise.all([loadScript(this, D3 + "/d3.v5.min.js")])
      .then(async () => {
        let _result = (this.result = await generateD3BOCJson({
          clientId: this.recordId,
          periodStr: "30"
        }));
        console.log(_result);
        //this shenanigans was to get D3 to wait for the Apex to finish
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
    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3(): wranglng data and drawing the HeatMap chart `,
      `${SCENARIO}`,
      `${TAG}`
    );
    console.log("in initializeD3()");

    //these helper sets produce the dimensions and group buttons
    this.sessionsSet = new Set([]);
    this.behavioursSet = new Set([]);

    //local variables to convert the __r field names received from Apex
    let session;
    let behaviour;
    let sessiondate;
    let totalduration;
    let present;
    let value;

    this.sessionXAxisArray = [];
    this.behaviourYAxisArray = [];
    this.gridData = [];

    console.log("ready to parse result ===>" + JSON.stringify(this.result));
    this.resultObj = JSON.parse(this.result);
    this.gridData = this.resultObj.map((row) => {
      this.sessionsSet.add(row.session);
      this.behavioursSet.add(row.behaviour);
      session = row.session;
      behaviour = row.behaviour;
      sessiondate = row.sessiondate;
      totalduration = row.totalduration;
      present = row.present;
      value = row.times;
      return {
        session,
        behaviour,
        sessiondate,
        totalduration,
        present,
        value
      };
    });

    console.log("this.gridData" + JSON.stringify(this.gridData));

    const sortedSDStrings = Array.from(this.sessionsSet).sort();
    let sdSetSorted = new Set(sortedSDStrings);
    //X Axis from set
    let sessionSetIterator = sdSetSorted.values();
    // List all Values
    for (const entry of sessionSetIterator) {
      console.log("Session = " + entry);
      let s = this.sessionXAxisArray;
      s.push(entry);
    }

    //sort the behaviours
    const sortedStrings = Array.from(this.behavioursSet).sort();
    let behavioursSetSorted = new Set(sortedStrings);

    //iterate through the sorted objectives set
    let behaviourSetIterator = behavioursSetSorted.values();
    for (const entry of behaviourSetIterator) {
      console.log("Behaviour = " + entry);
      let s = this.behaviourYAxisArray;
      s.push(entry);
    }

    //clean up any previous svg.d3 descendents
    let svg = d3.select(this.template.querySelector(".scatterplot"));
    svg.selectAll("*").remove();

    var margin = { top: 50, right: 30, bottom: 60, left: 300 },
      width = 1200 - margin.left - margin.right,
      height = 400 - margin.top - margin.bottom;

    let make_x_gridlines = () => {
      return d3.axisBottom(x).ticks(5);
    };

    // gridlines in y axis function
    let make_y_gridlines = () => {
      return d3.axisLeft(y).ticks(5);
    };

    svg = d3
      .select(this.template.querySelector(".scatterplot"))
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    let d3sessionXAxis = this.sessionXAxisArray;
    let d3behaviourYAxisArray = this.behaviourYAxisArray;

    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3(): X-axis: ${d3sessionXAxis}`,
      `X-axis: ${d3sessionXAxis}`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3(): Y-axis:  ${d3behaviourYAxisArray} `,
      `Y-axis:  ${d3behaviourYAxisArray}`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3(): this.gridData:  ${JSON.stringify(
        this.gridData
      )} `,
      `${COMPONENT}.initializeD3(): this.gridData:  ${JSON.stringify(
        this.gridData
      )} `,
      `${TAG}`
    );
    // Build X scales and axis:
    let x = d3
      .scaleBand()
      .range([0, width])
      .domain(d3sessionXAxis)
      .padding(0.01);
    svg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x))
      .selectAll("text")
      .style("text-anchor", "end")
      .attr("dx", "-.8em")
      .attr("dy", ".15em")
      .attr("transform", "rotate(-45)");

    // Build Y scales and axis:
    let y = d3
      .scaleBand()
      .range([height, 0])
      .domain(d3behaviourYAxisArray)
      .padding(0.01);
    svg.append("g").call(d3.axisLeft(y));

    svg
      .append("g")
      .attr("class", "grid")
      .attr("transform", "translate(0," + height + ")")
      .call(make_x_gridlines().tickSize(-height).tickFormat(""));

    svg
      .append("g")
      .attr("class", "grid")
      .call(make_y_gridlines().tickSize(-width).tickFormat(""));

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
          `<span style='color:white'>Session: ${d.session}<br/>Date: ${d.sessiondate}<br/>Behaviour: ${d.behaviour}<br/>Total Duration: ${d.totalduration}<br/>Occurrences: ${d.value}<br/><br/>Present: ${d.present}</span>`
        )
        .style("left", d3.pointer(e)[0] + 80 + "px")
        .style("top", d3.pointer(e)[1] + 3 + "px");
    };
    const mousemove = (e) => {
      tooltip
        .style("left", d3.pointer(e)[0] + 80 + "px")
        .style("top", d3.pointer(e)[1] + 3 + "px");
    };
    const mouseleave = (e) => {
      tooltip.transition().duration(200).style("opacity", 0);
    };

    // if (this.respondedval == "true") {
    svg
      .append("g")
      .selectAll()
      .data(this.gridData, function (d) {
        return d.session;
      })
      .enter()
      .append("rect")
      .attr("x", function (d) {
        return x(d.session);
      })
      .attr("y", function (d) {
        return y(d.behaviour);
      })
      .attr("width", x.bandwidth())
      .attr("height", y.bandwidth())
      .style("opacity", (d) => {
        return 0.7; // experiments with opacity - currently not used
      })
      .style("fill", (d) => {
        if (d.present == "true") {
          if (d.value == "0") {
            return "#008000"; //green
          } else if (d.value == null) {
            return "#7393B3"; //bluegrey
          } else {
            return "#FF0000"; //red
          }
        } else return "#E5E4E2"; //platinum
      })
      .on("mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave);
    console.log("x=" + (width - 360) / 2);
    console.log("width=" + width);

    svg
      .append("text")
      .attr("x", width / 2)
      .attr("y", -30)
      .attr("text-anchor", "middle")
      .style("font-size", "18px")
      .style("fill", "grey")
      .text(`${this.chartTitle}`);

    //Add subtitle to graph
    svg
      .append("text")
      .attr("x", width / 2)
      .attr("y", -10)
      .attr("text-anchor", "middle")
      .style("font-size", "14px")
      .style("fill", "grey")
      .text(`${this.chartSubTitle}`);
  }

  // the ACQ/ALL handler
  handleClick() {
    this.isSelected = !this.isSelected;
    this.composeOptions();
  }

  //the period change handler
  handlePeriodChange(event) {
    console.log("in handlePeriodChange " + event.detail.value);

    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Period Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    const selectedOption = event.detail.value;
    this.periodoptions = this.periodoptions.map((row) => {
      return { ...row, isChecked: row.value === selectedOption };
    });
    console.log("in handlePeriodChange " + JSON.stringify(this.periodoptions));
    this.composeOptions();
  }

  /* assemble and execute the calls to Apex based on selections */
  composeOptions() {
    console.log("in composeOptions");

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): entering `,
      `${SCENARIO}`,
      `${TAG}`
    );

    console.log("period options=" + JSON.stringify(this.periodoptions));
    //find the curent Period
    let periodoptionJson = this.periodoptions.find((item) => {
      return item.isChecked == true;
    });
    let periodStr = periodoptionJson.value;
    console.log("periodStr=" + periodStr);

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): calling Apex generateD3BOCJson`,
      `${SCENARIO}`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): clientId=${this.recordId},periodStr=${periodStr}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LSessionStatsController.generateD3BOCJson`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    generateD3BOCJson({
      clientId: this.recordId,
      periodStr: periodStr
    })
      .then((result) => {
        logDebug(
          this.recordId,
          `${COMPONENT}.composeOptions(): returned from Apex call, ${result.length} items returned`,
          `${SCENARIO}`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.composeOptions(): result=${JSON.stringify(result)}`,
          `${SCENARIO}`,
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
          `${COMPONENT}.composeOptions(): Apex call returned error: ${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }
}
