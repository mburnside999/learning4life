/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord, getRecord, getFieldValue } from "lightning/uiRecordApi";
import { deleteRecord } from "lightning/uiRecordApi";
import LightningConfirm from "lightning/confirm";

//custom Apex methods
import getSessionObjectives from "@salesforce/apex/L4LController.getSessionObjectives";
import setSessionObjectivesByArray from "@salesforce/apex/L4LController.setSessionObjectivesByArray";
import deleteSessionObjectives from "@salesforce/apex/L4LController.deleteSessionObjectives";

// The Lightning Message service
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
const FINE = "fine";
const INFO = "info";
const ERROR = "error";

//experimental comment editing
import COMMENT_FIELD from "@salesforce/schema/Session_Obj__c.Comment__c";

//fields for display
const actions = [
  { label: "Delete", name: "delete" },
  { label: "Details", name: "detail" }
];
import SESSION_STATUS_FIELD from "@salesforce/schema/Session__c.Status__c";
const SESSIONFIELDS = [SESSION_STATUS_FIELD];
//columns when the session is open
const columns = [
  { label: "Prog", fieldName: "Program__c", type: "text", initialWidth: 200 },
  { label: "SD", fieldName: "SD__c", type: "text", initialWidth: 200 },
  {
    label: "Obj",
    fieldName: "Objective_Name__c",
    type: "text",
    initialWidth: 200
  },
  {
    label: "Prev",
    fieldName: "Previous_Status__c",
    type: "text",
    initialWidth: 80
  },
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
    label: "Non Rsp.",
    fieldName: "NonResponsive__c",
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
  // {
  //   label: "Comments",
  //   fieldName: "Comment__c",
  //   type: "text",
  //   editable: true
  // },
  {
    label: "Comments",
    type: "button-icon",
    initialWidth: 300,
    wrapText: true,
    typeAttributes: {
      iconName: { fieldName: "rowIcon" },
      name: "detail",
      variant: "border-filled",
      value: "detail"
    }
  }
];
//columns when the session is locked
const lockedcolumns = [
  { label: "Prog", fieldName: "Program__c", type: "text", initialWidth: 200 },
  { label: "SD", fieldName: "SD__c", type: "text", initialWidth: 200 },
  {
    label: "Obj",
    fieldName: "Objective_Name__c",
    type: "text",
    initialWidth: 200
  },
  {
    label: "Prev",
    fieldName: "Previous_Status__c",
    type: "text",
    initialWidth: 80
  },
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
    label: "Non Rsp.",
    fieldName: "NonResponsive__c",
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
    label: "Comments",
    fieldName: "Comment__c",
    initialWidth: 300,
    type: "text",
    wrapText: true,
    editable: false
  }
  // {
  //   type: "button-icon",
  //   initialWidth: 40,
  //   typeAttributes: {
  //     iconName: { fieldName: "rowIcon" },
  //     name: "detail",
  //     variant: "border-filled",
  //     value: "detail"
  //   }
  //}
];

export default class L4lGetSetSessionObjectives extends LightningElement {
  // session_obj__c for modal
  SOobjectApiName = "Session_Obj__c";
  //get the session (status)
  @wire(getRecord, { recordId: "$recordId", fields: SESSIONFIELDS }) session;
  //track the session objective for the modal
  @track sessionObjectiveId;
  @track areDetailsVisible = false;

  @api recordId = "a3N2v000003Gr4VEAS"; //this is session 31
  @track sessionObjectives;
  @track isLocked = false;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  @wire(CurrentPageReference) pageRef;
  @track draftValues = [];
  @track allObjectives = {};

  @api testSessionStatus;
  @api sessionStatus;
  //experimental comment editing
  fields = [COMMENT_FIELD];
  // messaging
  @wire(MessageContext) messageContext;
  subscription = null;

  renderedCallback() {
    if (getFieldValue(this.session.data, SESSION_STATUS_FIELD) == "Closed") {
      this.isLocked = true;
    } else {
      this.isLocked = false;
    }
    console.log("this.isLocked=" + this.isLocked);
    this.columns = this.isLocked ? lockedcolumns : columns;
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
    this.refresh();
  }

