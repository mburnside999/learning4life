/* eslint-disable no-unused-vars */
/* eslint-disable no-console */

import { LightningElement, api, wire, track } from "lwc";
import getUnusedObjectives from "@salesforce/apex/L4LController.getUnusedObjectives";
import createClientObjectivesByArray from "@salesforce/apex/L4LController.createClientObjectivesByArray";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//import { fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
import { refreshApex } from "@salesforce/apex";
// Lightning Message Service
import { publish, MessageContext } from 'lightning/messageService';
import L4LMC from '@salesforce/messageChannel/L4LMessageChannel__c';

const COLOR="color:green";

const columns = [
  { label: "Name", fieldName: "Name", type: "text" },
  { label: "Program", fieldName: "Program__c", type: "text" },
  { label: "SD_Name__c", fieldName: "SD_Name__c", type: "text" },
];

const selectedRows = {};

export default class Lwccreateclientobjectives extends LightningElement {
  @wire(MessageContext) messageContext;
  @api recordId = "0012v00002fY86nAAC"; //Andy

  @wire(CurrentPageReference) pageRef;
  @track allObjectives = {};
  @wire(getUnusedObjectives, { clientId: "$recordId" }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  //@track objectives;

  connectedCallback() {
    console.info(`%cconnectedCallback(): Starting, getting objectives, recordId = ${this.recordId}`,COLOR);
    console.info(`%cconnectedCallback(): calling refresh()`,COLOR);
    this.refresh();
  }

  refresh() {
    console.info(`%crefresh(): entering`,COLOR);
    console.debug(`%crefresh(): calling Apex getUnusedObjectives`,COLOR);
    console.debug(`%crefresh(): parameter clientId=${this.recordId}`,COLOR);
    getUnusedObjectives({ clientId: this.recordId })
      .then((result) => {
        console.debug(`%crefresh(): getUnusedObjectives returned`,COLOR);
        this.objectives = result;
        this.allObjectives = result;
        console.debug(`%crefresh(): ${JSON.stringify(this.objectives)}`,COLOR);
      })
      .catch((error) => {
        this.error = error;
        console.error(`%crefresh(): REFRESH ERROR: ${JSON.stringify(error)}`,COLOR);
      });
  }

  getSelectedName(event) {
    console.info(`%cgetSelectedName(): entering`,COLOR);                                                          
    console.debug(`%cgetSelectedName(): ${event.detail.selectedRows}`,COLOR);
    this.selectedRows = event.detail.selectedRows;
  }

  handleClickArray(event) {
    console.info(`%chandleClickArray(): entering`,COLOR);
    if (this.selectedRows) {
      console.debug(`%chandleClickArray(): selectedRows==true`,COLOR);
      console.debug(`%chandleClickArray(): logging JSON: ${JSON.stringify(this.selectedRows)}`,COLOR);
      console.debug(`%chandleClickArray(): logging session: ${this.recordId}`,COLOR);
      console.debug(`%chandleClickArray(): imperative Call to createClientObjectivesByArray`,COLOR
      );

      createClientObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId,
      })
        .then((result) => {
          console.debug(`%chandleClickArray() createClientObjectivesByArray returned result`,COLOR);
          this.recordsProcessed = result;
          console.debug(`%c${this.recordsProcessed} records processed.`,COLOR);
        })
        .then(() => {console.debug(`????????? what does this .then do ???`,COLOR)})
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
          console.log(`%chandleClickArray(): reached finally()`,COLOR);
          console.debug(`%cpublishing LMS event`,COLOR);
          //fireEvent(this.pageRef, "inputChangeEvent", this.recordId);
          const message = {
            recordId: '',
            message : "message from lwccreateclienbtobjectives",
            source: "LWC",
            recordData: {}
        };
        console.debug(`%cSending message via L4LMC, message=${message}`,COLOR);
        publish(this.messageContext, L4LMC, message);
        })
        .catch((error) => {
          this.error = error;
          console.error(`%chandleClickArray(): ERRORED ${JSON.stringify(error)}`,COLOR);
        });
    }
  }

  handleSearchKeyInput(event) {
    console.info(`%chandleSearchKeyInput(): entering`,COLOR);
    const searchKey = event.target.value.toLowerCase();
    console.debug(`%chandleSearchKeyInput(): searchKey=${searchKey}`,COLOR);
    this.objectives = this.allObjectives.filter(
      (so) =>
        so.Name.toLowerCase().includes(searchKey) ||
        so.Program__c.toLowerCase().includes(searchKey) ||
        so.SD_Name__c.toLowerCase().includes(searchKey)
    );
  }

  showNotification(t, m, v) {
    console.info(`%cshowNotification() entering`,COLOR);
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v,
    });
    this.dispatchEvent(evt);
  }

  handleClickCancel(event) {
    console.info(`%chandleClickCancel() entering`,COLOR);
    this.dispatchEvent(new CustomEvent("close"));
  }
}