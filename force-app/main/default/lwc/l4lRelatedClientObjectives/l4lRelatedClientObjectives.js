/* eslint-disable no-console */
/*eslint no-console: ["error", { allow: ["warn", "error"] }] */
import { LightningElement, track, wire, api } from "lwc";
//import getClientObjectives from "@salesforce/apex/L4LController.getClientObjectives";
import getClientObjectivesFilteredOnActive from "@salesforce/apex/L4LController.getClientObjectivesFilteredOnActive";
import deactivateClientObjective from "@salesforce/apex/L4LController.deactivateClientObjective";
import getCOActivationSummary from "@salesforce/apex/L4LController.getCOActivationSummary";

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
    label: "Edit client objective details",
    name: "edit_details"
  },
  {
    label: "Deactivate client objective",
    name: "deactivate"
  },
  {
    label: "Delete this client objective (CAUTION)",
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
    type: "boolean",
    initialWidth: 60
  },
  {
    label: "Notes",
    fieldName: "Client_Objective_Notes__c",
    type: "text",
    wrapText: true
  },
  {
    label: "Active",
    fieldName: "Active__c",
    type: "boolean",
    initialWidth: 60
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
  activeString;
  inactiveCOCount;
  activeCOCount;
  totalCOCount;

  showActiveOnly = true;
  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${TAG}`
        );

        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): subscribing to message service `,
          `${COMPONENT}.connectedCallback(): subscribing to message service`,
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

        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): initial refresh of client objectives`,
          `${COMPONENT}.connectedCallback(): initial refresh of client objectives`,
          `${TAG}`
        );
        this.refresh();
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
          `${TAG}`
        );
      });
  }
  renderedCallback() {}

  get recs() {
    if (this.clientobjectives != null) return this.clientobjectives.length;
  }

  async confirmation(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.confirmation(): entering method`,
      `${COMPONENT}.confirmation(): edit or delete action chosen on client objective datatable row`,
      `${TAG}`
    );
    let _actionName = event.detail.action.name;
    let _row = event.detail.row;

    logDebug(
      this.recordId,
      `${COMPONENT}.confirmation(): in confirmation(), calling LightningConfirm.open _actionName=${_actionName}, row=${JSON.stringify(
        _row
      )}`,
      `${COMPONENT}.confirmation(): edit / delete row details`,
      `${TAG}`
    );

    if (_actionName == "delete") {
      logDebug(
        this.recordId,
        `${COMPONENT}.confirmation(): deleting client objectives, ask for confirmation`,
        `${COMPONENT}.confirmation(): deleting client objectives, ask for confirmation`,
        `${TAG}`
      );

      await LightningConfirm.open({
        message: `Deleting record: "${_row.Program_Name__c} > ${_row.SD_Name__c} > ${_row.Objective_Name__c}".  Are you sure?`,
        label:
          "Caution: Deleting client objective records is not recommended, there may be session objectives already allocated.",
        theme: "error"

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
            `${COMPONENT}.confirmation(): deletion decision received`,
            `${TAG}`
          );
          this.handleRowAction(_actionName, _row);
        }
      });
    } else if (_actionName == "deactivate") {
      logDebug(
        this.recordId,
        `${COMPONENT}.confirmation(): deactivating client objective`,
        `${COMPONENT}.confirmation(): deactivating client objective`,
        `${TAG}`
      );

      await LightningConfirm.open({
        message: `Deactivating "${_row.Program_Name__c} > ${_row.SD_Name__c} > ${_row.Objective_Name__c}".  Are you sure?`,
        label:
          "Warning: deactivated client objective records will not be available to add to sessions until activated.",
        theme: "warning"

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
            `${COMPONENT}.confirmation(): deactivate decision received`,
            `${TAG}`
          );
          this.handleRowAction(_actionName, _row);
        }
      });
    } else {
      logDebug(
        this.recordId,
        `${COMPONENT}.confirmation() edit action chosen, calling handleRowAction`,
        `${COMPONENT}.confirmation() edit action chosen`,
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
      `${COMPONENT}.handleRowAction(): process the edit or delete`,
      `${TAG}`
    );

    switch (actionName) {
      case "deactivate":
        deactivateClientObjective({ clientId: row.Id })
          .then(() => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Cient Objective deactivated",
                variant: "success"
              })
            );
            logDebug(
              this.recordId,
              `${COMPONENT}.handleRowAction(): deactivate()`,
              `${COMPONENT}.handleRowAction(): deactivation processed successfully, refreshing client objectives`,
              `${TAG}`
            );
            let inp = this.template.querySelector("input");
            inp.value = "";
            this.refresh();
          })
          .catch((error) => {
            logError(
              this.recordId,
              `${COMPONENT}.handleRowAction(): error=${JSON.stringify(error)}`,
              "error occurred during deactivation",
              `${TAG}`
            );

            this.dispatchEvent(
              new ShowToastEvent({
                title: "Error deactivating record",
                message: "Error",
                variant: "error"
              })
            );
          });
        break;
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
              `${COMPONENT}.handleRowAction(): edit_details()`,
              `${COMPONENT}.handleRowAction(): delete processed successfully, refreshing client objectives`,
              `${TAG}`
            );
            let inp = this.template.querySelector("input");
            inp.value = "";
            this.refresh();
          })
          .catch((error) => {
            logError(
              this.recordId,
              `${COMPONENT}.handleRowAction(): error=${JSON.stringify(error)}`,
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
          `${COMPONENT}.handleRowAction() tell the edit modal to show`,
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
      `${COMPONENT}.handleSuccess():`,
      `${COMPONENT}.handleSuccess(): showing the success toast`,
      `${TAG}`
    );
    this.dispatchEvent(evt);
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSuccess()`,
      `${COMPONENT}.handleSuccess(): telling the edit modal to hide and refreshing client objectives`,
      `${TAG}`
    );
    this.areDetailsVisible = false;

    let inp = this.template.querySelector("input");
    inp.value = "";
    this.refresh();
  }

  refresh() {
    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling LFLController.getCOActivationSummary() `,
      `${COMPONENT}.refresh(): calling LFLController.getCOActivationSummary() `,
      `${TAG}`
    );

    console.info(`%crefresh(): calling getCOActivationSummary`, COLOR);

    getCOActivationSummary({ clientId: this.recordId })
      .then((result) => {
        let tmp = JSON.parse(result);
        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): calling LFLController.refresh() getCOActivationSummary returned ${JSON.stringify(
            tmp
          )}`,
          `${COMPONENT}.refresh(): calling LFLController.refresh() getCOActivationSummary returned ${JSON.stringify(
            tmp
          )}`,
          `${TAG}`
        );
        this.inactiveCOCount = tmp.inactive;
        this.activeCOCount = tmp.active;
        this.totalCOCount = tmp.total;
        //this.activeString = result;
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.refresh(): Apex call to getCOActivationSummary returned error: ${JSON.stringify(
            error
          )}`,
          `${COMPONENT}.refresh(): Apex call to getCOActivationSummary returned error: ${JSON.stringify(
            error
          )}`,
          `${TAG}`
        );
      });

    console.info(
      `%crefresh(): calling getClientObjectivesFilteredOnActive, showActiveOnly=${this.showActiveOnly}, recordId = ${this.recordId}`,
      COLOR
    );
    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling LFLController.getClientObjectivesFilteredOnActive() showActiveOnly=${this.showActiveOnly} `,
      `${COMPONENT}.refresh(): processing the refresh request`,
      `${TAG}`
    );

    getClientObjectivesFilteredOnActive({
      clientId: this.recordId,
      showActiveOnly: this.showActiveOnly
    })
      .then((result) => {
        this.clientobjectives = result;
        this.filterableObjectives = result;

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): returned from Apex call to getClientObjectivesFilteredOnActive, ${result.length} records returned`,
          `${COMPONENT}.refresh(): client objectives refreshed, record count logged`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex call to getClientObjectivesFilteredOnActive result= ${JSON.stringify(
            result
          )}`,
          `${COMPONENT}.refresh(): client objectives refreshed, records logged`,
          `${TAG}`
        );
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.refresh(): Apex call to getClientObjectivesFilteredOnActive returned error: ${JSON.stringify(
            error
          )}`,
          `${COMPONENT}.refresh(): Apex call to getClientObjectivesFilteredOnActive returned error: ${JSON.stringify(
            error
          )}`,
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
      `${COMPONENT}.handleSave(): saving the client records`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSave(): draftValues=${JSON.stringify(
        event.detail.draftValues
      )}`,
      `${COMPONENT}.handleSave(): logging the draft values`,
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
          `${COMPONENT}.handleSave(): client objectives saved, draft values cleared,refreshing client objectives list`,
          `${TAG}`
        );

        this.refresh();
      })
      .catch((error) => {
        logError(
          this.recordId,
          `${COMPONENT}.handleSave(): error: ${JSON.stringify(error)}`,
          `${COMPONENT}.handleSave(): error encountered while saving client objectives`,
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
      `${COMPONENT}.handleClick: refresh button clicked, refreshing Client Objectives`,
      `${TAG}`
    );
    this.refresh();
  }

  handleChange(event) {
    this.showActiveOnly = !this.showActiveOnly;
    console.log("this.showActiveOnly=" + this.showActiveOnly);
    let inp = this.template.querySelector("input");
    inp.value = "";
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
      `${COMPONENT}.handleSearchKeyInput: entering method`,
      `${TAG}`
    );

    const searchKey = event.target.value.toLowerCase();

    logFine(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput: searchKey=${searchKey}`,
      `${COMPONENT}.handleSearchKeyInput: searchKey=${searchKey}`,
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
      `${COMPONENT}.handleSearchKeyInput: this.clientobjectives logged`,
      `${TAG}`
    );
  }

  handleLMS(message) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleLMS: message received ${JSON.stringify(message)}`,
      `${COMPONENT}.handleLMS: message received ${JSON.stringify(message)}`,
      `${TAG}`
    );

    this.receivedMessage = message
      ? JSON.stringify(message, null, "\t")
      : "no message payload";

    logDebug(
      this.recordId,
      `${COMPONENT}.handleLMS(): calling Apex getClientObjectivesFilteredOnActive this.showActiveOnly=${this.showActiveOnly}`,
      `${COMPONENT}.handleLMS(): calling Apex getClientObjectivesFilteredOnActive this.showActiveOnly=${this.showActiveOnly}`,
      `${TAG}`
    );

    getClientObjectivesFilteredOnActive({
      clientId: this.recordId,
      showActiveOnly: this.showActiveOnly
    })
      .then((result) => {
        this.clientobjectives = result;
        this.filterableObjectives = result;
        logDebug(
          this.recordId,
          `${COMPONENT}.handleLMS(): Apex getClientObjectivesFilteredOnActive returned result: ${JSON.stringify(
            result
          )}`,
          `${COMPONENT}.handleLMS(): Apex getClientObjectivesFilteredOnActive returned result`,
          `${TAG}`
        );
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.handleLMS(): error=${JSON.stringify(error)}`,
          `${COMPONENT}.handleLMS(): error=${JSON.stringify(error)}`,
          `${TAG}`
        );
      });
  }
}
