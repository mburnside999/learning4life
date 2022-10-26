import { LightningElement, wire, track } from "lwc";

import getSessionStats from "@salesforce/apex/L4LSessionStatsController.getSessionStats";

const COLS = [
  { label: "Name", fieldName: "Name" },
  { label: "Icon", fieldName: "icon__c", type: "image" }
];
export default class ShowProfile extends LightningElement {
  @track columns = COLS;
  @wire(getSessionStats)
  sessionstats;
}
