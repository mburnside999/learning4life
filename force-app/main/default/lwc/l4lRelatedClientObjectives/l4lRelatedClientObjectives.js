/* eslint-disable no-console */
/*eslint no-console: ["error", { allow: ["warn", "error"] }] */
import { LightningElement, track, wire, api } from "lwc";
import getClientObjectives from "@salesforce/apex/L4LController.getClientObjectives";
import { CurrentPageReference } from "lightning/navigation";
//import {registerListener,unregisterAllListeners,fireEvent} from 'c/pubsub';
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
const COLOR = "color:red";
const DEBUG = "debug";
const FINE = "fine";
const INFO = "info";
const ERROR = "error";

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
    console.info(`%cconnectedCallback(): entering`, COLOR);
    console.info(`%cconnectedCallback(): subscribing LMS`, COLOR);
    //console.debug(`%cconnectedCallback(): registering listener inputChangeEvent`,COLOR);
    //registerListener('inputChangeEvent', this.handleChange, this);
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
    this.refresh();
  }

  renderedCallback() {
    // if (!this.rendered) {
    //   this.logit(
    //     DEBUG,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `${COMPONENT}.renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     FINE,
    //     "renderedCallback():  ignore - confirming logging",
    //     `${COMPONENT}.renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     ERROR,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `${COMPONENT}.renderedCallback()`,
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

  async confirmation(event) {
    this.logit(
      DEBUG,
      `confirmation(): in confirmation()`,
      `confirmation()`,
      this.recordId
    );
    let _actionName = event.detail.action.name;
    let _row = event.detail.row;
    this.logit(
      FINE,
      `confirmation(): in confirmation(), calling LightningConfirm.open _actionName=${_actionName}, row=${JSON.stringify(
        _row
      )}`,
      `confirmation()`,
      this.recordId
    );
    if (_actionName == "delete") {
      await LightningConfirm.open({
        message: `Deleting client objective record: "${_row.Program_Name__c} > ${_row.SD_Name__c} > ${_row.Objective_Name__c}".  Are you sure?`,
        variant: "headerless",
        label: "this is the aria-label value"
        // setting theme would have no effect
      }).then((result) => {
        console.log(`result={result}`);
        this.logit(
          DEBUG,
          `confirmation(): result=${result}`,
          `confirmation()`,
          this.recordId
        );

        if (result) {
          this.logit(
            DEBUG,
            `confirmation(): calling handleRowAction`,
            `confirmation()`,
            this.recordId
          );
          this.handleRowAction(_actionName, _row);
        }
      });
    } else this.handleRowAction(_actionName, _row);
  }

  handleRowAction(actionName, row) {
    this.logit(
      FINE,
      `handleRowAction(): entering method`,
      `handleRowAction()`,
      this.recordId
    );
    //const actionName = event.detail.action.name;
    //const row = event.detail.row;

    this.logit(
      FINE,
      `handleRowAction(): row=${JSON.stringify(row)}, actionName=${actionName}`,
      `handleRowAction()`,
      this.recordId
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
            this.refresh();
          })
          .catch((error) => {
            this.logit(
              ERROR,
              `handleRowAction(): error=${JSON.stringify(error)}`,
              `handleRowAction()`,
              this.recordId
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
        this.logit(
          FINE,
          `handleRowAction(): in edit_details`,
          `handleRowAction()`,
          row.Id
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
    this.logit(FINE, `handleSuccess(): dispatching event`, `handleSuccess()`);
    this.dispatchEvent(evt);
    this.areDetailsVisible = false;
    this.refresh();
  }

  refresh() {
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
        this.logit(
          DEBUG,
          `refresh(): getClientObjectives ${result.length} records returned`,
          `refresh()`,
          this.recordId
        );
        this.logit(
          FINE,
          `refresh(): getClientObjectives result=${JSON.stringify(result)}`,
          `refresh()`,
          this.recordId
        );
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `refresh(): getClientObjectives error ${JSON.stringify(error)}`,
          `refresh()`,
          this.recordId
        );
      });
  }

  handleCancel(event) {
    console.info(`%chandleCancel(): entering`, COLOR);
    this.areDetailsVisible = false;
  }
  handleSave(event) {
    this.logit(
      DEBUG,
      "handleSave(): in handleSave()",
      `handleSave()`,
      this.recordId
    );
    this.logit(
      FINE,
      `handleSave(): draftValues=${JSON.stringify(event.detail.draftValues)}`,
      `handleSave()`,
      this.recordId
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
        this.refresh();
      })
      .catch((error) => {
        this.logit(
          ERROR,
          `handleSave(): Promise.all error`,
          `handleSave()`,
          this.recordId
        );
      });
  }

  handleClick(event) {
    this.logit(
      DEBUG,
      `handleClick(): entering method`,
      `handleClick()`,
      this.recordId
    );
    this.refresh();
  }

  // disconnectedCallback() {
  //     // unsubscribe from inputChangeEvent event
  //     unregisterAllListeners(this);
  // }

  handleSearchKeyInput(event) {
    this.logit(
      DEBUG,
      `handleSearchKeyInput(): entering method`,
      `handleSearchKeyInput()`
    );
    const searchKey = event.target.value.toLowerCase();
    this.logit(
      FINE,
      `handleSearchKeyInput(): searchKey=${searchKey}`,
      `handleSearchKeyInput()`
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
    this.logit(
      FINE,
      `handleSearchKey(): this.clientobjectives=${JSON.stringify(
        this.clientobjectives
      )}`,
      `handleSearchKey()`
    );
  }

  handleLMS(message) {
    this.logit(
      FINE,
      `handleLMS(): message received ${JSON.stringify(message)}`,
      `handleLMS()`,
      this.recordId
    );
    this.receivedMessage = message
      ? JSON.stringify(message, null, "\t")
      : "no message payload";

    this.logit(
      DEBUG,
      `handleLMS(): calling Apex getClientObjectives`,
      `handleLMS()`,
      this.recordId
    );

    getClientObjectives({
      clientId: this.recordId
    })
      .then((result) => {
        this.clientobjectives = result;
        this.filterableObjectives = result;
        this.logit(
          DEBUG,
          `handleLMS(): getClientObjectives returned ${result.length} records`,
          `handleLMS()`,
          this.recordId
        );
        this.logit(
          FINE,
          `handleLMS(): getClientObjectives result= ${JSON.stringify(result)}`,
          `handleLMS()`,
          this.recordId
        );
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `handleLMS(): getClientObjectives error ${JSON.stringify(error)}`,
          `handleLMS()`,
          this.recordId
        );
      });
  }
}
