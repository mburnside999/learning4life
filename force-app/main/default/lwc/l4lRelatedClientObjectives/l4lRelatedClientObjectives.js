/* eslint-disable no-console */
/*eslint no-console: ["error", { allow: ["warn", "error"] }] */
import { LightningElement, track, wire, api } from "lwc";
import getClientObjectives from "@salesforce/apex/L4LController.getClientObjectives";
import { CurrentPageReference } from "lightning/navigation";
//import {registerListener,unregisterAllListeners,fireEvent} from 'c/pubsub';
import { updateRecord } from "lightning/uiRecordApi";
import { deleteRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
// Lightning Message ervice
import {
  subscribe,
  APPLICATION_SCOPE,
  MessageContext
} from "lightning/messageService";

import L4LMC from "@salesforce/messageChannel/L4LMessageChannel__c";

//debugging
const COMPONENT = "l4lRelatedClientObjectives";
const COLOR = "color:magenta";
const DEBUG = "debug";
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
    label: "Last Correct",
    fieldName: "Last_Tested_Correct__c",
    type: "date"
  },
  {
    label: "Retest",
    fieldName: "Re_Test_Recommended__c",
    type: "boolean"
  },
  {
    label: "Notes",
    fieldName: "Client_Objective_Notes__c",
    type: "text"
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
    //     INFO,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `${COMPONENT}.renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     DEBUG,
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
    console.log(`in logger level=${level} tag=${tag} context=${context}`);
    let logger = this.template.querySelector("c-logger");
    logger.setScenario("c/l4lRelatedClientObjectives");
    switch (level) {
      case INFO:
        logger.info(message).setRecordId(context).addTag("logit()").addTag(tag);
        break;
      case DEBUG:
        logger
          .debug(message)
          .setRecordId(context)
          .addTag("logit()")
          .addTag(tag);
        break;
      case ERROR:
        logger
          .error(message)
          .setRecordId(context)
          .addTag("logit()")
          .addTag(tag);
        break;
      default:
    }

    logger.saveLog();
  }

  handleRowAction(event) {
    this.logit(
      DEBUG,
      `handleRowAction(): entering method`,
      `${COMPONENT}.handleRowAction()`,
      this.recordId
    );
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    this.logit(
      DEBUG,
      `handleRowAction(): row=${JSON.stringify(row)}, actionName=${actionName}`,
      `${COMPONENT}.handleRowAction()`,
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
              `${COMPONENT}.handleRowAction()`,
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
          DEBUG,
          `handleRowAction(): in edit_details`,
          `${COMPONENT}.handleRowAction()`,
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
    this.logit(
      DEBUG,
      `handleSuccess(): dispatching event`,
      `${COMPONENT}.handleSuccess()`
    );
    this.dispatchEvent(evt);
    this.areDetailsVisible = false;
    this.refresh();
  }

  refresh() {
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(
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
          INFO,
          `refresh(): getClientObjectives ${result.length} records returned`,
          `${COMPONENT}.refresh()`,
          this.recordId
        );
        this.logit(
          DEBUG,
          `refresh(): getClientObjectives result=${JSON.stringify(result)}`,
          `${COMPONENT}.refresh()`,
          this.recordId
        );
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `refresh(): getClientObjectives error ${JSON.stringify(error)}`,
          `${COMPONENT}.refresh()`,
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
      INFO,
      "handleSave(): in handleSave()",
      `${COMPONENT}.handleSave()`,
      this.recordId
    );
    this.logit(
      DEBUG,
      `handleSave(): draftValues=${JSON.stringify(event.detail.draftValues)}`,
      `${COMPONENT}.handleSave()`,
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
          `${COMPONENT}.handleSave()`,
          this.recordId
        );
      });
  }

  handleClick(event) {
    this.logit(
      INFO,
      `handleClick(): entering method`,
      `${COMPONENT}.handleClick()`,
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
      INFO,
      `handleSearchKeyInput(): entering method`,
      `${COMPONENT}.handleSearchKeyInput()`
    );
    const searchKey = event.target.value.toLowerCase();
    this.logit(
      DEBUG,
      `handleSearchKeyInput(): searchKey=${searchKey}`,
      `${COMPONENT}.handleSearchKeyInput()`
    );
    this.clientobjectives = this.filterableObjectives.filter(
      (so) =>
        so.Name.toLowerCase().includes(searchKey) ||
        (so.Status__c != null &&
          so.Status__c.toLowerCase().includes(searchKey)) ||
        so.SD_Name__c.toLowerCase().includes(searchKey) ||
        so.Program_Name__c.toLowerCase().includes(searchKey) ||
        so.Objective_Name__c.toLowerCase().includes(searchKey)
    );
    this.logit(
      DEBUG,
      `handleSearchKey(): this.clientobjectives=${JSON.stringify(
        this.clientobjectives
      )}`,
      `${COMPONENT}.handleSearchKey()`
    );
  }

  handleLMS(message) {
    this.logit(
      DEBUG,
      `handleLMS(): message received ${JSON.stringify(message)}`,
      `${COMPONENT}.handleLMS()`,
      this.recordId
    );
    this.receivedMessage = message
      ? JSON.stringify(message, null, "\t")
      : "no message payload";

    this.logit(
      INFO,
      `handleLMS(): calling Apex getClientObjectives`,
      `${COMPONENT}.handleLMS()`,
      this.recordId
    );

    getClientObjectives({
      clientId: this.recordId
    })
      .then((result) => {
        this.clientobjectives = result;
        this.filterableObjectives = result;
        this.logit(
          INFO,
          `handleLMS(): getClientObjectives returned ${result.length} records`,
          `${COMPONENT}.handleLMS()`,
          this.recordId
        );
        this.logit(
          DEBUG,
          `handleLMS(): getClientObjectives result= ${JSON.stringify(result)}`,
          `${COMPONENT}.handleLMS()`,
          this.recordId
        );
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `handleLMS(): getClientObjectives error ${JSON.stringify(error)}`,
          `${COMPONENT}.handleLMS()`,
          this.recordId
        );
      });
  }
}
