/* eslint-disable no-unused-vars */
/* eslint-disable no-console */

import { LightningElement, api, wire, track } from "lwc";
import getUnusedObjectives from "@salesforce/apex/MBSessionObjectives.getUnusedObjectives";
import createClientObjectivesByArray from "@salesforce/apex/MBSessionObjectives.createClientObjectivesByArray";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";

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
  @wire(getUnusedObjectives, { sess: "$recordId" }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  //@track objectives;

  connectedCallback() {
    console.info(`entering connectedCallback(): Starting, getting objectives, recordId = ${this.recordId}`);
    this.refresh();
  }

  refresh() {
    console.info("refresh(): entering");
    console.debug("refresh(): calling Apex getUnusedObjectives");

    getUnusedObjectives({ sess: this.recordId })
      .then((result) => {
        console.debug("refresh(): getUnusedObjectives returned");
        this.objectives = result;
        this.allObjectives = result;
        console.debug(`refresh(): ${JSON.stringify(this.objectives)}`);
      })
      .catch((error) => {
        this.error = error;
        console.error(`refresh(): REFRESH ERROR: ${JSON.stringify(error)}`);
      });
  }

  getSelectedName(event) {
    console.info('getSelectedName(): entering');
    console.debug(`getSelectedName(): ${event.detail.selectedRows}`);
    this.selectedRows = event.detail.selectedRows;
  }

  handleClickArray(event) {
    console.info('handleClickArray(): entering');
    if (this.selectedRows) {
      console.debug('handleClickArray(): selectedRows==true');
      console.debug(`handleClickArray(): logging JSON: ${JSON.stringify(this.selectedRows)}`);
      console.debug(`handleClickArray(): logging session: ${this.recordId}`);
      console.debug("handleClickArray(): imperative Call to getClientObejctivesForSession(sessionid) "
      );

      createClientObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId,
      })
        .then((result) => {
          console.debug("handleClickArray() RESULT RETURNED");
          this.recordsProcessed = result;
          console.debug(`${this.recordsProcessed} records processed.`);
        })
        .then(() => {})
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
          console.log("handleClickArray(): finally()");
          console.debug("firing input change event");
          fireEvent(this.pageRef, "inputChangeEvent", this.recordId);
        })
        .catch((error) => {
          this.error = error;
          console.error(`handleClickArray(): ERRORED ${JSON.stringify(error)}`);
        });
    }
  }

  handleSearchKeyInput(event) {
    console.info("handleSearchKey(): entering");
    const searchKey = event.target.value.toLowerCase();
    console.debug(`handleSearchKeyInput(): searchKey=${searchKey}`);
    this.objectives = this.allObjectives.filter(
      (so) =>
        so.Name.toLowerCase().includes(searchKey) ||
        so.Program__c.toLowerCase().includes(searchKey) ||
        so.SD_Name__c.toLowerCase().includes(searchKey)
    );
  }

  showNotification(t, m, v) {
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v,
    });
    this.dispatchEvent(evt);
  }

  handleClickCancel(event) {
    console.info('handleClickCancel() entering');
    this.dispatchEvent(new CustomEvent("close"));
  }
}