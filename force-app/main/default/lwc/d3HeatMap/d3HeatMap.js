// Mikes D3 based heatmap
import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import getD3StatsByProgramAndSD from "@salesforce/apex/L4LSessionStatsController.getD3StatsByProgramAndSD";
import getHighAndLowBoundaries from "@salesforce/apex/L4LSessionStatsController.getHighAndLowBoundaries";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logError } from "c/l4lNebulaUtil";

const COMPONENT = "D3HeatMap";
const TAG = "L4L-Session-Statistics-D3HeatMap";

export default class D3HeatMap extends LightningElement {
  low = 50;
  high = 90; //actual values come from custom metadata

  @wire(getHighAndLowBoundaries)
  wiredBoundaries({ error, data }) {
    if (data) {
      this.high = data.High__c * 100;
      this.low = data.Low__c * 100;
      console.log(`high ${this.high} and low ${this.low} `);
    } else if (error) {
      console.log("ERROR in getHighAndLow");
    }
  }

  /* the programs radio group */
  options = [
    { label: "All", value: "All", isChecked: true }
    // { label: "2D Matching", value: "2D Matching" },
    // { label: "Color", value: "Color" },
    // { label: "Bring Me", value: "Bring Me" }
  ];

  statusoptions = [
    { label: "All", value: "false", isChecked: true },
    { label: "ACQ", value: "true" }
  ];

  stageoptions = [
    { label: "All", value: "All", isChecked: true },
    { label: "Stage One", value: "Stage One" },
    { label: "Stage Two", value: "Stage Two" },
    { label: "Stage Three", value: "Stage Three" },
    { label: "Stage Four", value: "Stage Four" },
    { label: "Stage Five", value: "Stage Five" },
    { label: "Stage Six", value: "Stage Six" }
  ];

  sdoptions = [
    { label: "All", value: "All", isChecked: true }
    // { label: "2D Matching", value: "2D Matching" },
    // { label: "Color", value: "Color" },
    // { label: "Bring Me", value: "Bring Me" }
  ];

  periodoptions = [
    { label: "All", value: "All", isChecked: true },
    { label: "1 Day", value: "1" },
    { label: "7 Days", value: "7" },
    { label: "30 Days", value: "30" },
    { label: "60 Days", value: "60" },
    { label: "90 Days", value: "90" },
    { label: "180 Days", value: "180" },
    { label: "365 Days", value: "365" }
  ];

  optionval = "All"; //default
  sdoptionval = "All";
  stageoptionval = "All";
  periodval = "All";
  statusval = "false";

  //the clientId from UI
  @api recordId;

  //chart dimensions
  svgWidth = 1200;
  svgHeight = 900;

  // the X and Y axes Arrays
  @track sessionXAxisArray = [];
  @track progYAxisArray = [];

  //helper Sets for chart dimensions and radio group buttons
  sessionsSet = new Set([]);
  objsSet = new Set([]);
  progsSet = new Set([]);
  sdSet = new Set([]);

  @track result; //raw returned records from Apex query
  @track gridData = []; //the data that D3 iterates across

  d3Initialized = false; //rendering and control flags
  programsrendered = false;
  isSelected = false;

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

