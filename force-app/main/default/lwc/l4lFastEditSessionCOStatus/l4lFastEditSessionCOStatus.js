/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getClientObjectivesForSession from "@salesforce/apex/L4LController.getClientObjectivesForSession";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord } from "lightning/uiRecordApi";
import { logDebug, logFine, logError } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";

const COMPONENT = "l4lFastEditSessionCOStatus";
const TAG = "L4L-Fast-Edit-Client-Objectives";

const COLOR = "color:olive"; //for console log formatting

const columns = [
  {
    label: "Prog",
    fieldName: "Program_Name__c",
    type: "text"
  },
  {
    label: "SD",
    fieldName: "SD_Name__c",
    type: "text"
  },
  {
    label: "Obj",
    fieldName: "Objective_Name__c",
    type: "text"
  },
  {
    label: "Status",
    fieldName: "Status__c",
    editable: true,
    type: "text"
  },
  {
    label: "Re-Test Due",
    fieldName: "Re_Test_Recommended__c",
    type: "boolean"
  }
];

export default class L4lFastEditSessionCOStatus extends LightningElement {
  @wire(CurrentPageReference) pageRef;
  @api recordId = "a3N2v000003Gr4VEAS"; //session 31 for testing
  @track filterableObjectives = {};
  //@wire(getObjectives, { sess: '$recordId' }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  @track objectives;
  draftValues = [];
  @track correctCount = 0;
  @track nonResponsiveCount = 0;
  @track incorrectCount = 0;
  @track promptedCount = 0;
  @track selectCount = 0;

  @track breadcrumb = "";
  @track results = [];
  @track sessionresults = [];
  @track skillstring = [];
  rendered = false;

  connectedCallback() {
    console.info(`in connectedCallback`, COLOR);
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback: columns=${JSON.stringify(
            this.columns
          )}`,
          `${COMPONENT}.connectedCallback: columns=${JSON.stringify(
            this.columns
          )}`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback: initial refresh of client objectives`,
          `${COMPONENT}.connectedCallback: initial refresh of client objectives`,
          `${TAG}`
        );
        this.refresh();
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback(): error: ${JSON.stringify(error)}`,
          `${COMPONENT}.connectedCallback(): error: ${JSON.stringify(error)} `,
          `${TAG}`
        );
      });
  }

  async handleSave(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSave(): draftValues=${JSON.stringify(
        event.detail.draftValues
      )}`,
      `${COMPONENT}.handleSave(), logging the draft values`,
      `${TAG}`
    );

    // Convert datatable draft values into record objects
    const records = event.detail.draftValues.slice().map((draftValue) => {
      const fields = Object.assign({}, draftValue);
      return { fields };
    });

    // Clear all datatable draft values
    this.draftValues = [];

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSave(): entering try-block, update values using lightning/uiRecordApi updateRecord`,
      `${COMPONENT}.handleSave(): entering try-block, update values using lightning/uiRecordApi updateRecord`,
      `${TAG}`
    );

    try {
      // Update all records in parallel thanks to the UI API
      const recordUpdatePromises = records.map((record) =>
        updateRecord(record)
      );
      await Promise.all(recordUpdatePromises);

      logDebug(
        this.recordId,
        `${COMPONENT}.handleSave(): Promises resolved`,
        `${COMPONENT}.handleSave(): Promises resolved`,
        `${TAG}`
      );

      // Report success with a toast
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Success",
          message: "Client Objective status updated",
          variant: "success"
        })
      );

      // Display fresh data in the datatable

      logDebug(
        this.recordId,
        `${COMPONENT}.handleSave(): calling refresh`,
        `${COMPONENT}.handleSave(): calling refresh}`,
        `${TAG}`
      );
      this.refresh();
    } catch (error) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "An error occurred while updating the record.",
          message:
            "Suggestion: check that your Status code is valid (ACQ, OBJ, etc.)",
          variant: "error"
        })
      );
    }
  }

  refresh() {
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(`%crefresh(): calling getClientObjectivesForSession`, COLOR);

    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): entering `,
      `${COMPONENT}.refresh(): entering`,
      `${TAG}`
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.refresh() calling LFLController.getClientObjectivesForSession() `,
      `${COMPONENT}.refresh() calling LFLController.getClientObjectivesForSession()`,
      `${TAG}`
    );

    getClientObjectivesForSession({
      searchKey: this.recordId
    })
      .then((result) => {
        this.objectives = result;
        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex call to getClientObjectivesForSession result= ${JSON.stringify(
            result
          )}`,
          `${COMPONENT}.refresh(): client objectives refreshed, records logged, setting this.filterableObjectives=result`,
          `${TAG}`
        );

        this.filterableObjectives = result;
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.refresh(): Apex call to getClientObjectivesForSession returned error: ${JSON.stringify(
            error
          )}`,
          `${COMPONENT}.refresh(): client objectives refresh failed`,
          `${TAG}`
        );
      });
  }

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

    this.objectives = this.filterableObjectives.filter(
      (so) =>
        so.Program_Name__c.toLowerCase().includes(searchKey) ||
        (so.Status__c != null &&
          so.Status__c.toLowerCase().includes(searchKey)) ||
        so.SD_Name__c.toLowerCase().includes(searchKey) ||
        so.Objective_Name__c.toLowerCase().includes(searchKey)
    );
  }

  showNotification(t, m, v) {
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v
    });
    this.dispatchEvent(evt);
  }

  handleClickCancel(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickCancel: entering method, dispatching CustomEvent(close)`,
      `${COMPONENT}.handleClickCancel: entering method, dispatching CustomEvent(close)`,
      `${TAG}`
    );

    this.dispatchEvent(new CustomEvent("close"));
  }
}