  get status() {
    console.log(
      `get status(): session__c.status__c = ${getFieldValue(
        this.session.data,
        SESSION_STATUS_FIELD
      )}`
    );
    return getFieldValue(this.session.data, SESSION_STATUS_FIELD);
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

  refresh() {
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(`%crefresh(): calling APEX getSessionObjectives`, COLOR);

    getSessionObjectives({ sess: this.recordId })
      .then((result) => {
        this.sessionObjectives = result.map((row) => ({
          ...row,
          rowIcon: row.Comment__c != null ? "utility:quick_text" : "utility:add"
        }));

        console.log(`this.sessionObjectives=${this.sessionObjectives}`);
        this.allObjectives = this.sessionObjectives;

        //this.sessionObjectives=result;
        //this.allObjectives = result;

        this.logit(
          DEBUG,
          `refresh(): APEX getSessionObjectives returned ${result.length} records`,
          `refresh()`,
          this.recordId
        );
        this.logit(
          FINE,
          `refresh(): getSessionObjectives JSON result=${JSON.stringify(
            result
          )}, this.objectives=${JSON.stringify(this.objectives)}`,
          `refresh()`,
          this.recordId
        );
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `refresh(): getSessionObjectives errored: ${JSON.stringify(
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
      `handleSearchKey(): entering method, bound to input.oninput`,
      `handleSearchKey()`
    );
    const searchKey = event.target.value.toLowerCase();

    this.logit(
      FINE,
      `handleSearchKey(): searchKey=${searchKey}`,
      `handleSearchKey()`
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
      FINE,
      `handleSearchKey(): this.sessionObjectives=${JSON.stringify(
        this.sessionObjectives
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

    this.logit(DEBUG, `handleLMS(): refreshing`, `handleLMS()`, this.recordId);

    this.refresh();
  }

  handleRowAction(event) {
    this.logit(
      FINE,
      `handleRowAction(): entering method, bound to lightning-datatable.onrowaction`,
      `handleRowAction()`,
      this.recordId
    );

    const actionName = event.detail.action.name;
    const row = event.detail.row;
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
                message: "Session Objective deleted",
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
      case "detail":
        this.areDetailsVisible = true;
        this.sessionObjectiveId = row.Id;
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
      `handleSave(): entering handleSave(), bound to lightning-datable.onSave`,
      `handleSave()`,
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
          `handleSave()`,
          this.recordId
        );
      });
  }

  async confirmation(event) {
    this.logit(
      DEBUG,
      `confirmation(): in confirmation(), calling LightningConfirm.open`,
      `confirmation()`,
      this.recordId
    );

    let _label = event.target.label;
    if (this.selectedRows.length > 0) {
      await LightningConfirm.open({
        message: `This operation will update or delete ${this.selectedRows.length} record(s). Are you sure?`,
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
            `confirmation(): calling handleClickArray with label=${_label}`,
            `confirmation()`,
            this.recordId
          );
          this.handleClickArray(_label);
        }
      });
    }
  }

  handleClickArray(label) {
    this.logit(
      FINE,
      `handleClickArray(): in handleClickArray`,
      `handleClickArray()`,
      this.recordId
    );

    let mode = "";

    this.logit(
      FINE,
      `handleClickArray(): label=${label}`,
      `handleClickArray()`,
      this.recordId
    );
    switch (label) {
      case "Mark Correct":
        mode = "Correct";
        break;
      case "Mark Incorrect":
        mode = "Incorrect";
        break;
      case "Mark Non-Responsive":
        mode = "NonResponsive";
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

    //need to get rid of the iconName for DML
    let _selectedRows = this.selectedRows.map((item) => {
      const container = {};
      container.Id = item.Id;
      container.Name = item.Name;
      container.Correct__c = item.Correct__c;
      container.Incorrect__c = item.Incorrect__c;
      container.Prompted__c = item.Prompted__c;
      container.SD__c = item.SD__c;
      container.Program__c = item.Program__c;
      container.Comment__c = item.Comment__c;
      container.Previous_Status__c = item.Previous_Status__c;
      return container;
    });

    if (_selectedRows) {
      this.logit(
        DEBUG,
        `handleClickArray(): calling setSessionObjectivesByArray `,
        `handleClickArray()`,
        this.recordId
      );

      this.logit(
        FINE,
        `handleClickArray(): jsonstr=${JSON.stringify(
          _selectedRows
        )} val=${mode}`,
        `handleClickArray()`,
        this.recordId
      );
      console.log(`==============> ${JSON.stringify(_selectedRows)}`);
      setSessionObjectivesByArray({
        jsonstr: JSON.stringify(_selectedRows),
        val: mode
      })
        .then((result) => {
          this.recordsProcessed = result;

          this.logit(
            FINE,
            `handleClickArray(): result=${JSON.stringify(result)} val=${mode}`,
            `handleClickArray()`,
            this.recordId
          );
        })
        .then(() => {
          this.logit(
            DEBUG,
            `handleClickArray(): refreshing`,
            `handleClickArray()`,
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
              `Marked ${this.recordsProcessed} record(s) as ${mode}.`,
              "success"
            );
          }
        })
        .catch((error) => {
          this.error = error;
          this.logit(
            ERROR,
            `handleClickArray(): error ${JSON.stringify(error)}`,
            `handleClickArray()`,
            this.recordId
          );
        });
    }
  }

  handleClickDelete(event) {
    this.logit(
      DEBUG,
      `handleClickDelete(): in handleClickDelete`,
      `handleClickDelete()`,
      this.recordId
    );

    this.logit(
      DEBUG,
      `handleClickDelete(): calling deleteSessionObjectives`,
      `handleClickDelete()`,
      this.recordId
    );
    deleteSessionObjectives({ sessionid: this.recordId })
      .then((result) => {
        this.logit(
          FINE,
          `handleClickDelete(): Apex:deleteSessionObjectives returned ${result}`,
          `handleClickDelete()`,
          this.recordId
        );
      })
      .then(() => {
        this.logit(
          DEBUG,
          `handleClickDelete(): refreshing`,
          `handleClickDelete()`,
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
          `handleClickDelete()`,
          this.recordId
        );
      });
  }
  getSelectedName(event) {
    this.logit(
      DEBUG,
      `getSelectedName(): in getSelectedName`,
      `getSelectedName()`,
      this.recordId
    );

    this.selectedRows = event.detail.selectedRows;

    this.logit(
      FINE,
      `getSelectedName(): this.selectedRows=${JSON.stringify(
        this.selectedRows
      )}`,
      `getSelectedName()`,
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

  handleCancel(event) {
    console.info(`%chandleCancel(): entering`, COLOR);
    console.log(JSON.stringify(this.columns));
    this.areDetailsVisible = false;
  }
  handleClose(event) {
    this.areDetailsVisible = false;
    //experimental
    this.refresh();
  }
}
