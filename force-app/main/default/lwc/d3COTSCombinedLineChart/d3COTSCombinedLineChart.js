import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadScript } from "lightning/platformResourceLoader";
import D3 from "@salesforce/resourceUrl/d3";
import generateD3COTSJsonByProgramAndSD from "@salesforce/apex/L4LTimeSeries.generateD3COTSJsonByProgramAndSD";
import getProgramSetFromCO from "@salesforce/apex/L4LSessionStatsController.getProgramSetFromCO";
import getSDSetFromCO from "@salesforce/apex/L4LSessionStatsController.getSDSetFromCO";

import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";

const COMPONENT = "d3COTSCombinedLineChart";
const TAG = "L4L-Session-Statistics-d3COTSCombinedLineChart";
const SCENARIO = "D3 Plot Combine COTS - LWC";
const UI_EVENT_TRACKING_SCENARIO = "LWC UI: d3COTSCombinedLineChart";
const APEX_EVENT_TRACKING_SCENARIO = "LWC Apex: d3COTSCombinedLineChart";

/**
 * Example taken from https://www.d3-graph-gallery.com/graph/lollipop_horizontal.html
 */
export default class D3COTSCombinedLineChart extends LightningElement {
  @api recordId;
  @api lwcTitle = "Client Objectives Timeseries";
  @api chartTitle = "D3 Chart";
  @api chartSubTitle = "D3 Chart";
  d3Initialized = false;
  @track result = [];
  mode = "All";
  yAxisScale = 100;
  yAxisMax;
  yAxisMin;
  programval = "All"; //default
  sdval = "All";
  statusval = "All (ABS/ACQ/CIP)";
  periodval = "All";
  progSet = [];
  sdSet = [];

  // arrays to contain the generated content for the pull down filters
  programoptions = [];
  sdoptions = [];

  statusoptions = [
    { label: "All (ABS/ACQ/CIP)", value: "All (ABS/ACQ/CIP)", isChecked: true },
    { label: "Mastered (ABS/ACQ)", value: "Mastered (ABS/ACQ)" },
    { label: "ACQ", value: "ACQ" },
    { label: "ABS", value: "ABS" },
    { label: "CIP", value: "CIP" }
  ];

  periodoptions = [
    { label: "All", value: "All", isChecked: true },
    { label: "7 Days", value: "7" },
    { label: "14 Days", value: "14" },
    { label: "30 Days", value: "30" },
    { label: "60 Days", value: "60" },
    { label: "90 Days", value: "90" },
    { label: "180 Days", value: "180" }
  ];

