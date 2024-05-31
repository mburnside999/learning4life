// Mikes D3 based heatmap
import { LightningElement, track, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import getD3StatsByProgramAndSD from "@salesforce/apex/L4LSessionStatsController.getD3StatsByProgramAndSD";
import getHighAndLowBoundaries from "@salesforce/apex/L4LSessionStatsController.getHighAndLowBoundaries";

import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";

const COMPONENT = "D3HeatMap";
const TAG = "L4L-Session-Statistics-D3HeatMap";
const SCENARIO = "View Program Mastery D3HeatMap - LWC";
const UI_EVENT_TRACKING_SCENARIO = "LWC UI: d3HeatMap";
const APEX_EVENT_TRACKING_SCENARIO = "LWC Apex: d3HeatMap";
export default class D3HeatMap extends LightningElement {
  @api lwcTitle = "Client Program Mastery";
  @api chartTitle = "Results Vs. Sessions ";
  @api chartSubTitle = "Colour Key: Red <50%, Yellow <90%, Red >= 90% ";

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

  respondedoptions = [
    { label: "Yes", value: "true", isChecked: true },
    { label: "No", value: "false" }
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

  therapistoptions = [{ label: "All", value: "All", isChecked: true }];

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

  optionval = "All"; //default
  sdoptionval = "All";
  therapistoptionval = "All";
  stageoptionval = "All";
  periodval = "30";
  statusval = "false";
  respondedval = "true"; //true=include "N" values

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
  therapistSet = new Set([]);

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
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback()`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking
        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: @wire L4LSessionStatsController.getHighAndLowBoundaries`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
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
      `${COMPONENT}: Apex Call: L4LSessionStatsController.getD3StatsByProgramAndSD`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    //load D3
    Promise.all([loadScript(this, D3 + "/d3.v5.min.js")])
      .then(async () => {
        let _result = (this.result = await getD3StatsByProgramAndSD({
          clientId: this.recordId,
          programStr: "All",
          sdStr: "All",
          periodStr: "30",
          stageStr: "All",
          showAcquired: this.isSelected,
          therapistStr: "All"
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
            message: error,
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
    this.objsSet = new Set([]);
    this.progsSet = new Set([]);
    this.sdSet = new Set([]);
    this.therapistSet = new Set([]);

    //local variables to convert the __r field names received from Apex
    let session;
    let objective;
    let value;
    let adjustedvalue;
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
    let totalAdjustedResponses;
    let therapistName;

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
      this.therapistSet.add(row.Session__r.Therapist_Name__c);
      session = row.Session__r.Name;
      SDObjStr = row.SD_And_Objective_Str__c;
      objective = row.Objective__r.Name;
      programName = row.Program_Name__c;
      previous_status = row.Previous_Status__c;
      sessiondate = row.Session__r.Date__c;
      value = row.Percent_Correct__c;
      (adjustedvalue = row.Responded_Percent_Correct__c),
        (SDname = row.SD_Name__c);
      totalCorrect = row.TotalAcquiredCorrect__c;
      totalIncorrect = row.TotalAcquiredIncorrect__c;
      totalPrompted = row.TotalAcquiredPrompted__c;
      totalNonResponsive = row.TotalAcquiredNonResponsive__c;
      totalResponses =
        totalCorrect + totalIncorrect + totalPrompted + totalNonResponsive;
      totalAdjustedResponses = totalCorrect + totalIncorrect + totalPrompted;
      therapistName = row.Session__r.Therapist_Name__c;
      console.log("============>>>therapistName=" + therapistName);
      return {
        session,
        objective,
        value,
        adjustedvalue,
        previous_status,
        sessiondate,
        programName,
        SDname,
        SDObjStr,
        totalCorrect,
        totalIncorrect,
        totalPrompted,
        totalNonResponsive,
        totalResponses,
        totalAdjustedResponses,
        therapistName
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

    this.options = [{ label: "All", value: "All", isChecked: true }];
    this.sdoptions = [{ label: "All", value: "All", isChecked: true }];
    this.therapistoptions = [{ label: "All", value: "All", isChecked: true }];

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
    // swet to support therapist functionality

    let _sortedTherapistArray = Array.from(this.therapistSet).sort();
    let _sortedTherapistSet = new Set(_sortedTherapistArray);
    let therapistSetIterator = _sortedTherapistSet.values();
    // List all Values
    for (const entry of therapistSetIterator) {
      console.log("Therapist = " + entry);
      this.therapistoptions.push({ label: entry, value: entry });
    }

    this.programsrendered = true;

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
          `<span style='color:white'>${d.session}<br/>${d.therapistName}<br/>${d.sessiondate}<br/>${d.programName}<br/>${d.SDname}<br/>Prev. Status = ${d.previous_status}<br/>Include N, %C = ${d.value}% (${d.totalCorrect}/${d.totalResponses})<br/>Exclude N, %Cᵃᵈʲ = ${d.adjustedvalue}% (${d.totalCorrect}/${d.totalAdjustedResponses})<br/></span>`
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
      .style("opacity", (d) => {
        if (d.adjustedvalue == d.value) {
          return 1; // experiments with opacity - currently not used
        } else {
          return 1;
        }
      })

      .style("fill", (d) => {
        if (this.respondedval == "true") {
          console.log(
            "this.responsdedval==true so including N values, using d.value"
          );
          return color(d.value);
        } else {
          console.log(
            "this.responsdedval==false so NOT including N values, using d.adjustedvalue"
          );
          return color(d.adjustedvalue);
        }
      })
      .on("mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave);

    // svg
    //   .append("text")
    //   .attr("x", 0)
    //   .attr("y", -80)
    //   .attr("text-anchor", "left")
    //   .style("font-size", "22px")
    //   .text("A d3.js heatmap");

    svg
      .append("text")
      .attr("x", width / 2)
      .attr("y", -30)
      .attr("text-anchor", "middle")
      .style("font-size", "18px")
      .style("fill", "grey")
      .text(`${this.chartTitle}`);

    svg
      .append("text")
      .attr("x", width / 2)
      .attr("y", -10)
      .attr("text-anchor", "middle")
      .style("font-size", "14px")
      .style("fill", "grey")
      .text(`${this.chartSubTitle}`);
  }

  // Add subtitle to graph
  // svg
  //   .append("text")
  //   .attr("x", 0)
  //   .attr("y", -20)
  //   .attr("text-anchor", "left")
  //   .style("font-size", "16px")
  //   .style("fill", "grey")
  //   .style("max-width", 400)
  //   .text(
  //     "June 2023, NEW! Option to ignore 'N' responses. Plot colours for either %C or %Cᵃᵈʲ & view both in hover."
  //   );

  // the ACQ/ALL handler
  handleClick() {
    this.isSelected = !this.isSelected;
    this.composeOptions();
  }

  //the Program change handler
  handleChange(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Program Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    const selectedOption = event.detail.value;
    //record this program as selected
    this.options = this.options.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });

    const sdval = this.template.querySelector(".sd-val");
    if (sdval) {
      sdval.value = "All";
    }
    const therapistval = this.template.querySelector(".therapist-val");
    if (therapistval) {
      therapistval.value = "All";
    }

    this.composeOptions();
  }

  //the SD change handler
  handleSDChange(event) {
    console.log("in handleSDChange " + event.detail.value);

    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: SD Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    const selectedOption = event.detail.value;
    this.sdoptions = this.sdoptions.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    console.log("in handleSDChange " + JSON.stringify(this.sdoptions));

    const progval = this.template.querySelector(".prog-val");
    if (progval) {
      progval.value = "All";
    }
    const therapistval = this.template.querySelector(".therapist-val");
    if (therapistval) {
      therapistval.value = "All";
    }
    this.composeOptions();
  }

  //the Therpaist change handler
  handleTherapistChange(event) {
    console.log("==========> in handleTherapistChange " + event.detail.value);

    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Therapist Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    const selectedOption = event.detail.value;
    this.therapistoptions = this.therapistoptions.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    console.log(
      "in handleTherapistChange " + JSON.stringify(this.therapistoptions)
    );

    const progval = this.template.querySelector(".prog-val");
    if (progval) {
      progval.value = "All";
    }
    const sdval = this.template.querySelector(".sd-val");
    if (sdval) {
      sdval.value = "All";
    }

    this.composeOptions();
  }

  handleStageChange(event) {
    console.log("in handleSDChange " + event.detail.value);

    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Stage Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    const selectedOption = event.detail.value;
    this.stageoptions = this.stageoptions.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    console.log("in handleStageChange " + JSON.stringify(this.stageoptions));

    this.composeOptions();
  }

  //the Status change handler
  handleRespondedChange(event) {
    console.log("in handleRespondedChange " + event.detail.value);
    this.respondedval = event.detail.value;

    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Responded Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    const selectedOption = event.detail.value;
    this.respondedval = selectedOption;
    this.respondedoptions = this.respondedoptions.map((row) => {
      return { ...row, isChecked: row.value === selectedOption };
    });
    console.log(
      "in handleRespondedChange, this.respondedval= " +
        this.respondedval +
        ", selecteOption=" +
        selectedOption +
        ", this.respondeoptions=" +
        JSON.stringify(this.respondedoptions)
    );
    this.composeOptions();
  }

  //the Status change handler
  handleStatusChange(event) {
    console.log("in handleStatusChange " + event.detail.value);

    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Status Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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

    const progval = this.template.querySelector(".prog-val");
    if (progval) {
      progval.value = "All";
    }
    const sdval = this.template.querySelector(".sd-val");
    if (sdval) {
      sdval.value = "All";
    }
    const therapistval = this.template.querySelector(".therapist-val");
    if (therapistval) {
      therapistval.value = "All";
    }

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

    //find the curent Program
    let optionJson = this.options.find((item) => {
      return item.isChecked == true;
    });
    let programStr = optionJson.label;
    console.log("+++ composeOptions programStr=" + programStr);

    //responded values are not passed to Apex, the respondedStr is not really used but is here for consistency
    //find the curent Responded value
    let respondedoptionJson = this.respondedoptions.find((item) => {
      return item.isChecked == true;
    });
    let respondedStr = respondedoptionJson.label;
    console.log("respondedStr==" + respondedStr);
    //the respondedVal was set in the handleResponse and is placed here for consistency
    console.log("this.respondedval==" + this.respondedval);

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

    //find the curent Therapist
    let therapistoptionJson = this.therapistoptions.find((item) => {
      return item.isChecked == true;
    });
    let therapistStr = therapistoptionJson.label;
    console.log("therapistStr=" + therapistStr);

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
      `${SCENARIO}`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): clientId=${this.recordId}, programStr=${programStr}, sdStr=${sdStr}, periodStr=${periodStr}, showAcquired=${statusStr}, stageStr=${stageStr}  `,
      `${SCENARIO}`,
      `${TAG}`
    );

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LSessionStatsController.getD3StatsByProgramAndSD`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    console.log("+++filter settings for payload");
    console.log("+++================");
    console.log("+++periodStr=" + periodStr);
    console.log("+++statusStr=" + statusStr);
    console.log("+++programStr=" + programStr);
    console.log("+++sdStr=" + sdStr);
    console.log("+++stageStr=" + stageStr);
    console.log("+++respondedStr (local)=" + respondedStr);
    console.log("+++therapistStr=" + therapistStr);
    console.log("+++================");

    getD3StatsByProgramAndSD({
      clientId: this.recordId,
      programStr: programStr,
      sdStr: sdStr,
      periodStr: periodStr,
      showAcquired: statusStr,
      stageStr: stageStr,
      therapistStr: therapistStr
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
