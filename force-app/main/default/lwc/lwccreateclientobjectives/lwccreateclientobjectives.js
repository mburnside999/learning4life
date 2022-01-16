/* eslint-disable no-unused-vars */
/* eslint-disable no-console */

import { LightningElement, api, wire, track } from "lwc";
import getUnusedObjectives from "@salesforce/apex/MBSessionObjectives.getUnusedObjectives";
import createClientObjectivesByArray from "@salesforce/apex/MBSessionObjectives.createClientObjectivesByArray";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";
const COLOUR="color:green";

const columns = [
  { label: "Name", fieldName: "Name", type: "text" },
  { label: "Program", fieldName: "Program__c", type: "text" },
  { label: "SD_Name__c", fieldName: "SD_Name__c", type: "text" },
];

const selectedRows = {};

export default class Lwccreateclientobjectives extends LightningElement {
  @api recordId = "0012v00002fY86nAAC"; //Andy

  @wire(CurrentPageReference) pageRef;
  @track allObjectives = {};
  @wire(getUnusedObjectives, { clientId: "$recordId" }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  //@track objectives;

  connectedCallback() {
    console.info(`%cconnectedCallback(): Starting, getting objectives, recordId = ${this.recordId}`,COLOUR);
    console.info(`%cconnectedCallback(): calling refresh()`,COLOUR);
    this.refresh();
  }

  refresh() {
    console.info(`%crefresh(): entering`,COLOUR);
    console.debug(`%crefresh(): calling Apex getUnusedObjectives`,COLOUR);
    console.debug(`%crefresh(): parameter clientId=${this.recordId}`,COLOUR);
    getUnusedObjectives({ clientId: this.recordId })
      .then((result) => {
        console.debug(`%crefresh(): getUnusedObjectives returned`,COLOUR);
        this.objectives = result;
        this.allObjectives = result;
        console.debug(`%crefresh(): ${JSON.stringify(this.objectives)}`,COLOUR);
      })
      .catch((error) => {
        this.error = error;
        console.error(`%crefresh(): REFRESH ERROR: ${JSON.stringify(error)}`,COLOUR);
      });
  }

  getSelectedName(event) {
    console.info(`%cgetSelectedName(): entering`,COLOUR);                                                          
    console.debug(`%cgetSelectedName(): ${event.detail.selectedRows}`,COLOUR);
    this.selectedRows = event.detail.selectedRows;
  }

  handleClickArray(event) {
    console.info(`%chandleClickArray(): entering`,COLOUR);
    if (this.selectedRows) {
      console.debug(`%chandleClickArray(): selectedRows==true`,COLOUR);
      console.debug(`%chandleClickArray(): logging JSON: ${JSON.stringify(this.selectedRows)}`,COLOUR);
      console.debug(`%chandleClickArray(): logging session: ${this.recordId}`,COLOUR);
      console.debug(`%chandleClickArray(): imperative Call to getClientObejctivesForSession(sessionid)`,COLOUR
      );

      createClientObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId,
      })
        .then((result) => {
          console.debug(`%chandleClickArray() createClientObjectivesByArray result`,COLOUR);
          this.recordsProcessed = result;
          console.debug(`%c${this.recordsProcessed} records processed.`,COLOUR);
        })
        .then(() => {console.debug(`????????? what does this .then do ???`,COLOUR)})
        .then(() => {
          this.showNotification(
            "Success",
            `${this.recordsProcessed} records processed.`,
            "success"
          );
          this.objectives = [];
          this.refresh();
        })
        .finally(() => {
          console.log(`%chandleClickArray(): reached finally()`,COLOUR);
          console.debug(`%cfiring input change event`,COLOUR);
          fireEvent(this.pageRef, "inputChangeEvent", this.recordId);
        })
        .catch((error) => {
          this.error = error;
          console.error(`%chandleClickArray(): ERRORED ${JSON.stringify(error)}`,COLOUR);
        });
    }
  }

  handleSearchKeyInput(event) {
    console.info(`%chandleSearchKeyInput(): entering`,COLOUR);
    const searchKey = event.target.value.toLowerCase();
    console.debug(`%chandleSearchKeyInput(): searchKey=${searchKey}`,COLOUR);
    this.objectives = this.allObjectives.filter(
      (so) =>
        so.Name.toLowerCase().includes(searchKey) ||
        so.Program__c.toLowerCase().includes(searchKey) ||
        so.SD_Name__c.toLowerCase().includes(searchKey)
    );
  }

  showNotification(t, m, v) {
    console.info(`%cshowNotification() entering`,COLOUR);
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v,
    });
    this.dispatchEvent(evt);
  }

  handleClickCancel(event) {
    console.info(`%chandleClickCancel() entering`,COLOUR);
    this.dispatchEvent(new CustomEvent("close"));
  }
}