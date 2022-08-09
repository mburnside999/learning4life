import { LightningElement, api, wire, track } from "lwc";

import getSessionStats from "@salesforce/apex/L4LSessionStatsController.getSessionStats";

const COLS = [
  { label: "Name", fieldName: "Name" },
  { label: "Session", fieldName: "Session" },
  { label: "Objective", fieldName: "Objective" },
  { label: "Previous", fieldName: "Previous_Status__c" },

  { label: "Correct", fieldName: "TotalAcquiredCorrect__c", initialWidth: 120 },
  {
    label: "Incorrect",
    fieldName: "TotalAcquiredIncorrect__c",
    initialWidth: 120
  },
  {
    label: "Prompted",
    fieldName: "TotalAcquiredPrompted__c",
    initialWidth: 120
  },
  { label: "% Correct", fieldName: "Percent_Correct", initialWidth: 120 },
  {
    label: "Indicator",
    fieldName: "iconstr__c",
    type: "image",
    initialWidth: 120,
    cellAttributes: { alignment: "center" }
  }
];
export default class L4lSessionStatsTwo extends LightningElement {
  @api recordId;
  columns = COLS;
  //@wire(getSessionStats)
  //sessionstats;
  wiredrecords;
  records;

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
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.records = undefined;
    }
  }
}
