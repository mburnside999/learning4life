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
import getSessionBOC from "@salesforce/apex/L4LController.getSessionBOC";
import setSessionBOCByArray from "@salesforce/apex/L4LController.setSessionBOCByArray";
import createSessionBOC from "@salesforce/apex/L4LController.createSessionBOC";

//import deleteSessionObjectives from "@salesforce/apex/L4LController.deleteSessionObjectives";

// The Lightning Message service
import {
  subscribe,
  APPLICATION_SCOPE,
  MessageContext
} from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LSessionMessageChannel__c";

const TAG = "L4L-Manage-Session-BOC";
const SCENARIO = "Manage Session BOC for a client - LWC";
const UI_EVENT_TRACKING_SCENARIO = "l4lGetSetSessionBOC LWC UI Event Tracking";
const APEX_EVENT_TRACKING_SCENARIO =
  "l4lGetSetSessionBOC LWC APEX Event Tracking";
//debugging
const COMPONENT = "LWC: l4lGetSetSessionBOC";
const COLOR = "color:blue"; //for console log formatting

//experimental comment editing
import COMMENT_FIELD from "@salesforce/schema/Session_BOC__c.Comments__c";

//fields for display
// const actions = [
//   { label: "Clone", name: "clone" }
//   //{ label: "Details", name: "detail" }
// ];
import SESSION_STATUS_FIELD from "@salesforce/schema/Session__c.Status__c";
const SESSIONFIELDS = [SESSION_STATUS_FIELD];
//columns when the session is open
const columns = [
  { label: "SBOC", fieldName: "Name", type: "text", initialWidth: 150 },
  // {
  //   label: "Client_BOC__c",
  //   fieldName: "Client_BOC__c",
  //   type: "text",
  //   initialWidth: 200,
  //   editable: false
  // },

  {
    label: "Behaviour",
    fieldName: "Behaviour__c",
    type: "text",
    initialWidth: 200,
    editable: false
  },
  {
    label: "Action",
    type: "button",
    initialWidth: 100,
    typeAttributes: {
      label: "Copy",
      name: "Add",
      title: "Add",
      disabled: false,
      value: "edit",
      iconPosition: "left"
    }
  },
  {
    label: "Time (HH24:MI)",
    fieldName: "Time__c",
    type: "text",
    initialWidth: 160,
    editable: true
  },
  {
    label: "Duration (Mins)",
    fieldName: "Duration_Mins__c",
    type: "number",
    initialWidth: 160,
    max: "60",
    min: "0",
    editable: true
  },
  {
    label: "Intensity (0-5)",
    fieldName: "Intensity__c",
    type: "number",
    initialWidth: 160,
    max: "5",
    min: "1",
    editable: true
  },
  {
    label: "Occurences",
    fieldName: "Occurrences__c",
    type: "number",
    initialWidth: 160,
    max: 10,
    min: 0,
    editable: true
  },
  {
    label: "Comments",
    fieldName: "Comments__c",
    type: "text",
    initialWidth: 500,
    wrapText: true,
    editable: true
  }

  //{
  // label: "Comments",
  // type: "button-icon",
  // initialWidth: 300,
  // wrapText: true,
  // typeAttributes: {
  //   iconName: { fieldName: "rowIcon" },
  //   name: "detail",
  //   variant: "border-filled",
  //   value: "detail"
  // }
  // }
];
//columns when the session is locked
const lockedcolumns = [
  { label: "SBOC", fieldName: "Name", type: "text", initialWidth: 150 },
  // {
  //   label: "Client_BOC__c",
  //   fieldName: "Client_BOC__c",
  //   type: "text",
  //   initialWidth: 200,
  //   editable: false
  // },
  {
    label: "Behaviour",
    fieldName: "Behaviour__c",
    type: "text",
    initialWidth: 200,
    editable: false
  },
  {
    label: "Time (HH24:MI)",
    fieldName: "Time__c",
    type: "text",
    initialWidth: 160,
    editable: false
  },
  {
    label: "Duration (Mins)",
    fieldName: "Duration_Mins__c",
    type: "number",
    initialWidth: 160,
    editable: false
  },
  {
    label: "Intensity (0-5)",
    fieldName: "Intensity__c",
    type: "number",
    initialWidth: 160,
    editable: false
  },
  {
    label: "Occurences",
    fieldName: "Occurrences__c",
    type: "number",
    initialWidth: 180,
    editable: false
  },
  {
    label: "Comments",
    fieldName: "Comments__c",
    initialWidth: 500,
    type: "text",
    wrapText: true,
    editable: false
  }
];

