import { LightningElement, api } from "lwc";

import generateD3COTSThresholdJson from "@salesforce/apex/L4LTimeSeries.generateD3COTSThresholdJson";
import { logInfo } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
//import { ShowToastEvent } from "lightning/platformShowToastEvent";

//debugging
const COMPONENT = "l4lACQThresholdSummary";
const TAG = "L4L-Analyse-ACQ-Thresholds";
//const COLOR = "color:green"; //for console log formatting
const SCENARIO = "Analyse ACQ by total session times ";
const columns = [
  { label: "Program", fieldName: "programName" },
  { label: "Acquired", fieldName: "acquiredCount" }
];
export default class L4lACQThresholdSummary extends LightningElement {
  @api recordId = "0018t000002vfSfAAI"; //Andy
  threshold1 = [];
  t1data = [];
  thresholdHrs;

  columns = columns;
  reachedt1 = true;
  t1val = "100";
  t2val = "200";

  t1options = [
    { label: "20", value: "20", isChecked: true },
    { label: "50", value: "50" },
    { label: "100", value: "100" },
    { label: "150", value: "200" },
    { label: "200", value: "300" }
  ];

  t2options = [{ label: "200", value: "200", isChecked: true }];

  //   @wire(generateD3COTSThresholdJson, {
  //     clientId: "$recordId",
  //     threshold1: 50,
  //     threshold2: 900
  //   })
  //   thresholdJSON({ error, data }) {
  //     if (data) {
  //       console.log(data);
  //       let _threshold = JSON.parse(data);
  //       this.threshold1 = _threshold.sessiondata[0];
  //       this.thresholdHrs = _threshold.sessiondata[0].thresholdHrs;
  //       if (!_threshold.sessiondata[0].thresholdReached) this.reachedt1 = false;
  //       this.t1data = _threshold.sessiondata[0].data;
  //       console.log("=============" + JSON.stringify(this.threshold1));
  //     } else {
  //       this.error = error;
  //     }
  //}

  connectedCallback() {
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
      threshold2: 900
    })
      .then((data) => {
        let _threshold = JSON.parse(data);
        this.threshold1 = _threshold.sessiondata[0];
        this.thresholdHrs = _threshold.sessiondata[0].thresholdHrs;
        if (!_threshold.sessiondata[0].thresholdReached) this.reachedt1 = false;
        this.t1data = _threshold.sessiondata[0].data;
        console.log("=============" + JSON.stringify(this.threshold1));
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
      })
      .catch((error) => {
        console.log(error);
      });
  }
}
