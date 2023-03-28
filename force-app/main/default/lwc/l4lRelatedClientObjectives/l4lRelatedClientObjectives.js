/* eslint-disable no-console */
/*eslint no-console: ["error", { allow: ["warn", "error"] }] */
import { LightningElement, track, wire, api } from "lwc";
//import getClientObjectives from "@salesforce/apex/L4LController.getClientObjectives";
import getClientObjectivesFilteredOnActive from "@salesforce/apex/L4LController.getClientObjectivesFilteredOnActive";
import deactivateClientObjective from "@salesforce/apex/L4LController.deactivateClientObjective";
import getCOActivationSummary from "@salesforce/apex/L4LController.getCOActivationSummary";

import { CurrentPageReference } from "lightning/navigation";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logFine, logInfo, logError } from "c/l4lNebulaUtil";
import { updateRecord } from "lightning/uiRecordApi";
import { deleteRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import setClientObjectivesByArray from "@salesforce/apex/L4LController.setClientObjectivesByArray";

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
const SCENARIO = "View and Manage client Objectives";
const COLOR = "color:red";

const actions = [
  {
    label: "Edit client objective details",
    name: "edit_details"
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
          `${SCENARIO}`,
          `${TAG}`
        );

        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): subscribing to message service `,
          `${SCENARIO}`,
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
          `${SCENARIO}`,
          `${TAG}`
        );
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): All good,session is commencing `,
          `${SCENARIO}`,
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
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  renderedCallback() {}

  get recs() {
    if (this.clientobjectives != null) return this.clientobjectives.length;
  }

  async btnConfirmation(event) {
    console.log("btnConfirmation");

    let _label = event.target.label;

    logInfo(
      this.recordId,
      `${COMPONENT}.btnConfirmation(): ${_label} action chosen on ${this.selectedRows.length} datatable rows, `,
      `${SCENARIO}`,
      `${TAG}`
    );

    if (this.selectedRows.length > 0) {
      if (_label == "De-Activate") {
        await LightningConfirm.open({
          message: `Deactivated client objective records will not be available to add to sessions. Are you sure?`,
          label: "Caution!",
          theme: "warning"

          // setting theme would have no effect
        }).then((result) => {
          if (result) {
            this.handleClickArray(_label);
          }
        });
      } else {
        await LightningConfirm.open({
          message: `This operation will update ${this.selectedRows.length} record(s). Are you sure?`,
          variant: "headerless",
          label: "this is the aria-label value"
          // setting theme would have no effect
        }).then((result) => {
          console.log(`result=${result}`);

          if (result) {
            this.handleClickArray(_label);
          }
        });
      }
    }
  }

  async confirmation(event) {
    let _actionName = event.detail.action.name;
    let _row = event.detail.row;

    logDebug(
      this.recordId,
      `${COMPONENT}.confirmation(): in confirmation(), calling LightningConfirm.open _actionName=${_actionName}, row=${JSON.stringify(
        _row
      )}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    if (_actionName == "delete") {
      logInfo(
        this.recordId,
        `${COMPONENT}.confirmation(): deleting client objectives`,
        `${SCENARIO}`,
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
            `${SCENARIO}`,
            `${TAG}`
          );
          this.handleRowAction(_actionName, _row);
        }
      });
    } else if (_actionName == "deactivate") {
      logInfo(
        this.recordId,
        `${COMPONENT}.confirmation(): deactivating client objective`,
        `${SCENARIO}`,
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
            `${SCENARIO}`,
            `${TAG}`
          );
          this.handleRowAction(_actionName, _row);
        }
      });
    } else {
      logDebug(
        this.recordId,
        `${COMPONENT}.confirmation() edit action chosen, calling handleRowAction`,
        `${SCENARIO}`,
        `${TAG}`
      );
      this.handleRowAction(_actionName, _row);
    }
  }

  getSelectedName(event) {
    this.selectedRows = event.detail.selectedRows;
    console.log(`this.selectedRows=${JSON.stringify(this.selectedRows)}`);
    logDebug(
      this.recordId,
      `${COMPONENT}.getSelectedName() this.selectedRows=${JSON.stringify(
        this.selectedRows
      )}`,
      `${SCENARIO}`,
      `${TAG}`
    );
  }

  handleRowAction(actionName, row) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleRowAction(): row=${JSON.stringify(
        row
      )}, actionName=${actionName}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    switch (actionName) {
      case "deactivate":
        logDebug(
          this.recordId,
          `${COMPONENT}.handleRowAction() calling deactivateClientObjective`,
          `${SCENARIO}`,
          `${TAG}`
        );
        deactivateClientObjective({ clientObjectiveId: row.Id })
          .then(() => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Cient Objective deactivated",
                variant: "success"
              })
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
        logDebug(
          this.recordId,
          `${COMPONENT}.handleRowAction(): calling deleteRecord()`,
          `${SCENARIO}`,
          `${TAG}`
        );
        deleteRecord(row.Id)
          .then(() => {
            logDebug(
              this.recordId,
              `${COMPONENT}.handleRowAction(): deleteRecord() returned succesfully`,
              `${SCENARIO}`,
              `${TAG}`
            );
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
              `${SCENARIO}`,
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
          `${SCENARIO}`,
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
      `${SCENARIO}`,
      `${TAG}`
    );
    this.dispatchEvent(evt);
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSuccess()`,
      `${SCENARIO}`,
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
      `${SCENARIO}`,
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
          `${SCENARIO}`,
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
          `${SCENARIO}`,
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
      `${SCENARIO}`,
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
          `${COMPONENT}.refresh(): Apex call to getClientObjectivesFilteredOnActive result= ${JSON.stringify(
            result
          )}`,
          `${SCENARIO}`,
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
          `${SCENARIO}`,
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
      `${COMPONENT}.handleSave(): draftValues=${JSON.stringify(
        event.detail.draftValues
      )}`,
      `${SCENARIO}`,
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
          `${SCENARIO}`,
          `${TAG}`
        );

        this.refresh();
      })
      .catch((error) => {
        logError(
          this.recordId,
          `${COMPONENT}.handleSave(): error: ${JSON.stringify(error)}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  handleClickArray(label) {
    let mode = "";
    switch (label) {
      case "Mark ACQ":
        mode = "ACQ";
        break;
      case "Mark OBJ":
        mode = "OBJ";
        break;
      case "Activate":
        mode = "Activate";
        break;
      case "De-Activate":
        mode = "Deactivate";
        break;
      default:
      // code block
    }

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): mode=${mode}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    console.log("mode=" + mode);
    /* 
 [{"Id":"a059n0000039TPFAA2","Name":"CO-000797",
"Client__c":"0018t000002vfSfAAI","Objective_Name__c":"Bath",
"SD_Name__c":"Non-Identical","Program_Name__c":"2D Matching",
"Re_Test_Recommended__c":false,"Active__c":true}]*/

    let _selectedRows = this.selectedRows.map((item) => {
      const container = {};
      container.Id = item.Id;
      container.Name = item.Name;
      container.Re_Test_Recommended__c = item.Re_Test_Recommended__c;
      container.Active__c = item.Active__c;
      container.Status__c = item.Status__c != undefined ? item.Status__c : null;
      return container;
    });

    console.log("=====>" + JSON.stringify(_selectedRows));

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): calling setClientObjectivesByArray`,
      `${SCENARIO}`,
      `${TAG}`
    );

    setClientObjectivesByArray({
      jsonstr: JSON.stringify(_selectedRows),
      val: mode
    })
      .then((result) => {
        this.recordsProcessed = result;
        logDebug(
          this.recordId,
          `${COMPONENT}.handleClickArray(): setClientObjectivesByArray returned ${this.recordsProcessed} count`,
          `${SCENARIO}`,
          `${TAG}`
        );
        console.log("======" + this.recordsProcessed);
      })
      .then(() => {
        this.refresh();
      })
      .then(() => {
        if (this.recordsProcessed > 0) {
          this.showNotification(
            "Success!",
            `${this.recordsProcessed} record(s) successfully updated.`,
            "success"
          );
        }
        if (this.recordsProcessed != _selectedRows.length) {
          let disparity = _selectedRows.length - this.recordsProcessed;
          this.showNotification(
            `${disparity} record updates failed`,
            `HINT: Remember to Activate any records before changing their status.`,
            "error"
          );
        }
        this.template.querySelector("lightning-datatable").selectedRows = [];
        this.template.querySelector("input").value = "";
      })
      .catch((error) => {
        console.log(JSON.stringify(error));

        //this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.handleClickArray error(): ${JSON.stringify(error)}`,
          `${SCENARIO}`,
          `${TAG}`
        );

        this.showNotification(
          "Error",
          "setClientObjectivesByArray() returned an error (too many records?) ",
          "error"
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
      `${SCENARIO}`,
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
      `${SCENARIO}`,
      `${TAG}`
    );

    const searchKey = event.target.value.toLowerCase();

    logFine(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput: searchKey=${searchKey}`,
      `${SCENARIO}`,
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
      `${SCENARIO}`,
      `${TAG}`
    );
  }

  handleLMS(message) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleLMS: message received ${JSON.stringify(message)}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    this.receivedMessage = message
      ? JSON.stringify(message, null, "\t")
      : "no message payload";

    logDebug(
      this.recordId,
      `${COMPONENT}.handleLMS: refreshing`,
      `${SCENARIO}`,
      `${TAG}`
    );
    this.refresh();

    // logDebug(
    //   this.recordId,
    //   `${COMPONENT}.handleLMS(): calling Apex getClientObjectivesFilteredOnActive this.showActiveOnly=${this.showActiveOnly}`,
    //   `${COMPONENT}.handleLMS(): calling Apex getClientObjectivesFilteredOnActive this.showActiveOnly=${this.showActiveOnly}`,
    //   `${TAG}`
    // );

    // getClientObjectivesFilteredOnActive({
    //   clientId: this.recordId,
    //   showActiveOnly: this.showActiveOnly
    // })
    //   .then((result) => {
    //     this.clientobjectives = result;
    //     this.filterableObjectives = result;
    //     logDebug(
    //       this.recordId,
    //       `${COMPONENT}.handleLMS(): Apex getClientObjectivesFilteredOnActive returned result: ${JSON.stringify(
    //         result
    //       )}`,
    //       `${COMPONENT}.handleLMS(): Apex getClientObjectivesFilteredOnActive returned result`,
    //       `${TAG}`
    //     );
    //   })
    //   .catch((error) => {
    //     this.error = error;
    //     logError(
    //       this.recordId,
    //       `${COMPONENT}.handleLMS(): error=${JSON.stringify(error)}`,
    //       `${COMPONENT}.handleLMS(): error=${JSON.stringify(error)}`,
    //       `${TAG}`
    //     );
    //   });

    // getCOActivationSummary({ clientId: this.recordId })
    //   .then((result) => {
    //     let tmp = JSON.parse(result);
    //     logDebug(
    //       this.recordId,
    //       `${COMPONENT}.refresh(): calling LFLController.refresh() getCOActivationSummary returned ${JSON.stringify(
    //         tmp
    //       )}`,
    //       `${COMPONENT}.refresh(): calling LFLController.refresh() getCOActivationSummary returned ${JSON.stringify(
    //         tmp
    //       )}`,
    //       `${TAG}`
    //     );
    //     this.inactiveCOCount = tmp.inactive;
    //     this.activeCOCount = tmp.active;
    //     this.totalCOCount = tmp.total;
    //     //this.activeString = result;
    //   })
    //   .catch((error) => {
    //     this.error = error;
    //     logError(
    //       this.recordId,
    //       `${COMPONENT}.refresh(): Apex call to getCOActivationSummary returned error: ${JSON.stringify(
    //         error
    //       )}`,
    //       `${COMPONENT}.refresh(): Apex call to getCOActivationSummary returned error: ${JSON.stringify(
    //         error
    //       )}`,
    //       `${TAG}`
    //     );
    //   });
  }

  showNotification(t, m, v) {
    console.info(`showNotification(): entering`, COLOR);
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v
    });
    this.dispatchEvent(evt);
  }
}
