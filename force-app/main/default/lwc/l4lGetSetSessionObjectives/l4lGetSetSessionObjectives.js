/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getSessionObjectives from "@salesforce/apex/L4LController.getSessionObjectives";
import setSessionObjectivesByArray from "@salesforce/apex/L4LController.setSessionObjectivesByArray";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import deleteSessionObjectives from "@salesforce/apex/L4LController.deleteSessionObjectives";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord, getRecord, getFieldValue } from "lightning/uiRecordApi";

// import COMMENT_FIELD from "@salesforce/schema/Session_Obj__c.Comment__c";
// import CORRECT_FIELD from "@salesforce/schema/Session_Obj__c.Correct__c";
// import INCORRECT_FIELD from "@salesforce/schema/Session_Obj__c.Incorrect__c";
// import PROMPTED_FIELD from "@salesforce/schema/Session_Obj__c.Prompted__c";
// import ID_FIELD from "@salesforce/schema/Session_Obj__c.Id";

// import { refreshApex } from "@salesforce/apex";
import { deleteRecord } from "lightning/uiRecordApi";
// Lightning Message service
import {
  subscribe,
  APPLICATION_SCOPE,
  MessageContext
} from "lightning/messageService";

import L4LMC from "@salesforce/messageChannel/L4LSessionMessageChannel__c";

//debugging
const COMPONENT = "l4lGetSetSessionObjectives";
const COLOR = "color:blue"; //for console log formatting
const DEBUG = "debug";
const INFO = "info";
const ERROR = "error";

const actions = [{ label: "Delete", name: "delete" }];
const lockedactions = [];

import STATUS_FIELD from "@salesforce/schema/Session__c.Status__c";
const FIELDS = [STATUS_FIELD];

const columns = [
  { label: "Prog", fieldName: "Program__c", type: "text", initialWidth: 150 },
  {
    label: "Obj",
    fieldName: "Objective_Name__c",
    type: "text",
    initialWidth: 150
  },
  { label: "SD", fieldName: "SD__c", type: "text", initialWidth: 150 },
  {
    label: "Corr.",
    fieldName: "Correct__c",
    type: "boolean",
    initialWidth: 90,
    cellAttributes: { alignment: "right" },
    editable: true
  },
  {
    label: "Incr.",
    fieldName: "Incorrect__c",
    type: "boolean",
    initialWidth: 90,
    cellAttributes: { alignment: "right" },
    editable: true
  },
  {
    label: "Prmpt.",
    fieldName: "Prompted__c",
    type: "boolean",
    initialWidth: 90,
    cellAttributes: { alignment: "right" },
    editable: true
  },
  {
    label: "Prev",
    fieldName: "Previous_Status__c",
    type: "text",
    initialWidth: 80
  },
  {
    label: "Comments",
    fieldName: "Comment__c",
    type: "text",
    editable: true
  },
  {
    type: "action",
    typeAttributes: { rowActions: actions }
  }
];

const lockedcolumns = [
  { label: "Prog", fieldName: "Program__c", type: "text", initialWidth: 150 },
  {
    label: "Obj",
    fieldName: "Objective_Name__c",
    type: "text",
    initialWidth: 150
  },
  { label: "SD", fieldName: "SD__c", type: "text", initialWidth: 150 },
  {
    label: "Corr.",
    fieldName: "Correct__c",
    type: "boolean",
    initialWidth: 90,
    cellAttributes: { alignment: "right" },
    editable: false
  },
  {
    label: "Incr.",
    fieldName: "Incorrect__c",
    type: "boolean",
    initialWidth: 90,
    cellAttributes: { alignment: "right" },
    editable: false
  },
  {
    label: "Prmpt.",
    fieldName: "Prompted__c",
    type: "boolean",
    initialWidth: 90,
    cellAttributes: { alignment: "right" },
    editable: false
  },
  {
    label: "Prev",
    fieldName: "Previous_Status__c",
    type: "text",
    initialWidth: 80
  },
  {
    label: "Comments",
    fieldName: "Comment__c",
    type: "text",
    editable: false
  },
  {
    type: "action",
    typeAttributes: { rowActions: lockedactions }
  }
];