  renderedCallback() {
    console.log("in renderedCallback recordId=" + this.recordId);

    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;

    //load D3
    Promise.all([loadScript(this, D3 + "/d3.v5.min.js")])
      .then(async () => {
        let _result = (this.result = await getD3StatsByProgramAndSD({
          clientId: this.recordId,
          programStr: "All",
          sdStr: "All",
          periodStr: "All",
          stageStr: "All",
          showAcquired: this.isSelected
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
      `${COMPONENT}.initializeD3(): entering `,
      "initializing D3",
      `${TAG}`
    );
    console.log("in initializeD3()");

    //these helper sets produce the dimensions and group buttons
    this.sessionsSet = new Set([]);
    this.objsSet = new Set([]);
    this.progsSet = new Set([]);
    this.sdSet = new Set([]);

    //local variables to convert the __r field names received from Apex
    let session;
    let objective;
    let value;
    let previous_status;
    let sessiondate;
    let programName;
    let SDObjStr;
    let SDname;
    let totalCorrect;
    let totalIncorrect;
    let totalPrompted;
    let totalNonResponsive;
    let totalResponses;

    this.sessionXAxisArray = [];
    this.progYAxisArray = [];
    this.gridData = [];

    console.log("ready to parse result ===>" + JSON.stringify(this.result));

    this.gridData = this.result.map((row) => {
      this.sessionsSet.add(row.Session__r.Name);
      //this.objsSet.add(row.Objective__r.Name);
      this.objsSet.add(row.SD_And_Objective_Str__c);
      this.progsSet.add(row.Program_Name__c);
      this.sdSet.add(row.SD_Name__c);
      session = row.Session__r.Name;
      SDObjStr = row.SD_And_Objective_Str__c;
      objective = row.Objective__r.Name;
      programName = row.Program_Name__c;
      previous_status = row.Previous_Status__c;
      sessiondate = row.Session__r.Date__c;
      value = row.Percent_Correct__c;
      SDname = row.SD_Name__c;

      totalCorrect = row.TotalAcquiredCorrect__c;
      totalIncorrect = row.TotalAcquiredIncorrect__c;
      totalPrompted = row.TotalAcquiredPrompted__c;
      totalNonResponsive = row.TotalAcquiredNonResponsive__c;
      totalResponses =
        totalCorrect + totalIncorrect + totalPrompted + totalNonResponsive;
      return {
        session,
        objective,
        value,
        previous_status,
        sessiondate,
        programName,
        SDname,
        SDObjStr,
        totalCorrect,
        totalIncorrect,
        totalPrompted,
        totalNonResponsive,
        totalResponses
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

    //sort the objectives
    const sortedStrings = Array.from(this.objsSet).sort();
    let objsSetSorted = new Set(sortedStrings);

    //iterate through the sorted objectives set
    let objSetIterator = objsSetSorted.values();
    for (const entry of objSetIterator) {
      console.log("Objective = " + entry);
      let s = this.progYAxisArray;
      s.push(entry);
    }

    // for the LWC radio group we produce the program buttons once upon rendering
    if (!this.programsrendered) {
      this.options = [{ label: "All", value: "All", isChecked: true }];
      this.sdoptions = [{ label: "All", value: "All", isChecked: true }];

      let _sortedProgsArray = Array.from(this.progsSet).sort();
      let _sortedProgsSet = new Set(_sortedProgsArray);
      let progSetIterator = _sortedProgsSet.values();
      // List all Values
      for (const entry of progSetIterator) {
        console.log("Program = " + entry);
        this.options.push({ label: entry, value: entry });
      }

      let _sortedSdArray = Array.from(this.sdSet).sort();
      let _sortedSdSet = new Set(_sortedSdArray);
      let sdSetIterator = _sortedSdSet.values();
      // List all Values
      for (const entry of sdSetIterator) {
        console.log("SD = " + entry);
        this.sdoptions.push({ label: entry, value: entry });
      }

      this.programsrendered = true;
    }

    //clean up any previous svg.d3 descendents
    let svg = d3.select(this.template.querySelector(".scatterplot"));
    svg.selectAll("*").remove();

    var margin = { top: 50, right: 30, bottom: 60, left: 300 },
      width = 1200 - margin.left - margin.right,
      height = 900 - margin.top - margin.bottom;

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
    let d3progYAxisArray = this.progYAxisArray;

    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3(): X-axis: ${d3sessionXAxis}`,
      `X-axis: ${d3sessionXAxis}`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.initializeD3(): Y-axis:  ${d3progYAxisArray} `,
      `Y-axis:  ${d3progYAxisArray}`,
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
      .domain(d3progYAxisArray)
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

    // Build color scale
    //let myColor = d3.scaleLinear().range(["white", "#69b3a2"]).domain([1, 100]);

    //use the LFL color bands
    let color = d3
      .scaleThreshold()
      .domain([0, this.low, this.high])
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
          `<span style='color:white'>${d.session}<br/>${d.sessiondate}<br/>${d.programName}<br/>${d.SDname}<br/>Prev. Status=${d.previous_status}<br/>Score=${d.value}%<br/>Correct=${d.totalCorrect}/${d.totalResponses}</span>`
        )
        .style("left", d3.pointer(e)[0] + 100 + "px")
        .style("top", d3.pointer(e)[1] + 30 + "px");
    };
    const mousemove = (e) => {
      tooltip
        .style("left", d3.pointer(e)[0] + 100 + "px")
        .style("top", d3.pointer(e)[1] + 30 + "px");
    };
    const mouseleave = (e) => {
      tooltip.transition().duration(200).style("opacity", 0);
    };

    svg
      .append("g")
      .selectAll()
      .data(this.gridData, function (d) {
        return d.session + ":" + d.SDObjStr;
      })
      .enter()
      .append("rect")
      .attr("x", function (d) {
        return x(d.session);
      })
      .attr("y", function (d) {
        return y(d.SDObjStr);
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
      .text("Objective Mastery HeatMap");
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

  //the Program change handler
  handleSDChange(event) {
    console.log("in handleSDChange " + event.detail.value);
    const selectedOption = event.detail.value;
    this.sdoptions = this.sdoptions.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    console.log("in handleSDChange " + JSON.stringify(this.sdoptions));

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

  //the Status change handler
  handleStatusChange(event) {
    console.log("in handleStatusChange " + event.detail.value);

    const selectedOption = event.detail.value;
    this.statusoptions = this.statusoptions.map((row) => {
      return { ...row, isChecked: row.value === selectedOption };
    });
    console.log("in handleStatusChange " + JSON.stringify(this.statusoptions));
    this.composeOptions();
  }

  //the Program change handler
  handlePeriodChange(event) {
    console.log("in handlePeriodChange " + event.detail.value);

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
      `${COMPONENT}.composeOptions(): entering `,
      `${TAG}`
    );

    //find the curent Program
    let optionJson = this.options.find((item) => {
      return item.isChecked == true;
    });
    let programStr = optionJson.label;

    //find the curent Stage
    let stageoptionJson = this.stageoptions.find((item) => {
      return item.isChecked == true;
    });
    let stageStr = stageoptionJson.label;
    console.log("stageStr=" + stageStr);

    //find the curent SD
    let sdoptionJson = this.sdoptions.find((item) => {
      return item.isChecked == true;
    });
    let sdStr = sdoptionJson.label;
    console.log("programStr=" + programStr + " sdStr=" + sdStr);

    console.log("period options=" + JSON.stringify(this.periodoptions));
    //find the curent Period
    let periodoptionJson = this.periodoptions.find((item) => {
      return item.isChecked == true;
    });
    let periodStr = periodoptionJson.value;
    console.log("periodStr=" + periodStr + " sdStr=" + sdStr);

    console.log("status options=" + JSON.stringify(this.statusoptions));
    //find the curent Period
    let statusoptionJson = this.statusoptions.find((item) => {
      return item.isChecked == true;
    });
    let statusStr = statusoptionJson.value;
    console.log("statusStr=" + statusStr);

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): calling Apex getD3StatsByProgramAndSD`,
      `${COMPONENT}.composeOptions(): calling Apex getD3StatsByProgramAndSD`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): clientId=${this.recordId}, programStr=${programStr}, sdStr=${sdStr}, periodStr=${periodStr}, showAcquired=${statusStr}, stageStr=${stageStr}  `,
      `${COMPONENT}.composeOptions(): clientId=${this.recordId}, programStr=${programStr}, sdStr=${sdStr}, periodStr=${periodStr}, showAcquired=${statusStr}, stageStr=${stageStr}  `,
      `${TAG}`
    );

    getD3StatsByProgramAndSD({
      clientId: this.recordId,
      programStr: programStr,
      sdStr: sdStr,
      periodStr: periodStr,
      showAcquired: statusStr,
      stageStr: stageStr
    })
      .then((result) => {
        logDebug(
          this.recordId,
          `${COMPONENT}.composeOptions(): returned from Apex call, ${result.length} items returned`,
          `${COMPONENT}.composeOptions(): returned from Apex call, ${result.length} items returned`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.composeOptions(): result=${JSON.stringify(result)}`,
          `${COMPONENT}.composeOptions(): result logged, calling initializeD3`,
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
