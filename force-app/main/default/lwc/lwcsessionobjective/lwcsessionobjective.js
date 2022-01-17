/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getSessionObjectives from "@salesforce/apex/MBSessionObjectives.getSessionObjectives";
import setSessionObjectivesByArray from "@salesforce/apex/MBSessionObjectives.setSessionObjectivesByArray";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import deleteSessionObjectives from "@salesforce/apex/MBSessionObjectives.deleteSessionObjectives";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord } from "lightning/uiRecordApi";

import COMMENT_FIELD from "@salesforce/schema/Session_Obj__c.Comment__c";
import CORRECT_FIELD from "@salesforce/schema/Session_Obj__c.Correct__c";
import INCORRECT_FIELD from "@salesforce/schema/Session_Obj__c.Incorrect__c";
import PROMPTED_FIELD from "@salesforce/schema/Session_Obj__c.Prompted__c";
import ID_FIELD from "@salesforce/schema/Session_Obj__c.Id";

import { refreshApex } from "@salesforce/apex";
import { deleteRecord } from "lightning/uiRecordApi";
// Lightning Message service
import {
  subscribe,
  unsubscribe,
  APPLICATION_SCOPE,
  MessageContext
} from "lightning/messageService";

import L4LMC from "@salesforce/messageChannel/L4LSessionMessageChannel__c";

const COLOR="color:blue";

const actions = [{ label: "Delete", name: "delete" }];

const columns = [
  { label: "Prog", fieldName: "Program__c", type: "text",initialWidth: 200},
  { label: "Obj", fieldName: "Objective_Name__c", type: "text",initialWidth: 200 },
  { label: "SD", fieldName: "SD__c", type: "text",initialWidth: 200 },
  {
    label: "C",
    fieldName: "Correct__c",
    type: "boolean",
    initialWidth: 60,
    editable: true,
  },
  {
    label: "I",
    fieldName: "Incorrect__c",
    type: "boolean",
    initialWidth: 60,
    editable: true,
  },
  {
    label: "P",
    fieldName: "Prompted__c",
    type: "boolean",
    initialWidth: 60,
    editable: true,
  },
  { label: "Prev", fieldName: "Previous_Status__c", type: "text",initialWidth: 80 },
  { label: "Comments", fieldName: "Comment__c", type: "text", editable: true },
  {
    type: "action",
    typeAttributes: { rowActions: actions },
  },
];
const selectedRows = {};

export default class Lwcsessionobjective extends LightningElement {
  @api recordId = "a3N2v000003Gr4VEAS"; //this is session 31
  //@wire(getSessionObjectives, { sess: '$recordId' }) sessionObjectives;
  @track sessionObjectives;

  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  @wire(CurrentPageReference) pageRef;
  @track draftValues = [];
  @track allObjectives = {};
  @wire(MessageContext) messageContext;
  subscription = null;

  connectedCallback() {
    console.debug(`%cconnectedCallback(): subscribing to LMS L4LSessionMessageChannel__c`,COLOR);
    this.subscription = subscribe(
      this.messageContext,
      L4LMC,
      message => {
        this.handleLMS(message);
      },
      { scope: APPLICATION_SCOPE }
    );
    console.log(`%cconnectedCallback(): calling refresh()`,COLOR);
    this.refresh();
  }

  refresh() {
    console.info(`%crefresh(): entering`,COLOR);
    console.debug(`%crefresh(): calling getSessionObjectives`,COLOR);

    getSessionObjectives({ sess: this.recordId })
      .then((result) => {
        console.debug(`%crefresh() getSessionObjectives returned result=${JSON.stringify(result)}`,COLOR);
        this.sessionObjectives = result;
        this.allObjectives = result;
        console.debug(`%crefresh(): sessionObjectives= ${JSON.stringify(this.sessionObjectives)}`,COLOR);
      })
      .catch((error) => {
        this.error = error;
        console.error(`%crefresh(): ERROR: ${JSON.stringify(error)}`,COLOR);
      });
  }

  handleSearchKeyInput(event) {
    console.info(`%chandleSearchKeyInput(): entering`,COLOR);

    const searchKey = event.target.value.toLowerCase();
    this.sessionObjectives = this.allObjectives.filter(
      (so) =>
        so.Program__c.toLowerCase().includes(searchKey) ||
        (so.Previous_Status__c != null &&
          so.Previous_Status__c.toLowerCase().includes(searchKey)) ||
        so.Objective_Name__c.toLowerCase().includes(searchKey) ||
        so.SD__c.toLowerCase().includes(searchKey) ||
        (!(so.Comment__c === undefined) &&
          so.Comment__c.toLowerCase().includes(searchKey))
    );
  }