export default class L4lGetSetSessionBOC extends LightningElement {
  // session_obj__c for modal
  SOobjectApiName = "Session_BOC__c";
  //get the session (status)
  @wire(getRecord, { recordId: "$recordId", fields: SESSIONFIELDS }) session;
  //track the session objective for the modal
  @track sessionBOCId;
  @track areDetailsVisible = false;
  @api lwcTitle = "Session Behaviours of Concern";
  @api recordId = "a3N2v000003Gr4VEAS"; //this is session 31
  @track sessionboc;
  @track isLocked = false;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  @wire(CurrentPageReference) pageRef;
  @track draftValues = [];
  @track allboc = {};
  saveDraftValues;
  @api testSessionStatus;
  @api sessionStatus;
  //experimental comment editing
  fields = [COMMENT_FIELD];
  // messaging
  @wire(MessageContext) messageContext;
  subscription = null;

  errors = {};

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

        logInfo(
          this.recordId,
          `${COMPONENT}: connectedCallback()`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: @wire lightning/uiRecordApi/getRecord`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

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
    console.debug(`%crefresh(): calling APEX getSessionBOC`, COLOR);

    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling Apex getSessionBOC`,
      `${SCENARIO}`,
      `${TAG}`
    );
    getSessionBOC({ sess: this.recordId })
      .then((result) => {
        this.sessionboc = result.map((row) => ({
          ...row,
          rowIcon:
            row.Comments__c != null ? "utility:quick_text" : "utility:add"
        }));

        console.log(`this.sessionboc=${JSON.stringify(this.sessionboc)}`);
        this.allboc = this.sessionboc;

        //this.sessionboc=result;
        //this.allboc = result;

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getSessionBOC returned ${result.length} records`,
          `${SCENARIO}`,
          `${TAG}`
        );

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getSessionBOC returned result: ${JSON.stringify(
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
          `${COMPONENT}.refresh(): Apex getSessionBOC error=${JSON.stringify(
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

    this.sessionboc = this.allboc.filter(
      (so) =>
        so.Name.toLowerCase().includes(searchKey) ||
        (!(so.Comments__c === undefined) &&
          so.Comments__c.toLowerCase().includes(searchKey)) ||
        (!(so.Behaviour__c === undefined) &&
          so.Behaviour__c.toLowerCase().includes(searchKey))
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
    console.log("row action==> event=" + JSON.stringify(event));
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
        logInfo(
          this.recordId,
          `${COMPONENT}: Apex Call: lightning/uiRecordApi/deleteRecord`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        deleteRecord(row.Id)
          .then(() => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Session BOC deleted",
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
        logInfo(
          this.recordId,
          `${COMPONENT}: RowAction: Add Comment`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        logDebug(
          this.recordId,
          `${COMPONENT}.handleRowAction() case:detail`,
          `${SCENARIO}`,
          `${TAG}`
        );
        this.areDetailsVisible = true;
        this.sessionBOCId = row.Id;
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
      case "Add":
        logDebug(
          this.recordId,
          `${COMPONENT}.handleRowAction() case:Add`,
          `${SCENARIO}`,
          `${TAG}`
        );

        createSessionBOC({
          clientBOCId: row.Client_BOC__c,
          sessionId: this.recordId,
          intensity: row.Intensity__c,
          mins: row.Duration_Mins__c,
          occurrences: row.Occurrences__c,
          sboctime: row.Time__c,
          comments: ""
        })
          .then(() => {
            this.dispatchEvent(
              new ShowToastEvent({
                title: "Success",
                message: "Session BOC created",
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
            console.log("ERROR!! " + JSON.stringify(error));
            logError(
              this.recordId,
              `${COMPONENT}.handleRowAction(): error=${JSON.stringify(error)}`,
              `${SCENARIO}`,
              `${TAG}`
            );

            this.dispatchEvent(
              new ShowToastEvent({
                title: "Error adding record",
                message: "Error",
                variant: "error"
              })
            );
          });

        console.debug("EDIT DETAILS");
        break;
      default:
    }
  }

  handleSave(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleSave(): saving the session BOC records`,
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

    this.saveDraftValues = event.detail.draftValues;
    var rowErrorMessages = [];
    var rowErrorFieldNames = [];
    var rowsError = {};
    this.errors = {};
    let valid = true;

    event.detail.draftValues.map((row) => {
      console.log("*****in the map, row = " + JSON.stringify(row));

      if ("Time__c" in row) {
        if (
          row.Time__c != "" &&
          !/^(?:[01][0-9]|2[0-3]):[0-5][0-9](?::[0-5][0-9])?$/.test(row.Time__c)
        ) {
          valid = false;
          rowErrorMessages.push(`Time must be in 24HH:MI format`);
          rowErrorFieldNames.push("Time__c");
        }
      }

      if (row.Intensity__c > 5 || row.Intensity__c < 0) {
        valid = false;
        rowErrorMessages.push(`Intensity must be between 0 and 5.`);
        rowErrorFieldNames.push("Intensity__c");
      }

      if (row.Duration_Mins__c > 90 || row.Duration_Mins__c < 0) {
        valid = false;
        rowErrorMessages.push(`Duration must be between 0 and 90.`);
        rowErrorFieldNames.push("Duration_Mins__c");
      }

      if (row.Occurrences__c > 20 || row.Occurrences__c < 0) {
        valid = false;
        rowErrorMessages.push(`Occurrences must be between 0 and 20.`);
        rowErrorFieldNames.push("Occurrences__c");
      }

      if (!valid) {
        rowsError[row.Id] = {
          messages: rowErrorMessages,
          fieldNames: rowErrorFieldNames,
          title: "Validation errors."
        };
        this.errors = { rows: rowsError };
      } else {
        //there are no validation errors in the row
        if (row.Id in rowsError) {
          console.log("row.id id in the rowsError, deleting");
          delete rowsError[row.Id]; // cleanup the error array
        }
      }
    });

    //only proceed if no validation errors
    if (valid) {
      const recordInputs = event.detail.draftValues.slice().map((draft) => {
        const fields = Object.assign({}, draft);
        return { fields };
      });

      logInfo(
        this.recordId,
        `${COMPONENT}: Apex Call: lightning/uiRecordApi/updateRecord`,
        `${APEX_EVENT_TRACKING_SCENARIO}`,
        `${TAG}`
      ); // adoption tracking
      const promises = recordInputs.map((recordInput) =>
        updateRecord(recordInput)
      );
      Promise.all(promises)
        .then((contacts) => {
          this.dispatchEvent(
            new ShowToastEvent({
              title: "Success",
              message: "Session BOC updated",
              variant: "success"
            })
          );
          // Clear all draft values
          this.draftValues = [];

          logDebug(
            this.recordId,
            `${COMPONENT}.handleSave(): session BOC saved, draft values cleared, refreshing session BOC list `,
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
            `Error: ${JSON.stringify(error)}`,
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
  }

  async confirmation(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.confirmation(): action chosen on session BOC datatable row`,
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
    logInfo(
      this.recordId,
      `${COMPONENT}: Datatable MultiRow Button:  ${label}`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): label=${label}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    let mode = "";

    switch (label) {
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
      container.Comments__c = item.Comments__c;

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
        `${COMPONENT}.handleClickArray(): calling Apex setSessionBOCByArray `,
        `${SCENARIO}`,
        `${TAG}`
      );

      console.log(`==============> ${JSON.stringify(_selectedRows)}`);
      setSessionBOCByArray({
        jsonstr: JSON.stringify(_selectedRows),
        val: mode
      })
        .then((result) => {
          this.recordsProcessed = result;
          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray(): Apex setSessionBOCByArray returned ${JSON.stringify(
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

    // deleteSessionObjectives({ sessionid: this.recordId })
    //   .then((result) => {
    //     logDebug(
    //       this.recordId,
    //       `${COMPONENT}.handleClickDelete(): Apex call deleteSessionObjectives returned result= ${JSON.stringify(
    //         result
    //       )}`,
    //       `${SCENARIO}`,
    //       `${TAG}`
    //     );
    //   })
    //   .then(() => {
    //     logDebug(
    //       this.recordId,
    //       `${COMPONENT}.handleClickDelete(): refreshing session objectives`,
    //       `${SCENARIO}`,
    //       `${TAG}`
    //     );
    //     this.refresh();
    //   })
    //   .then(() => {
    //     this.showNotification(
    //       "Success!",
    //       "Deleted all Session Objective records for this session.",
    //       "success"
    //     );
    //   })
    //   .catch((error) => {
    //     this.error = error;

    //     logError(
    //       this.recordId,
    //       `${COMPONENT}.handleClickDelete(): error=${JSON.stringify(error)}`,
    //       `${SCENARIO}`,
    //       `${TAG}`
    //     );
    //   });
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

  handleCellchange(event) {
    console.log("Handle cell change");
    // this.saveDraftValues = event.detail.draftValues;
    // var rowErrorMessages = [];
    // var rowErrorFieldNames = [];
    // var rowsError = {};
    // rowErrorMessages.push(
    //   "Enter a valid number. Intensity cannot be greater then 5."
    // );
    // rowErrorFieldNames.push("Intensity__c");

    // rowsError[this.saveDraftValues[0].Id] = {
    //   messages: rowErrorMessages,
    //   fieldNames: rowErrorFieldNames,
    //   title: "We found 1 error."
    // };
    // console.log("xxxxx" + this.saveDraftValues[0].Id);
    // console.log(JSON.stringify(rowsError));
    // if (this.saveDraftValues[0].Intensity__c > "5") {
    //   this.errors = {
    //     rows: rowsError
    //   };
    // } else {
    //   this.errors = {}; // when error should not show
    // }
  }
}