  connectedCallback() {
    console.log("Hi there, in connectedCallback recordId=" + this.recordId);
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logInfo(
          this.recordId,
          `${COMPONENT}: connectedCallback`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
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
    if (this.d3Initialized) {
      return;
    }
    this.d3Initialized = true;
    console.log("in  renderedCallback");

    loadScript(this, D3 + "/d3.v5.min.js")
      .then(async () => {
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): calling getProgramSetFromCO`,
          `${SCENARIO}`,
          `${TAG}`
        );

        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: L4LSessionStatsController.getProgramSetFromCO`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking
        let _result = (this.progSet = await getProgramSetFromCO({
          clientId: this.recordId
        }));
        this.programoptions = [{ label: "All", value: "All", isChecked: true }];

        for (var i = 0; i < _result.length; i++) {
          let s = _result[i];
          this.programoptions.push({ label: s, value: s });
        }
      })
      .then(async () => {
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): calling getSDSetFromCO`,
          `${SCENARIO}`,
          `${TAG}`
        );

        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: L4LSessionStatsController.getSDSetFromCO`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking
        let _result = (this.sdSet = await getSDSetFromCO({
          clientId: this.recordId
        }));
        this.sdoptions = [{ label: "All", value: "All", isChecked: true }];
        for (var i = 0; i < _result.length; i++) {
          let s = _result[i];
          this.sdoptions.push({ label: s, value: s });
        }
      })
      .then(() => {
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): initial data - calling generateD3COTSJsonByProgramAndSD, program=All, SD=All,status=All`,
          `${SCENARIO}`,
          `${TAG}`
        );

        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: L4LTimeSeries.generateD3COTSJsonByProgramAndSD`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        return generateD3COTSJsonByProgramAndSD({
          clientId: this.recordId,
          program: "All",
          sd: "All",
          status: "All (ABS/ACQ/CIP)",
          periodStr: "All"
        });
      })
      .then((response) => {
        logDebug(
          this.recordId,
          `${COMPONENT}.renderedCallback(): generateD3COTSJsonByProgramAndSD returned ${response}`,
          `${SCENARIO}`,
          `${TAG}`
        );

        this.renderLineChart(response);
      })
      .catch((error) => {
        logError(
          this.recordId,
          `${COMPONENT}.renderedCallback(): error: ${JSON.stringify(error)}`,
          `${SCENARIO}`,
          `${TAG}`
        );

        this.dispatchEvent(
          new ShowToastEvent({
            title: "Error loading D3",
            message: error.message,
            variant: "error"
          })
        );
      });
  }

  renderLineChart(response) {
    //  response is in format:
    //  [{"rundate":"2022-11-26","val":2},{"rundate":"2022-12-19","val":1}]

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): parameter is response=${response}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    let datatmp = JSON.parse(response);
    let data = datatmp.map(myfunction);
    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): calulating the min an max axis values`,
      `${SCENARIO}`,
      `${TAG}`
    );
    function findMinMax(key) {
      const datas = datatmp.map((node) => node[key]);

      return {
        min: Math.min(...datas),
        max: Math.max(...datas)
      };
    }

    let _min = findMinMax("val").min;
    let _max = findMinMax("val").max;

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): min=${_min} max=${_max}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    this.yAxisScale = Math.ceil(_max * 2);
    this.yAxisMax = Math.ceil(_max * 1.2);
    this.yAxisMin = Math.floor(_min * 0.8);

    function myfunction(d) {
      return { rundate: d3.timeParse("%Y-%m-%d")(d.rundate), val: d.val };
    }

    function make_y_gridlines() {
      return d3.axisLeft(y).ticks(10);
    }
    function make_x_gridlines() {
      return d3.axisBottom(x).ticks(10);
    }

    //console.log("data " + JSON.stringify(data));

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): data=${JSON.stringify(data)}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    // set the dimensions and margins of the graph
    const margin = { top: 50, right: 30, bottom: 50, left: 50 },
      width = 1150 - margin.left - margin.right,
      height = 400 - margin.top - margin.bottom;

    logDebug(
      this.recordId,
      `${COMPONENT}.renderLineChart(): Dimensions==> width=${width} height=${height} margin=${JSON.stringify(
        margin
      )}`,
      `${SCENARIO}`,
      `${TAG}`
    );
    console.log("cleaning  up  svg");
    let svg = d3.select(this.template.querySelector(".horizontal-ts-chart"));
    svg.selectAll("*").remove();

    // append the svg object to the body of the page
    // console.log(
    //   `setting up svg yAxisScale= ${JSON.stringify(this.yAxisScale)})`
    // );

    svg = d3
      .select(this.template.querySelector(".horizontal-ts-chart"))
      .append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    const tooltip = d3
      .select(this.template.querySelector(".horizontal-ts-chart"))
      .append("span")
      .style("opacity", 0)
      .attr("class", "tooltip")
      .style("font-size", "12px");

    const mouseover = (e, d) => {
      let _datetext = String(d.rundate);
      let _briefdate = _datetext.substring(0, 15);
      tooltip.transition().duration(600).style("opacity", 0.9);
      tooltip
        .html(
          `<span style='color:white'>${_briefdate}<br/>Objectives: ${d.val}<br/></span>`
        )
        .style("left", d3.pointer(e)[0] + 70 + "px")
        .style("top", d3.pointer(e)[1] + 30 + "px");
    };
    const mousemove = (e) => {
      tooltip
        .style("left", d3.pointer(e)[0] + 70 + "px")
        .style("top", d3.pointer(e)[1] + 30 + "px");
    };
    const mouseleave = (e) => {
      tooltip.transition().duration(200).style("opacity", 0);
    };

    var x = d3
      .scaleTime()
      .domain(
        d3.extent(data, function (d) {
          return d.rundate;
        })
      )
      .range([0, width]);

    svg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x))
      .selectAll("text")
      .style("text-anchor", "end")
      .attr("dx", "-.8em")
      .attr("dy", ".15em")
      .attr("transform", "rotate(-45)");

    svg
      .append("g")
      .attr("class", "grid")
      .attr("transform", "translate(0," + height + ")")
      .call(make_x_gridlines().tickSize(-height).tickFormat(""));

    // Add Y axis
    var y = d3
      .scaleLinear()
      .domain([this.yAxisMin, this.yAxisMax])
      .range([height, 0]);

    svg.append("g").call(d3.axisLeft(y));

    svg
      .append("g")
      .attr("class", "grid")
      .call(make_y_gridlines().tickSize(-width).tickFormat(""));

    // Add the line
    svg
      .append("path")
      .datum(data)
      .transition()
      .duration(2000)
      .attr("fill", "none")
      .attr("stroke", "#69b3a2")
      .attr("stroke-width", 2.5)
      .attr(
        "d",
        d3
          .line()
          .x(function (d) {
            return x(d.rundate);
          })
          .y(function (d) {
            return y(d.val);
          })
      );
    // Add the points

    svg
      .append("g")
      .selectAll("dot")
      .data(data)
      .enter()
      .append("circle")
      .attr("cx", function (d) {
        return x(d.rundate);
      })
      .attr("cy", function (d) {
        return y(d.val);
      })
      .attr("r", 5)
      .attr("fill", "#69b3a2")
      .on("mouseover", mouseover)
      .on("mousemove", mousemove)
      .on("mouseleave", mouseleave);

    //   svg
    //     .append("text")
    //     .attr("x", (width - 360) / 2)
    //     .attr("y", 0)
    //     .attr("text-anchor", "left")
    //     .style("font-size", "18px")
    //     .style("fill", "grey")
    //     .style("max-width", 400)
    //     .text(`Client Objective Status Counts vs. Date`);

    //   svg
    //     .append("text")
    //     .attr("x", (width - 300) / 2)
    //     .attr("y", 20)
    //     .attr("text-anchor", "left")
    //     .style("font-size", "14px")
    //     .style("fill", "grey")
    //     .style("max-width", 400)
    //     .text("Hover over the points to see values");
    //

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

  handleClick(event) {
    this.mode = event.target.label;

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClick(): this.mode=${this.mode}, calling generateD3COTSJsonByProgramAndSD`,
      `${SCENARIO}`,
      `${TAG}`
    );

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LTimeSeries.generateD3COTSJsonByProgramAndSD`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    generateD3COTSJsonByProgramAndSD({
      clientId: this.recordId,
      program: "All",
      sd: "All",
      status: this.mode,
      periodStr: "All"
    }).then((response) => {
      logDebug(
        this.recordId,
        `${COMPONENT}.handleClick(): Apex generateD3COTSJsonByProgramAndSD returned reponse ${response}`,
        `${SCENARIO}`,
        `${TAG}`
      );
      this.renderLineChart(response);
    });
  }

  handleSDChange(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: SD Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    console.log("in handleSDChange " + event.detail.value);
    const selectedOption = event.detail.value;
    this.sdoptions = this.sdoptions.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    console.log("in handleSDChange " + JSON.stringify(this.sdoptions));

    this.composeOptions();
  }

  handleStatusChange(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Status Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    console.log("in handleStatusChange " + event.detail.value);
    const selectedOption = event.detail.value;
    this.statusoptions = this.statusoptions.map((row) => {
      return { ...row, isChecked: row.label === selectedOption };
    });
    console.log("in handleStatusChange " + JSON.stringify(this.statusoptions));

    this.composeOptions();
  }

  //the Program change handler
  handleProgramChange(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Program Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    console.log("in handleProgramChange " + event.detail.value);

    const selectedOption = event.detail.value;
    this.programoptions = this.programoptions.map((row) => {
      return { ...row, isChecked: row.value === selectedOption };
    });
    console.log(
      "in handleProgramChange " + JSON.stringify(this.programoptions)
    );
    this.composeOptions();
  }

  //the Period change handler
  handlePeriodChange(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: ComboBox: Period Filter`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    console.log("in handlePeriodChange " + event.detail.value);

    const selectedOption = event.detail.value;
    this.periodoptions = this.periodoptions.map((row) => {
      return { ...row, isChecked: row.value === selectedOption };
    });
    console.log("in handlePeriodChange " + JSON.stringify(this.periodoptions));
    this.composeOptions();
  }

  composeOptions() {
    console.log("in composeOptions");

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): entering `,
      `${SCENARIO}`,
      `${TAG}`
    );

    //find the curent Program
    let programoptionJson = this.programoptions.find((item) => {
      return item.isChecked == true;
    });
    let programStr = programoptionJson.label;

    //find the curent SD
    let sdoptionJson = this.sdoptions.find((item) => {
      return item.isChecked == true;
    });
    let sdStr = sdoptionJson.label;
    console.log("programStr=" + programStr + " sdStr=" + sdStr);

    let statusoptionJson = this.statusoptions.find((item) => {
      return item.isChecked == true;
    });
    let statusStr = statusoptionJson.value;
    console.log("statusStr=" + statusStr);

    let periodoptionJson = this.periodoptions.find((item) => {
      return item.isChecked == true;
    });
    let periodStr = periodoptionJson.value;
    console.log("periodStr=" + periodStr);

    logDebug(
      this.recordId,
      `${COMPONENT}.composeOptions(): calling Apex generateD3COTSJsonByProgramAndSD, clientId=${this.recordId}, statusStr=${statusStr}, programStr=${programStr}, sdStr=${sdStr}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    generateD3COTSJsonByProgramAndSD({
      clientId: this.recordId,
      program: programStr,
      sd: sdStr,
      status: statusStr,
      periodStr: periodStr
    })
      .then((response) => {
        console.log(response);
        this.renderLineChart(response);
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