  handleLMS(message) {
    console.info(`%chandleLMS(): entering`,COLOR);
    console.info(`%chandleLMS(): received message on LMS L4LSessionMessageChannel__c`,COLOR);
    this.receivedMessage = message
    ? JSON.stringify(message, null, "\t")
    : "no message payload";
    console.debug(`%c message=${JSON.stringify(message)}`,COLOR);
    
    this.refresh();
  }



  handleRowAction(event) {
    console.info(`%chhandleRowAction(): entering`,COLOR);

    const actionName = event.detail.action.name;
    const row = event.detail.row;
    console.debug(`%chhandleRowAction(): row= ${JSON.stringify(row)}`,COLOR);
    switch (actionName) {
      case "delete":
        console.debug(`handleRowAction(): DELETING`,COLOR);
        deleteRecord(row.Id)
          .then(() => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Session Objective deleted",
                variant: "success",
              })
            );
            this.refresh();
          })
          .catch((error) => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Error deleting record",
                message: "Error",
                variant: "error",
              })
            );
          });
        break;
      case "edit_details":
        console.debug("EDIT DETAILS");
        break;
      default:
    }
  }

  handleSave(event) {
    console.info(`%chandleSAve(): entering`,COLOR)
    console.debug(`%chandleSAve(): draftValues= ${JSON.stringify(event.detail.draftValues)}`,COLOR);
    const recordInputs = event.detail.draftValues.slice().map((draft) => {
      const fields = Object.assign({}, draft);
      return { fields };
    });

    const promises = recordInputs.map((recordInput) =>
      updateRecord(recordInput)
    );
    Promise.all(promises)
      .then((contacts) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Session objectives updated",
            variant: "success",
          })
        );
        // Clear all draft values
        this.draftValues = [];

        // Display fresh data in the datatable
        this.refresh();
      })
      .catch((error) => {
        // Handle error
      });
  }

  handleClickArray(event) {
    console.info(`%chandleClickArray(): entering`,COLOR);
    console.debug(`%chandleClickArray(): Received event from button ${event.target.label}`,COLOR);
    let mode = "";
    let label = event.target.label;

    switch (label) {
      case "Mark Correct":
        mode = "Correct";
        break;
      case "Mark Incorrect":
        mode = "Incorrect";
        break;
      case "Mark Prompted":
        mode = "Prompted";
        break;
      case "Delete Selected Records":
        mode = "Delete";
        break;
      default:
      // code block
    }

    if (this.selectedRows) {
      console.debug(
        `%chandleClickArray(): Commencing imperative Call to setSessionObjectivesCorrectByArray(key)`,COLOR
      );
      console.debug(`%chandleClickArray(): mode= ${mode}`,COLOR);
      setSessionObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        val: mode,
      })
        .then((result) => {
          console.debug(`%chandleClickArray(): returned result ${result}`,COLOR);
          this.recordsProcessed = result;
          console.debug(`%chandleClickArray(): ${this.recordsProcessed} records processed.`,COLOR);
        })
        .then(() => {
          console.debug(`%chandleClickArray(): calling refresh()`,COLOR);
          this.refresh();
        })
        .then(() => {
          if (mode === "Delete") {
            this.showNotification(
              "Success!",
              `Deleted ${this.recordsProcessed} record(s).`,
              "success"
            );
          } else {
            this.showNotification(
              "Success!",
              `Marked ${this.recordsProcessed} record(s) as ${mode} .`,
              "success"
            );
          }
        })
        .catch((error) => {
          this.error = error;
          console.error(`%cERRORED ${JSON.stringify(error)}`,COLOR);
        });
    }
  }

  handleClickDelete(event) {
    console.info(`%chandleClickDelete(): entering`,COLOR);
    console.debug(
      `%chandleClickDelete(): Commencing imperative Call to deleteSessionObjectives(session)`,COLOR
    );
    deleteSessionObjectives({ sessionid: this.recordId })
      .then((result) => {
        console.log(`%chandleClickDelete(): returned ${result}`,COLOR);
      })
      .then(() => {
        console.log("Refreshing");
        this.refresh();
      })
      .then(() => {
        console.log("Toasty");
        this.showNotification(
          "Success!",
          "Deleted all Session Objective records for this session.",
          "success"
        );
      })
      .catch((error) => {
        this.error = error;
        console.log(`ERRORED ${JSON.stringify(error)}`);
      });
  }
  getSelectedName(event) {
    console.info(`%cgetSelectedName(): entering`,COLOR);

    this.selectedRows = event.detail.selectedRows;
    // Display that fieldName of the selected rows
    //for (let i = 0; i < selectedRows.length; i++){
    //alert("You selected: " + selectedRows[i].Name);
    //}
  }

  showNotification(t, m, v) {
    console.log("Toast...");
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v,
    });
    this.dispatchEvent(evt);
  }
}