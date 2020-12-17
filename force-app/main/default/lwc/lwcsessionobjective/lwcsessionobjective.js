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

const actions = [{ label: "Delete", name: "delete" }];

const columns = [
  { label: "Prog", fieldName: "Program__c", type: "text" },
  { label: "Obj", fieldName: "Objective_Name__c", type: "text" },
  { label: "SD", fieldName: "SD__c", type: "text" },
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
  { label: "Comments", fieldName: "Comment__c", type: "text", editable: true },
  { label: "Prev", fieldName: "Previous_Status__c", type: "text" },
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
  //@track sessionObjectives;
  @wire(CurrentPageReference) pageRef;
  @track draftValues = [];
  @track allObjectives = {};

  connectedCallback() {
    console.log("subscribing to pub sub inputChangeEvent");
    registerListener("inputChangeEvent", this.handleChange, this);
    this.refresh();
  }

  refresh() {
    console.log("in refactored refresh()");
    getSessionObjectives({ sess: this.recordId })
      .then((result) => {
        console.log("RETURNED");
        this.sessionObjectives = result;
        this.allObjectives = result;
        console.log(JSON.stringify(this.sessionObjectives));
      })
      .catch((error) => {
        this.error = error;
        console.log("ERROR" + JSON.stringify(error));
      });
  }

  handleSearchKeyInput(event) {
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
    console.log(
      "PLACEHOLDER lwcsessionobjective component received pub sub input event"
    );
    this.refresh();
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    console.log(JSON.stringify(row));
    switch (actionName) {
      case "delete":
        console.log("DELETING");
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
        console.log("EDIT DETAILS");
        break;
      default:
    }
  }

  handleSave(event) {
    console.log(JSON.stringify(event.detail.draftValues));
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
    console.log("Received event from button " + event.target.label);
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
      console.log(
        "Commencing imperative Call to setSessionObjectivesCorrectByArray(key) "
      );
      console.log("mode=" + mode);
      setSessionObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        val: mode,
      })
        .then((result) => {
          console.log("RETURNED");
          this.recordsProcessed = result;
          console.log(this.recordsProcessed + "records processed.");
        })
        .then(() => {
          console.log("Refreshing");
          this.refresh();
        })
        .then(() => {
          if (mode === "Delete") {
            this.showNotification(
              "Success!",
              "Deleted " + this.recordsProcessed + " record(s).",
              "success"
            );
          } else {
            this.showNotification(
              "Success!",
              "Marked " + this.recordsProcessed + " record(s) as " + mode + ".",
              "success"
            );
          }
        })
        .catch((error) => {
          this.error = error;
          console.log("ERRORED" + JSON.stringify(error));
        });
    }
  }

  handleClickDelete(event) {
    console.log(
      "Commencing imperative Call to deleteSessionObjectives(session) "
    );
    deleteSessionObjectives({ sessionid: this.recordId })
      .then((result) => {
        console.log("RETURNED");
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
        console.log("ERRORED" + JSON.stringify(error));
      });
  }
  getSelectedName(event) {
    let myselectedRows = event.detail.selectedRows;
    this.selectedRows = myselectedRows;
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