//const selectedRows = {};
//var fred;
export default class L4lGetSetSessionObjectives extends LightningElement {
  @track editflag = true;
  @api testSessionStatus;
  @api sessionStatus;
  @api recordId = "a3N2v000003Gr4VEAS"; //this is session 31
  //@wire(getSessionObjectives, { sess: '$recordId' }) sessionObjectives;
  @track sessionObjectives;
  @track isLocked = false;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  @wire(CurrentPageReference) pageRef;
  @track draftValues = [];
  @track allObjectives = {};
  @wire(MessageContext) messageContext;
  @wire(getRecord, { recordId: "$recordId", fields: FIELDS }) session;

  subscription = null;
  rendered = false;

  renderedCallback() {
    console.log("ZZZZZZZZZZZZ rendered");
    if (getFieldValue(this.session.data, STATUS_FIELD) == "Closed") {
      this.isLocked = true;
    } else {
      this.isLocked = false;
    }
    this.columns = this.isLocked ? lockedcolumns : columns;

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
  connectedCallback() {
    console.debug(
      `%cconnectedCallback(): subscribing to LMS L4LSessionMessageChannel__c`,
      COLOR
    );
    this.subscription = subscribe(
      this.messageContext,
      L4LMC,
      (message) => {
        this.handleLMS(message);
      },
      { scope: APPLICATION_SCOPE }
    );
    console.debug(`%cconnectedCallback(): calling refresh()`, COLOR);
    console.log(
      `%cconnectedCallback() Status = ${JSON.stringify(this.session.data)}`
    );
    console.log(`id =  ${this.recordId}`);
    console.log(`this.session = ${JSON.stringify(this.session)}`);
    //this.getTheSessionStatus();

    this.refresh();
  }

  get status() {
    // if (getFieldValue(this.session.data, STATUS_FIELD) == "Closed") {
    //   this.isLocked = true;
    // } else {
    //   this.isLocked = false;
    // }
    // this.columns = this.isLocked ? lockedcolumns : columns;

    return getFieldValue(this.session.data, STATUS_FIELD);
  }

  logit(level, message, tag, context = null) {
    console.log("in logger");
    let logger = this.template.querySelector("c-logger");
    logger.setScenario(`${COMPONENT}`);
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

  refresh() {
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(`%crefresh(): calling getSessionObjectives`, COLOR);

    getSessionObjectives({ sess: this.recordId })
      .then((result) => {
        this.sessionObjectives = result;
        this.allObjectives = result;

        this.logit(
          INFO,
          `${COMPONENT}.refresh(): getSessionObjectives ${result.length} records returned`,
          `${COMPONENT}.refresh()`,
          this.recordId
        );
        this.logit(
          DEBUG,
          `${COMPONENT}.refresh(): getSessionObjectives result=${JSON.stringify(
            result
          )}, this.objectives=${JSON.stringify(this.objectives)}`,
          `${COMPONENT}.refresh()`,
          this.recordId
        );
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `${COMPONENT}.refresh(): getSessionObjectives errored: ${JSON.stringify(
            error
          )} results`,
          `${COMPONENT}.refresh()`,
          this.recordId
        );
      });
  }

  handleSearchKeyInput(event) {
    this.logit(
      INFO,
      `${COMPONENT}.handleSearchKey(): entering method`,
      `${COMPONENT}.handleSearchKey()`
    );
    const searchKey = event.target.value.toLowerCase();

    this.logit(
      DEBUG,
      `${COMPONENT}.handleSearchKey(): searchKey=${searchKey}`,
      `${COMPONENT}.handleSearchKey()`
    );
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
    this.logit(
      DEBUG,
      `${COMPONENT}.handleSearchKey(): this.sessionObjectives=${JSON.stringify(
        this.sessionObjectives
      )}`,
      `${COMPONENT}.handleSearchKey()`
    );
  }

  handleLMS(message) {
    this.logit(
      DEBUG,
      `${COMPONENT}.handleLMS(): message received ${JSON.stringify(message)}`,
      `${COMPONENT}.handleLMS()`,
      this.recordId
    );

    this.receivedMessage = message
      ? JSON.stringify(message, null, "\t")
      : "no message payload";

    this.logit(
      INFO,
      `${COMPONENT}.handleLMS(): refreshing`,
      `${COMPONENT}.handleLMS()`,
      this.recordId
    );

    this.refresh();
  }

  handleRowAction(event) {
    this.logit(
      DEBUG,
      `${COMPONENT}.handleRowAction(): entering method`,
      `${COMPONENT}.handleRowAction()`,
      this.recordId
    );

    const actionName = event.detail.action.name;
    const row = event.detail.row;
    this.logit(
      DEBUG,
      `${COMPONENT}.handleRowAction(): row=${JSON.stringify(
        row
      )}, actionName=${actionName}`,
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
                message: "Session Objective deleted",
                variant: "success"
              })
            );
            this.refresh();
          })
          .catch((error) => {
            this.logit(
              ERROR,
              `${COMPONENT}.handleRowAction(): error=${JSON.stringify(error)}`,
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
        console.debug("EDIT DETAILS");
        break;
      default:
    }
  }

  handleSave(event) {
    this.logit(
      DEBUG,
      `${COMPONENT}.handleSave(): in handleSave()`,
      `${COMPONENT}.handleSave()`,
      this.recordId
    );

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
            variant: "success"
          })
        );
        // Clear all draft values
        this.draftValues = [];

        // Display fresh data in the datatable
        this.refresh();
      })
      .catch((error) => {
        //Handle error
        this.logit(
          ERROR,
          `handleSave(): ${JSON.stringify(error)}`,
          `${COMPONENT}.handleSave()`,
          this.recordId
        );
      });
  }

  handleClickArray(event) {
    this.logit(
      DEBUG,
      `${COMPONENT}.handleClickArray(): in handleClickArray`,
      `${COMPONENT}.handleClickArray()`,
      this.recordId
    );

    let mode = "";
    let label = event.target.label;
    this.logit(
      DEBUG,
      `${COMPONENT}.handleClickArray(): label=${label}`,
      `${COMPONENT}.handleClickArray()`,
      this.recordId
    );
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
      this.logit(
        INFO,
        `${COMPONENT}.handleClickArray(): calling setSessionObjectivesByArray `,
        `${COMPONENT}.handleClickArray()`,
        this.recordId
      );

      this.logit(
        DEBUG,
        `${COMPONENT}.handleClickArray(): jsonstr=${JSON.stringify(
          this.selectedRows
        )} val=${mode}`,
        `${COMPONENT}.handleClickArray()`,
        this.recordId
      );

      setSessionObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        val: mode
      })
        .then((result) => {
          this.recordsProcessed = result;

          this.logit(
            DEBUG,
            `${COMPONENT}.handleClickArray(): result=${JSON.stringify(
              result
            )} val=${mode}`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
        })
        .then(() => {
          this.logit(
            INFO,
            `${COMPONENT}.handleClickArray(): refreshing`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
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
          this.logit(
            ERROR,
            `${COMPONENT}.handleClickArray(): error ${JSON.stringify(error)}`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
        });
    }
  }

  handleClickDelete(event) {
    this.logit(
      INFO,
      `${COMPONENT}.handleClickDelete(): in handleClickDelete`,
      `${COMPONENT}.handleClickDelete()`,
      this.recordId
    );

    this.logit(
      INFO,
      `${COMPONENT}.handleClickDelete(): calling deleteSessionObjectives`,
      `${COMPONENT}.handleClickDelete()`,
      this.recordId
    );
    deleteSessionObjectives({ sessionid: this.recordId })
      .then((result) => {
        this.logit(
          DEBUG,
          `${COMPONENT}.handleClickDelete(): Apex:deleteSessionObjectives returned ${result}`,
          `${COMPONENT}.handleClickDelete()`,
          this.recordId
        );
      })
      .then(() => {
        this.logit(
          INFO,
          `${COMPONENT}.handleClickDelete(): refreshing`,
          `${COMPONENT}.handleClickDelete()`,
          this.recordId
        );
        this.refresh();
      })
      .then(() => {
        this.showNotification(
          "Success!",
          "Deleted all Session Objective records for this session.",
          "success"
        );
      })
      .catch((error) => {
        this.error = error;

        this.logit(
          ERROR,
          `handleClickDelete(): error ${JSON.stringify(error)}`,
          `${COMPONENT}.handleClickDelete()`,
          this.recordId
        );
      });
  }
  getSelectedName(event) {
    this.logit(
      INFO,
      `${COMPONENT}.getSelectedName(): in getSelectedName`,
      `${COMPONENT}.getSelectedName()`,
      this.recordId
    );

    this.selectedRows = event.detail.selectedRows;

    this.logit(
      DEBUG,
      `${COMPONENT}.getSelectedName(): this.selectedRows=${JSON.stringify(
        this.selectedRows
      )}`,
      `${COMPONENT}.getSelectedName()`,
      this.recordId
    );
    // Display that fieldName of the selected rows
    //for (let i = 0; i < selectedRows.length; i++){
    //alert("You selected: " + selectedRows[i].Name);
    //}
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