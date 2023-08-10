import { LightningElement, api } from "lwc";
import { loadScript } from "lightning/platformResourceLoader";
import generateD3COTSThresholdJson from "@salesforce/apex/L4LTimeSeries.generateD3COTSThresholdJson";
import { logInfo } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
//import { ShowToastEvent } from "lightning/platformShowToastEvent";
import D3 from "@salesforce/resourceUrl/d3";

//debugging
const COMPONENT = "l4lACQThresholdSummary";
const TAG = "L4L-Analyse-ACQ-Thresholds";
//const COLOR = "color:green"; //for console log formatting
const SCENARIO = "Analyse ACQ by total session times and thresholds - LWC";
const columns = [
  { label: "Program Name", fieldName: "programName", initialWidth: 250 },
  { label: "# of ACQ skills", fieldName: "acquiredCount", initialWidth: 150 }
];
export default class L4lACQThresholdSummary extends LightningElement {
  @api recordId = "0018t000002vfSfAAI"; //Andy
  threshold1 = [];
  t1data = [];
  thresholdHrs;

  columns = columns;
  reachedt1 = true;
  t1val = "100";
  t2val = "500";
  d3Initialized = false;
  xAxisScale = 20;

  t1options = [
    { label: "20", value: "20", isChecked: true },
    { label: "50", value: "50" },
    { label: "100", value: "100" },
    { label: "150", value: "150" },
    { label: "200", value: "200" },
    { label: "250", value: "250" },
    { label: "300", value: "300" },
    { label: "400", value: "400" }
  ];

  t2options = [{ label: "500", value: "500", isChecked: true }];

  get t1DateStr() {
    return this.threshold1.dateAtThreshold == null
      ? null
      : this.threshold1.dateAtThreshold.substring(0, 10);
  }

  renderedCallback() {
    console.log("renderedCallback()");
    if (!this.d3Initialized) {
      loadScript(this, D3 + "/d3.v5.min.js");
      this.d3Initialized = true;
    }
  }

  connectedCallback() {
    console.log("connectedCallback()");

    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, initializing data by calling getPopularClientObjectives()`,
          `${SCENARIO}`,
          `${TAG}`
        );
        this.refresh();
      })
      .catch((error) => {
        console.log("Error");
      });
  }

  refresh() {
    console.log("=====> in refresh t1val=" + this.t1val);
    generateD3COTSThresholdJson({
      clientId: this.recordId,
      threshold1: this.t1val,
      threshold2: this.t2val
    })
      .then((data) => {
        let _threshold = JSON.parse(data);
        this.threshold1 = _threshold.sessiondata[0];
        this.thresholdHrs = _threshold.sessiondata[0].thresholdHrs;
        if (!_threshold.sessiondata[0].thresholdReached) this.reachedt1 = false;
        this.t1data = _threshold.sessiondata[0].data;
        console.log("=============" + JSON.stringify(this.threshold1));
        this.renderHistogram(this.t1data);
      })
      .catch((error) => {});
  }

  handleT1Change(event) {
    console.log("in handleProgramChange " + event.detail.value);
    const selectedOption = event.detail.value;
    //this.t1val = selectedOption;

    this.t1options = this.t1options.map((row) => {
      return { ...row, isChecked: row.value === selectedOption };
    });
    console.log("in handleT1Change " + JSON.stringify(this.t1options));
    this.composeOptions();
  }

  composeOptions() {
    console.log("in composeOptions");

    //find the curent Program
    let t1optionJson = this.t1options.find((item) => {
      return item.isChecked == true;
    });
    let t1Str = t1optionJson.label;
    console.log("calling generateD3COTSThresholdJson =======> t1Str=" + t1Str);
    this.threshold1 = [];
    this.t1data = [];
    this.reachedt1 = true;

    generateD3COTSThresholdJson({
      clientId: this.recordId,
      threshold1: t1Str,
      threshold2: 900
    })
      .then((data) => {
        console.log("returned");
        let _threshold = JSON.parse(data);
        this.threshold1 = _threshold.sessiondata[0];
        this.thresholdHrs = _threshold.sessiondata[0].thresholdHrs;
        if (!_threshold.sessiondata[0].thresholdReached) this.reachedt1 = false;
        this.t1data = _threshold.sessiondata[0].data;
        console.log("=============" + JSON.stringify(this.threshold1));
        this.renderHistogram(this.t1data);
      })
      .catch((error) => {
        console.log(error);
      });
  }

  renderHistogram(data) {
    console.log("received " + JSON.stringify(data));

    function findMinMax(key) {
      const datas = data.map((node) => node[key]);

      return {
        min: Math.min(...datas),
        max: Math.max(...datas)
      };
    }

    //let _min = findMinMax("acquiredCount").min;
    let _max = findMinMax("acquiredCount").max;
    this.xAxisScale = Math.ceil(_max * 1.2);

    // set the dimensions and margins of the graph
    var margin = { top: 50, right: 30, bottom: 60, left: 200 },
      width = 900 - margin.left - margin.right,
      height = 600 - margin.top - margin.bottom;

    console.log("cleaning  up  svg");
    let svg = d3.select(this.template.querySelector(".histo"));
    svg.selectAll("*").remove();

    // append the svg object to the body of the page
    console.log("setting up svg");

    svg = d3
      .select(this.template.querySelector(".histo"))
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
      .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var x = d3.scaleLinear().domain([0, this.xAxisScale]).range([0, width]);
    svg
      .append("g")
      .attr("transform", "translate(0," + height + ")")
      .call(d3.axisBottom(x))
      .selectAll("text")
      .attr("transform", "translate(-10,0)rotate(-45)")
      .style("text-anchor", "end");

    // Y axis
    var y = d3
      .scaleBand()
      .range([0, height])
      .domain(
        data.map(function (d) {
          return d.programName;
        })
      )
      .padding(0.1);
    svg.append("g").call(d3.axisLeft(y));

    //Bars
    svg
      .selectAll("myRect")
      .data(data)
      .enter()
      .append("rect")
      .attr("x", x(0))
      .attr("y", function (d) {
        return y(d.programName);
      })
      .attr("width", function (d) {
        return x(d.acquiredCount);
      })
      .attr("height", y.bandwidth())
      .attr("fill", "#69b3a2");

    // svg
    //   .append("text")
    //   .attr("x", (width - 12) / 2)
    //   .attr("y", 0)
    //   .attr("text-anchor", "left")
    //   .style("font-size", "18px")
    //   .style("fill", "grey")
    //   .style("max-width", 400)
    //   .text("EXPERIMENTAL - Threshold analysis");

    // svg
    //   .append("text")
    //   .attr("x", (width - 60) / 2)
    //   .attr("y", 20)
    //   .attr("text-anchor", "left")
    //   .style("font-size", "14px")
    //   .style("fill", "grey")
    //   .style("max-width", 400)
    //   .text("Threshold Analysis");

    svg
      .append("text")
      .attr("class", "x label")
      .attr("text-anchor", "end")
      .attr("x", (width - 25) / 2)
      .attr("y", height + 40)
      .text("Skills Acquired");
  }
}
