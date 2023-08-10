import { LightningElement, api, wire } from "lwc";

import getSessionStats from "@salesforce/apex/L4LSessionStatsController.getSessionStats";

const COMPONENT = "l4lPopulateSessionStatsPortalDataTable";
const TAG = "L4L-Session-Statistics";
const SCENARIO = "View and filter session portal statistics - LWC";
const UI_EVENT_TRACKING_SCENARIO =
  "l4lSessionStatsPortalDataTable LWC UI Event Tracking";
const APEX_EVENT_TRACKING_SCENARIO =
  "l4lSessionStatsPortalDataTable LWC APEX Event Tracking";

import { logInfo } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";

const COLS = [
  // { label: "Name", fieldName: "Name" },
  // { label: "Session", fieldName: "Session" },
  { label: "Program", fieldName: "Program_Name__c" },
  { label: "SD", fieldName: "SD_Name__c" },

  { label: "Objective", fieldName: "Objective" },
  { label: "Previous", fieldName: "Previous_Status__c", initialWidth: 90 },
  { label: "% C", fieldName: "Percent_Correct", initialWidth: 75 },
  {
    label: "",
    fieldName: "iconportalstr__c",
    type: "image",
    initialWidth: 20,
    cellAttributes: { alignment: "center" }
  },
  { label: "C", fieldName: "TotalAcquiredCorrect__c", initialWidth: 20 },
  {
    label: "I",
    fieldName: "TotalAcquiredIncorrect__c",
    initialWidth: 20
  },
  {
    label: "N",
    fieldName: "TotalAcquiredNonResponsive__c",
    initialWidth: 20
  },
  {
    label: "P",
    fieldName: "TotalAcquiredPrompted__c",
    initialWidth: 20
  }
];
export default class L4lSessionStatsPortalDatatable extends LightningElement {
  @api recordId;
  columns = COLS;
  wiredrecords;
  records;
  queryrecords = {};

  @wire(getSessionStats, { searchKey: "$recordId" })
  wiredSessionStat(value) {
    this.wiredRecords = value;
    const { data, error } = value;
    if (data) {
      let tempRecords = JSON.parse(JSON.stringify(data));
      tempRecords = tempRecords.map((row) => {
        return {
          ...row,
          Objective: row.Objective__r.Name,
          Session: row.Session__r.Name,
          Percent_Correct: row.Percent_Correct__c + "%"
        };
      });

      this.records = tempRecords;
      this.queryrecords = this.records;
      //console.log("queryrecords=>" + JSON.stringify(this.queryrecords));
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.records = undefined;
    }
  }

  connectedCallback() {
    console.info(`in connectedCallback`);

    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good`,
          `${SCENARIO}`,
          `${TAG}`
        );
        logInfo(
          this.recordId,
          `${COMPONENT}: connectedCallback`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking
        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: @wire L4LSessionStatsController.getSessionStats`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking
      })
      .catch((error) => {
        console.log("Error");
      });
  }

  handleFilterKeyInput(event) {
    const filterKey = event.target.value.toLowerCase();
    //console.log(filterkey);
    this.records = this.queryrecords.filter(
      (row) =>
        row.Program_Name__c.toLowerCase().includes(filterKey) ||
        row.SD_Name__c.toLowerCase().includes(filterKey) ||
        row.Objective.toLowerCase().includes(filterKey) ||
        row.Previous_Status__c.toLowerCase().includes(filterKey)
    );
  }
}
