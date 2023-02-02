/* eslint-disable no-console */
/*eslint no-console: ["error", { allow: ["warn", "error"] }] */
import { LightningElement, track, wire, api } from "lwc";
import getClientObjectives from "@salesforce/apex/L4LController.getClientObjectives";
import { CurrentPageReference } from "lightning/navigation";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logFine, logError } from "c/l4lNebulaUtil";
import { updateRecord } from "lightning/uiRecordApi";
import { deleteRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

// Lightning Message service
import {
  subscribe,
  APPLICATION_SCOPE,
  MessageContext
} from "lightning/messageService";

import L4LMC from "@salesforce/messageChannel/L4LMessageChannel__c";
import LightningConfirm from "lightning/confirm";

//debugging
const COMPONENT = "l4lRelatedClientObjectives";
const TAG = "L4L-Manage-Client-Objectives";

const COLOR = "color:red";

const actions = [
  {
    label: "Edit details",
    name: "edit_details"
  },
  {
    label: "Delete",
    name: "delete"
  }
];

const columns = [
  {
    label: "Program",
    fieldName: "Program_Name__c",
    type: "text"
  },
  {
    label: "SD",
    fieldName: "SD_Name__c",
    type: "text"
  },
  {
    label: "Objective",
    fieldName: "Objective_Name__c",
    type: "text"
  },
  {
    label: "Status",
    fieldName: "Status__c",
    type: "text"
  },
  {
    label: "Frequency",
    fieldName: "Frequency__c",
    type: "text"
  },
  {
    label: "Last Tested Correct",
    fieldName: "Last_Tested_Correct__c",
    type: "date-local"
  },
  {
    label: "Retest",
    fieldName: "Re_Test_Recommended__c",
    type: "boolean"
  },
  {
    label: "Notes",
    fieldName: "Client_Objective_Notes__c",
    type: "text",
    wrapText: true
  },
  {
    type: "action",
    typeAttributes: {
      rowActions: actions
    }
  }
];

export default class L4lRelatedClientObjectives extends LightningElement {
  @track clientId = "";
  @api recordId = "0012v00002fY86nAAC";
  @track COrecordId = "";
  @track COobjectApiName = "Client_Objective__c";
  @track columns = columns;
  @track clientobjectives;
  filterableObjectives = {};
  @wire(CurrentPageReference) pageRef;
  @track draftValues = [];
  @track areDetailsVisible = false;
  //@wire(getClientObjectives, { clientId: '$recordId' }) clientobjectives;
  subscription = null;
  @wire(MessageContext) messageContext;
  rendered = false;

  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
      })
      .catch((error) => {
        console.log("Error");
      });

    console.info(`%cconnectedCallback(): entering`, COLOR);
    console.info(`%cconnectedCallback(): subscribing LMS`, COLOR);
    //console.debug(`%cconnectedCallback(): registering listener inputChangeEvent`,COLOR);
    //registerListener('inputChangeEvent', this.handleChange, this);

    logDebug(
      this.recordId,
      `${COMPONENT}.connectedCallback(): subscribing to message service `,
      "subscribing to message service",
      `${TAG}`
    );

    this.subscription = subscribe(
      this.messageContext,
      L4LMC,
      (message) => {
        this.handleLMS(message);
      },
      { scope: APPLICATION_SCOPE }
    );
    console.debug(
      `%cconnectedCallback(): calling this.refresh() to get client objectives, recordId =  ${this.recordId}`,
      COLOR
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.connectedCallback(): initial refresh of client objectives`,
      "initial refresh of client objectives",
      `${TAG}`
    );

    this.refresh();
  }
  renderedCallback() {}

  async confirmation(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.confirmation(): entering method`,
      "edit or delete action chosen on client objective datatable row",
      `${TAG}`
    );
    let _actionName = event.detail.action.name;
    let _row = event.detail.row;

    logDebug(
      this.recordId,
      `${COMPONENT}.confirmation(): in confirmation(), calling LightningConfirm.open _actionName=${_actionName}, row=${JSON.stringify(
        _row
      )}`,
      "edit / delete row details",
      `${TAG}`
    );

    if (_actionName == "delete") {
      logDebug(
        this.recordId,
        `deleting client objectives, ask for confirmation`,
        "deleting client objectives, ask for confirmation",
        `${TAG}`
      );
      await LightningConfirm.open({
        message: `Deleting client objective record: "${_row.Program_Name__c} > ${_row.SD_Name__c} > ${_row.Objective_Name__c}".  Are you sure?`,
        variant: "headerless",
        label: "this is the aria-label value"
        // setting theme would have no effect
      }).then((result) => {
        console.log(`result={result}`);
        // this.logit(
        //   DEBUG,
        //   `confirmation(): result=${result}`,
        //   `confirmation()`,
        //   this.recordId
        // );

        if (result) {
          logDebug(
            this.recordId,
            `${COMPONENT}.confirmation(): result=${result}, calling handleRowAction `,
            "deletion decision received",
            `${TAG}`
          );
          this.handleRowAction(_actionName, _row);
        }
      });
    } else {
      logDebug(
        this.recordId,
        `${COMPONENT}.confirmation() edit action chosen, calling handleRowAction`,
        "edit action chosen",
        `${TAG}`
      );
      this.handleRowAction(_actionName, _row);
    }
  }

  handleRowAction(actionName, row) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleRowAction(): row=${JSON.stringify(
        row
      )}, actionName=${actionName}`,
      "process the edit or delete",
      `${TAG}`
    );

    switch (actionName) {
      case "delete":
        deleteRecord(row.Id)
          .then(() => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Cient Objective deleted",
                variant: "success"
              })
            );
            logDebug(
              this.recordId,
              `${COMPONENT}.handleRowAction() edit_details()`,
              "delete processed successfully, refreshing client objectives",
              `${TAG}`
            );
            this.refresh();
          })
          .catch((error) => {
            logError(
              this.recordId,
              `${COMPONENT}.handleRowAction(): error=${error}`,
              "delete error occurred",
              `${TAG}`
            );

            this.dispatchEvent(
              new ShowToastEvent({
                title: "Error deleting record",
                message: "Error",
                variant: "error"
              })
            );
          });
        break;
      case "edit_details":
        this.COrecordId = row.Id;

        logDebug(
          this.recordId,
          `${COMPONENT}.handleRowAction() edit_details()`,
          "tell the edit modal to show",
          `${TAG}`
        );

        this.areDetailsVisible = true;
        break;
      default:
    }
  }

  handleSuccess(event) {
    const evt = new ShowToastEvent({
      title: "Success",
      message: "Client objective updated",
      variant: "success"
    });

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSuccess()`,
      "showing the success toast",
      `${TAG}`
    );
    this.dispatchEvent(evt);
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSuccess()`,
      "telling the edit modal to hide and refreshing client objectives",
      `${TAG}`
    );
    this.areDetailsVisible = false;
    this.refresh();
  }

  refresh() {
    logDebug(
      this.recordId,
      `${COMPONENT}.refresh() calling LFLController.getClientObjectives() `,
      "processing the refresh request",
      `${TAG}`
    );
    console.info(`%crefresh(): entering`, COLOR);
    console.info(
      `%crefresh(): calling getClientObjectives, recordId = ${this.recordId}`,
      COLOR
    );
    getClientObjectives({
      clientId: this.recordId
    })
      .then((result) => {
        this.clientobjectives = result;
        this.filterableObjectives = result;

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): returned from Apex call to getClientObjectives, ${result.length} records returned`,
          `client objectives refreshed, record count logged`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex call to getClientObjectives result= ${JSON.stringify(
            result
          )}`,
          "client objectives refreshed, records logged",
          `${TAG}`
        );
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.refresh(): Apex call to getClientObjectives returned error: ${error}`,
          "client objectives refresh failed",
          `${TAG}`
        );
      });
  }

  handleCancel(event) {
    console.info(`%chandleCancel(): entering`, COLOR);
    this.areDetailsVisible = false;
  }

  handleSave(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSave(): entering method`,
      "saving the client records",
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `handleSave(): draftValues=${JSON.stringify(event.detail.draftValues)}`,
      `logging the draft values`,
      `${TAG}`
    );

    const recordInputs = event.detail.draftValues.slice().map((draft) => {
      const fields = Object.assign({}, draft);
      return {
        fields
      };
    });
    const promises = recordInputs.map((recordInput) =>
      updateRecord(recordInput)
    );
    Promise.all(promises)
      .then((contacts) => {
        console.debug(`%chandleSave(): Promise.all resolved`, COLOR);
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Success",
            message: "Client objectives updated",
            variant: "success"
          })
        );
        // Clear all draft values
        this.draftValues = [];

        // Display fresh data in the datatable
        logDebug(
          this.recordId,
          `${COMPONENT}.handleSave(): client objectives saved, draft values cleared, refreshing client objectives list `,
          "client objectives saved, draft values cleared,refreshing client objectives list",
          `${TAG}`
        );

        this.refresh();
      })
      .catch((error) => {
        logError(
          this.recordId,
          `${COMPONENT}.handleSave(): error: ${error}`,
          "error encountered while saving client objectives",
          `${TAG}`
        );
      });
  }

  handleClick(event) {
    // this.logit(
    //   DEBUG,
    //   `handleClick(): entering method`,
    //   `handleClick()`,
    //   this.recordId
    // );
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClick: refresh button clicked, refreshing Client Objectives`,
      "refresh button clicked, refreshing Client Objectives",
      `${TAG}`
    );
    this.refresh();
  }
  handleClose(event) {
    this.areDetailsVisible = false;
    //experimental
    this.refresh();
  }
  // disconnectedCallback() {
  //     // unsubscribe from inputChangeEvent event
  //     unregisterAllListeners(this);
  // }

  handleSearchKeyInput(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput: entering method`,
      "handleSearchKeyInput",
      `${TAG}`
    );

    const searchKey = event.target.value.toLowerCase();

    logFine(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput: searchKey=${searchKey}`,
      "handleSearchKeyInput",
      `${TAG}`
    );
    this.clientobjectives = this.filterableObjectives.filter(
      (so) =>
        so.Name.toLowerCase().includes(searchKey) ||
        (so.Status__c != null &&
          so.Status__c.toLowerCase().includes(searchKey)) ||
        so.SD_Name__c.toLowerCase().includes(searchKey) ||
        so.Program_Name__c.toLowerCase().includes(searchKey) ||
        so.Objective_Name__c.toLowerCase().includes(searchKey) ||
        (so.Frequency__c != null &&
          so.Frequency__c.toLowerCase().includes(searchKey)) ||
        (so.Last_Tested_Correct__c != null &&
          so.Last_Tested_Correct__c.toLowerCase().includes(searchKey)) ||
        (so.Client_Objective_Notes__c != null &&
          so.Client_Objective_Notes__c.toLowerCase().includes(searchKey))
    );
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput: this.clientobjectives=${JSON.stringify(
        this.clientobjectives
      )}`,
      "handleSearchKeyInput",
      `${TAG}`
    );
  }

  handleLMS(message) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleLMS: message received ${JSON.stringify(message)}`,
      "handleLMS",
      `${TAG}`
    );

    this.receivedMessage = message
      ? JSON.stringify(message, null, "\t")
      : "no message payload";

    logDebug(
      this.recordId,
      `${COMPONENT}.handleLMS(): calling Apex getClientObjectives`,
      "handle-LMS",
      `${TAG}`
    );

    getClientObjectives({
      clientId: this.recordId
    })
      .then((result) => {
        this.clientobjectives = result;
        this.filterableObjectives = result;
        logDebug(
          this.recordId,
          `${COMPONENT}.handleLMS(): Apex getClientObjectives returned result: ${JSON.stringify(
            result
          )}`,
          "handle-LMS",
          `${TAG}`
        );
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.handleLMS(): error=${error}`,
          "handle-LMS",
          `${TAG}`
        );
      });
  }
}
