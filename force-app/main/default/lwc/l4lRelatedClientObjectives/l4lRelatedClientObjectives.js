/**************************************************************
 * @name l4lRelatedClientObjectives
 * @author Mike Burnside
 * @date	2022
 * @group Learning For Life
 *
 * @description	LWC to list and manage client objectives.
 * Uses the Nebula logging framework and the Lightning Message Service
 */

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
const SCENARIO = "View and Manage client Objectives - LWC";
const UI_EVENT_TRACKING_SCENARIO =
  "l4lRelatedClientObjectives LWC UI Event Tracking";
const APEX_EVENT_TRACKING_SCENARIO =
  "l4lRelatedClientObjectives LWC APEX Event Tracking";

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
  @track isModalEditFormVisible = false;
  //@wire(getClientObjectives, { clientId: '$recordId' }) clientobjectives;
  subscription = null;
  @wire(MessageContext) messageContext;
  rendered = false;
  activeString;
  inactiveCOCount;
  activeCOCount;
  totalCOCount;
  showActiveOnly = true;

  /*******************************************************************************************************
   * @name ConnectedCallback
   * @description
   * sets up logging
   * sets up subscription handle for Messaging Service
   * performs initial call to refresh()
   *
   * @param
   * @return
   */

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

        logInfo(
          this.recordId,
          `${COMPONENT}: connectedCallback()`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

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

  /*******************************************************************************************************
   * @name recs
   * @description getter, returns this.clientobjectives.length to the UI as {recs}
   *
   * @param
   * @return
   */

  get recs() {
    if (this.clientobjectives != null) return this.clientobjectives.length;
  }

  /*******************************************************************************************************
   * @name btnConfirmation
   * @description the onclick handler for the Mark ACQ, Mark OBJ, Activate and De-Activate buttons.
   * Intercedes to provides a confirmation message for the proposed action before delegatiung the actual
   * work to handleClickArray.
   *
   *
   * @param event from the button click
   * @return
   */

  async btnConfirmation(event) {
    console.log("btnConfirmation");

    let _label = event.target.label;

    logDebug(
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

  /*******************************************************************************************************
   * @name confirmation
   * @description the onrowaction handler for the lightning-datatable.
   * Provides a confirmation message for the proposed action before delegatiung the actual
   * work to handleRowAction.
   *
   *
   * @param event from the onrowaction on the datatable record
   * @return
   */

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
      logDebug(
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
      logDebug(
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

  /*******************************************************************************************************
   * @name handleRowAction
   * @description Determines the action required.
   * Uses the uiRecordApi.deleteRecord service for deletes.
   * Uses call to Apex deactivateClientObjective for de-activate.
   * When edit requested sets this.isModalEditFormVisible flag to true to show the modal edit form
   * Refreshes the UI via refresh()
   *
   *
   * @param actionName from the button click - "deactivate","delete","edit_details"
   * @param row, the row of the datatable associated with the action
   * @return
   */

  handleRowAction(actionName, row) {
    logInfo(
      this.recordId,
      `${COMPONENT}: RowAction: ${actionName}`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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

        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: L4LController.deactivateClientObjective`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

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
        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: lightning/uiRecordApi/deleteRecord`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

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

        this.isModalEditFormVisible = true;
        break;
      default:
    }
  }

  /*******************************************************************************************************
   * @name handleSuccess
   * @description the onsuccess handler for the modal lightning-record-form
   *
   *
   * @param event
   * @return
   */
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
    this.isModalEditFormVisible = false;

    let inp = this.template.querySelector("input");
    inp.value = "";
    this.refresh();
  }

  /*******************************************************************************************************
   * @name refresh
   * @description the main refresh method.
   * Calls Apex getCOActivationSummary to get the activation summaries - activeCOCount, inactiveCOCount, totalCOCount
   * Calls getClientObjectivesFilteredOnActive to list the CO records with a filter, this.showActiveOnly
   * @param event
   * @return
   */

  refresh() {
    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling LFLController.getCOActivationSummary() `,
      `${SCENARIO}`,
      `${TAG}`
    );

    console.info(`%crefresh(): calling getCOActivationSummary`, COLOR);
    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LController.getCOActivationSummary`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LController.getClientObjectivesFilteredOnActive`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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

  /*******************************************************************************************************
   * @name handleCancel
   * @description the handler for the Cancel on modal edit form.
   * Closes the modal via by this.isModalEditFormVisible = false
   *
   * @param event
   * @return
   */

  handleCancel(event) {
    console.info(`%chandleCancel(): entering`, COLOR);
    this.isModalEditFormVisible = false;
  }

  /*******************************************************************************************************
   * @name handleSave
   * @description the handler for the Save on modal edit form.
   * Uses UpdateRecord service from lightning/uiRecordApi
   * Refreshes the UI via refresh()
   *
   * @param event, the event from save
   * @return
   */

  handleSave(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSave(): draftValues=${JSON.stringify(
        event.detail.draftValues
      )}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: lightning/uiRecordApi/updateRecord`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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

  /*******************************************************************************************************
   * @name handleClickArray
   * @description mixed mode update of Client Objectives
   * called from confirmation() step, calls Apex to update a collection of COs  with a "mode" of ACQ, OBJ, Activate or De-Activate
   * ACQ/OBJ will update the client_objective__c.status__c field on the records
   * Activate/De-Acticvate will update the client_objective__c.active__c field on the records
   *
   * Sets all selected rows to the same mode value.
   *
   * Builds a JSON array to pass to Apex setClientObjectivesByArray that processes the UPDATE of the status or active values.
   * On completion refreshes the UI via refresh() and pops up toast.
   *
   * @param label, identifies the button pressed e.g. Mark ACQ, Activate etc.
   * @return
   */

  handleClickArray(label) {
    logInfo(
      this.recordId,
      `${COMPONENT}: DataTable MultiRow Button: ${label}`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    let mode = "";
    switch (label) {
      case "Mark ACQ":
        mode = "ACQ";
        break;
      case "Re-Test Weekly":
        mode = "WEEKLY";
        break;
      case "Re-Test Fortnightly":
        mode = "FORTNIGHTLY";
        break;
      case "Re-Test Monthly":
        mode = "MONTHLY";
        break;
      case "Re-Test Twice-Weekly":
        mode = "TWICE-WEEKLY";
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
      container.Frequency__c =
        item.Frequency__c != undefined ? item.Frequency__c : null;
      return container;
    });

    console.log("=====>" + JSON.stringify(_selectedRows));

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): calling setClientObjectivesByArray`,
      `${SCENARIO}`,
      `${TAG}`
    );

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LController.setClientObjectivesByArray`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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

  /*******************************************************************************************************
   * @name handleActiveCheckboxChange
   * @description handler for the onchange event for the show-active-only checkbox on the UI
   * Toggles this.showActiveOnly flag, which us used in the UI refresh()
   *
   * @param event
   * @return
   */

  handleActiveCheckboxChange(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: Checkbox: Active/Inactive`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    this.showActiveOnly = !this.showActiveOnly;
    console.log("this.showActiveOnly=" + this.showActiveOnly);
    let inp = this.template.querySelector("input");
    inp.value = "";
    this.refresh();
  }

  /*******************************************************************************************************
   * @name handleClose
   * @description onclick handler for the Close button on the modal lightning-record-form
   * @param event
   * @return
   */
  handleClose(event) {
    this.isModalEditFormVisible = false;
    //experimental
    this.refresh();
  }

  /*******************************************************************************************************
   * @name handleSearchKeyInput
   * @description oninput handler for the Filter field.
   * Provides real time filtering by reducing this.clientobjectives which is bound to the UI datatable.
   * @param event
   * @return
   */
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

  /*******************************************************************************************************
   * @name handleLMS
   * @description message service handler for subscriptions.
   * On receipt of published message refreshes the UI via refresh()
   * @param message
   * @return
   */

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
  }

  /*******************************************************************************************************
   * @name showNotification
   * @description helper to fire Toast notifications
   * @param t, the title
   * @param m, the message
   * @param v, variant
   *
   */

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
