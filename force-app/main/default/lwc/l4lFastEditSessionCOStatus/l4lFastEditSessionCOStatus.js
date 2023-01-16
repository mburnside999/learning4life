/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getClientObjectivesForSession from "@salesforce/apex/L4LController.getClientObjectivesForSession";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord } from "lightning/uiRecordApi";

const COMPONENT = "l4lFastEditSessionCOStatus";
const COLOR = "color:olive"; //for console log formatting
const DEBUG = "debug";
const INFO = "info";
const FINE = "fine";

const ERROR = "error";

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
    this.refresh();
  }
  renderedCallback() {
    // if (!this.rendered) {
    //   this.logit(
    //     DEBUG,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     FINE,
    //     "renderedCallback():  ignore - confirming logging",
    //     `renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     ERROR,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `renderedCallback()`,
    //     this.recordId
    //   );
    //   this.rendered = true;
    // }
  }

  logit(level, message, tag, context = null) {
    let _level = `${level}`;
    let _message = `${COMPONENT}.${message}`;
    let _tag = `${COMPONENT}.${tag}`;
    let _context = `${context}`;

    console.log(`in logger level=${_level} tag=${_tag} context=${_context}`);
    let logger = this.template.querySelector("c-logger");
    logger.setScenario(`${COMPONENT}`);
    switch (level) {
      case INFO:
        logger
          .info(_message)
          .setRecordId(_context)
          .addTag("logit()")
          .addTag(_tag);
        break;
      case DEBUG:
        logger
          .debug(_message)
          .setRecordId(_context)
          .addTag("logit()")
          .addTag(_tag);
        break;
      case FINE:
        logger
          .fine(_message)
          .setRecordId(_context)
          .addTag("logit()")
          .addTag(_tag);
        break;
      case ERROR:
        logger
          .error(_message)
          .setRecordId(_context)
          .addTag("logit()")
          .addTag(_tag);
        break;
      default:
    }

    logger.saveLog();
  }

  async handleSave(event) {
    // Convert datatable draft values into record objects
    const records = event.detail.draftValues.slice().map((draftValue) => {
      const fields = Object.assign({}, draftValue);
      return { fields };
    });

    // Clear all datatable draft values
    this.draftValues = [];

    try {
      // Update all records in parallel thanks to the UI API
      const recordUpdatePromises = records.map((record) =>
        updateRecord(record)
      );
      await Promise.all(recordUpdatePromises);

      // Report success with a toast
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Success",
          message: "Client Objective status updated",
          variant: "success"
        })
      );

      // Display fresh data in the datatable
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

    getClientObjectivesForSession({
      searchKey: this.recordId
    })
      .then((result) => {
        this.objectives = result;
        this.logit(
          DEBUG,
          `refresh(): getClientObjectivesForSession returned ${this.objectives.length} results`,
          `refresh()`,
          this.recordId
        );
        this.logit(
          FINE,
          `refresh(): getClientObjectivesForSession result= ${JSON.stringify(
            result
          )}`,
          `refresh()`,
          this.recordId
        );
        //console.debug(`refresh(): result=${JSON.stringify(result)}`);
        this.filterableObjectives = result;
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `refresh(): getClientObjectivesForSession errored: ${JSON.stringify(
            error
          )} results`,
          `refresh()`,
          this.recordId
        );
      });
  }

  handleSearchKeyInput(event) {
    this.logit(
      DEBUG,
      `handleSearchKey(): entering method`,
      `handleSearchKey()`
    );
    const searchKey = event.target.value.toLowerCase();

    this.logit(
      FINE,
      `handleSearchKey(): searchKey=${searchKey}`,
      `handleSearchKey()`
    );

    this.objectives = this.filterableObjectives.filter(
      (so) =>
        so.Program_Name__c.toLowerCase().includes(searchKey) ||
        (so.Status__c != null &&
          so.Status__c.toLowerCase().includes(searchKey)) ||
        so.SD_Name__c.toLowerCase().includes(searchKey) ||
        so.Objective_Name__c.toLowerCase().includes(searchKey)
    );

    this.logit(
      FINE,
      `handleSearchKey(): this.objectives=${JSON.stringify(this.objectives)}`,
      `handleSearchKey()`
    );
  }

  showNotification(t, m, v) {
    this.logit(
      FINE,
      `showNotification(): entering method, t=${t}, m=${m}, v=${v}`,
      `showNotification()`
    );
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v
    });
    this.dispatchEvent(evt);
  }
}
