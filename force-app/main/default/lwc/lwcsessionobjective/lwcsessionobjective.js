/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getSessionObjectives from "@salesforce/apex/MBSessionObjectives.getSessionObjectives";
import setSessionObjectivesByArray from "@salesforce/apex/MBSessionObjectives.setSessionObjectivesByArray";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import deleteSessionObjectives from "@salesforce/apex/MBSessionObjectives.deleteSessionObjectives";
import { registerListener, unregisterAllListeners, fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord } from "lightning/uiRecordApi";

import COMMENT_FIELD from "@salesforce/schema/Session_Obj__c.Comment__c";
import CORRECT_FIELD from "@salesforce/schema/Session_Obj__c.Correct__c";
import INCORRECT_FIELD from "@salesforce/schema/Session_Obj__c.Incorrect__c";
import PROMPTED_FIELD from "@salesforce/schema/Session_Obj__c.Prompted__c";
import ID_FIELD from "@salesforce/schema/Session_Obj__c.Id";

import { refreshApex } from "@salesforce/apex";
import { deleteRecord } from "lightning/uiRecordApi";

const COLOUR="color:blue";

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

  connectedCallback() {
    console.debug(`%cconnectedCallback(): subscribing to pub sub inputChangeEvent`,COLOUR);
    registerListener("inputChangeEvent", this.handleChange, this);
    console.log(`%cconnectedCallback(): calling refresh()`,COLOUR);
    this.refresh();
  }

  refresh() {
    console.info(`%crefresh(): entering`,COLOUR);
    console.debug(`%crefresh(): calling getSessionObjectives`,COLOUR);

    getSessionObjectives({ sess: this.recordId })
      .then((result) => {
        console.debug(`%crefresh() getSessionObjectives returned result=${JSON.stringify(result)}`,COLOUR);
        this.sessionObjectives = result;
        this.allObjectives = result;
        console.debug(`%crefresh(): sessionObjectives= ${JSON.stringify(this.sessionObjectives)}`,COLOUR);
      })
      .catch((error) => {
        this.error = error;
        console.error(`%crefresh(): ERROR: ${JSON.stringify(error)}`,COLOUR);
      });
  }

  handleSearchKeyInput(event) {
    console.info(`%chandleSearchKeyInput(): entering`,COLOUR);

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

  handleChange(inpVal) {
    console.info(`%chhandleChange(): entering`,COLOUR);

    console.debug(
      `%chandleChange(): PLACEHOLDER lwcsessionobjective component received pub sub input event`,COLOUR
    );
   console.debug( `%chandleChange(): calling refresh()`,COLOUR);

    this.refresh();
  }

  handleRowAction(event) {
    console.info(`%chhandleRowAction(): entering`,COLOUR);

    const actionName = event.detail.action.name;
    const row = event.detail.row;
    console.debug(`%chhandleRowAction(): row= ${JSON.stringify(row)}`,COLOUR);
    switch (actionName) {
      case "delete":
        console.debug(`handleRowAction(): DELETING`,COLOUR);
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
    console.info(`%chandleSAve(): entering`,COLOUR)
    console.debug(`%chandleSAve(): draftValues= ${JSON.stringify(event.detail.draftValues)}`,COLOUR);
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
    console.info(`%chandleClickArray(): entering`,COLOUR);
    console.debug(`%chandleClickArray(): Received event from button ${event.target.label}`,COLOUR);
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
        `%chandleClickArray(): Commencing imperative Call to setSessionObjectivesCorrectByArray(key)`,COLOUR
      );
      console.debug(`%chandleClickArray(): mode= ${mode}`,COLOUR);
      setSessionObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        val: mode,
      })
        .then((result) => {
          console.debug(`%chandleClickArray(): returned result ${result}`,COLOUR);
          this.recordsProcessed = result;
          console.debug(`%chandleClickArray(): ${this.recordsProcessed} records processed.`,COLOUR);
        })
        .then(() => {
          console.debug(`%chandleClickArray(): calling refresh()`,COLOUR);
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
          console.error(`%cERRORED ${JSON.stringify(error)}`,COLOUR);
        });
    }
  }

  handleClickDelete(event) {
    console.info(`%chandleClickDelete(): entering`,COLOUR);
    console.debug(
      `%chandleClickDelete(): Commencing imperative Call to deleteSessionObjectives(session)`,COLOUR
    );
    deleteSessionObjectives({ sessionid: this.recordId })
      .then((result) => {
        console.log(`%chandleClickDelete(): returned ${result}`,COLOUR);
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
    console.info(`%cgetSelectedName(): entering`,COLOUR);

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