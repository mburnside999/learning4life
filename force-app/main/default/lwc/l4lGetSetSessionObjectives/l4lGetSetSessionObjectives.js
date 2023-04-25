/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";
import { updateRecord, getRecord, getFieldValue } from "lightning/uiRecordApi";
import { deleteRecord } from "lightning/uiRecordApi";
import LightningConfirm from "lightning/confirm";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";

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

const TAG = "L4L-Manage-Session-Objectives";
const SCENARIO = "Manage Session Objectives for a client - LWC";

//debugging
const COMPONENT = "l4lGetSetSessionObjectives";
const COLOR = "color:blue"; //for console log formatting

//experimental comment editing
import COMMENT_FIELD from "@salesforce/schema/Session_Obj__c.Comment__c";

//fields for display
// const actions = [
//   { label: "Delete", name: "delete" },
//   { label: "Details", name: "detail" }
// ];
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

    console.debug(`%cconnectedCallback(): calling refresh()`, COLOR);
    console.log(
      `%cconnectedCallback() Status = ${JSON.stringify(this.session.data)}`
    );
    console.log(`id =  ${this.recordId}`);
    console.log(`this.session = ${JSON.stringify(this.session)}`);

    setNewSession()
      .then((returnVal) => {
        console.log("Successful");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, initializing seassion objective data`,
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
        this.refresh();
      })
      .catch((error) => {
        console.log("Error");
      });
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

  refresh() {
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(`%crefresh(): calling APEX getSessionObjectives`, COLOR);

    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling Apex getSessionObjectives`,
      `${SCENARIO}`,
      `${TAG}`
    );

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

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getSessionObjectives returned ${result.length} records`,
          `${SCENARIO}`,
          `${TAG}`
        );

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getSessionObjectives returned result: ${JSON.stringify(
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
          `${COMPONENT}.refresh(): Apex getSessionObjectives error=${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  handleSearchKeyInput(event) {
    const searchKey = event.target.value.toLowerCase();

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput(): searchKey=${searchKey}`,
      `${SCENARIO}`,
      `${TAG}`
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
  }

  handleLMS(message) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleLMS(): received message ${JSON.stringify(message)}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    this.receivedMessage = message
      ? JSON.stringify(message, null, "\t")
      : "no message payload";

    this.refresh();
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;

    logDebug(
      this.recordId,
      `${COMPONENT}.handleRowAction(): row=${JSON.stringify(
        row
      )}, actionName=${actionName}`,
      `${SCENARIO}`,
      `${TAG}`
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
            logDebug(
              this.recordId,
              `${COMPONENT}.handleRowAction()`,
              `${SCENARIO}`,
              `${TAG}`
            );
            this.refresh();
          })
          .catch((error) => {
            logError(
              this.recordId,
              `${COMPONENT}.handleRowAction(): error=${JSON.stringify(error)}`,
              `${SCENARIO}`,
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
      case "detail":
        logDebug(
          this.recordId,
          `${COMPONENT}.handleRowAction() case:detail`,
          `${SCENARIO}`,
          `${TAG}`
        );
        logDebug(
          row.Id, // the session objective row that the comment was added to
          `${COMPONENT}.handleRowAction() case:detail`,
          `${SCENARIO}`,
          `${TAG}`
        );
        this.areDetailsVisible = true;
        this.sessionObjectiveId = row.Id;
        break;
      case "edit_details":
        logDebug(
          this.recordId,
          `${COMPONENT}.handleRowAction() case:edit_detail`,
          `${SCENARIO}`,
          `${TAG}`
        );
        console.debug("EDIT DETAILS");
        break;
      default:
    }
  }

  handleSave(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSave(): saving the session objective records`,
      `${SCENARIO}`,
      `${TAG}`
    );

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

        logDebug(
          this.recordId,
          `${COMPONENT}.handleSave(): session objectives saved, draft values cleared, refreshing session objectives list `,
          `${SCENARIO}`,
          `${TAG}`
        );
        // Display fresh data in the datatable
        this.refresh();
      })
      .catch((error) => {
        //Handle error

        console.log(JSON.stringify(error));

        this.showNotification(
          "An error occurred in HandleSave",
          `Error: JSON.stringify(error)`,
          "error"
        );

        logError(
          this.recordId,
          `${COMPONENT}.handleSave(): error=${JSON.stringify(error)}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  async confirmation(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.confirmation(): action chosen on session objective datatable row`,
      `${SCENARIO}`,
      `${TAG}`
    );

    let _label = event.target.label;
    if (this.selectedRows.length > 0) {
      await LightningConfirm.open({
        message: `This operation will update or delete ${this.selectedRows.length} record(s). Are you sure?`,
        variant: "headerless",
        label: "this is the aria-label value"
        // setting theme would have no effect
      }).then((result) => {
        console.log(`result=${result}`);
        logDebug(
          this.recordId,
          `${COMPONENT}.confirmation(): result=${JSON.stringify(result)}`,
          `${SCENARIO}`,
          `${TAG}`
        );

        if (result) {
          logDebug(
            this.recordId,
            `${COMPONENT}.confirmation(): result=${result}, calling handleClickArray _label=${_label} `,
            `${SCENARIO}`,
            `${TAG}`
          );
          this.handleClickArray(_label);
        }
      });
    }
  }

  handleClickArray(label) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): label=${label}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    let mode = "";

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
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): mode=${mode} `,
      `${SCENARIO}`,
      `${TAG}`
    );

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
      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): jsonstr=${JSON.stringify(
          _selectedRows
        )} val=${mode}`,
        `${SCENARIO}`,
        `${TAG}`
      );

      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): calling Apex setSessionObjectivesByArray `,
        `${SCENARIO}`,
        `${TAG}`
      );

      console.log(`==============> ${JSON.stringify(_selectedRows)}`);
      setSessionObjectivesByArray({
        jsonstr: JSON.stringify(_selectedRows),
        val: mode
      })
        .then((result) => {
          this.recordsProcessed = result;
          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray(): Apex setSessionObjectivesByArray returned ${JSON.stringify(
              result
            )}`,
            `${SCENARIO}`,
            `${TAG}`
          );
        })
        .then(() => {
          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray(): refreshing session objectives`,
            `${SCENARIO}`,
            `${TAG}`
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
          console.log(JSON.stringify(error));

          //this.error = error;
          logError(
            this.recordId,
            `${COMPONENT}.handleClickArray error(): ${JSON.stringify(error)}`,
            `${SCENARIO}`,
            `${TAG}`
          );

          this.showNotification(
            "Error in handleclickArray!",
            "Error in handleclickArray!",
            "error"
          );
        });
    }
  }

  handleClickDelete(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickDelete(): calling deleteSessionObjectives`,
      `${SCENARIO}`,
      `${TAG}`
    );

    deleteSessionObjectives({ sessionid: this.recordId })
      .then((result) => {
        logDebug(
          this.recordId,
          `${COMPONENT}.handleClickDelete(): Apex call deleteSessionObjectives returned result= ${JSON.stringify(
            result
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .then(() => {
        logDebug(
          this.recordId,
          `${COMPONENT}.handleClickDelete(): refreshing session objectives`,
          `${SCENARIO}`,
          `${TAG}`
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

        logError(
          this.recordId,
          `${COMPONENT}.handleClickDelete(): error=${JSON.stringify(error)}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }
  getSelectedName(event) {
    this.selectedRows = event.detail.selectedRows;

    logDebug(
      this.recordId,
      `${COMPONENT}.getSelectedName() this.selectedRows=${JSON.stringify(
        this.selectedRows
      )}`,
      `${SCENARIO}`,
      `${TAG}`
    );
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
