import { LightningElement, api, wire, track } from "lwc";
import getUnusedObjectives from "@salesforce/apex/L4LController.getUnusedObjectives";
import getUnusedObjectivesBySearch from "@salesforce/apex/L4LController.getUnusedObjectivesBySearch";

import createClientObjectivesByArray from "@salesforce/apex/L4LController.createClientObjectivesByArray";
import getPopularObjectives from "@salesforce/apex/L4LController.getPopularObjectives";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
//import { fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
//import { refreshApex } from "@salesforce/apex";
// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LMessageChannel__c";
import EmailPreferencesStayInTouchReminder from "@salesforce/schema/User.EmailPreferencesStayInTouchReminder";

//debugging
const COMPONENT = "l4lCreateClientObjectives";
const COLOR = "color:green"; //for console log formatting
const DEBUG = "debug";
const FINE = "fine";
const INFO = "info";
const ERROR = "error";

const columns = [
  { label: "Program", fieldName: "Program__c", type: "text" },
  { label: "SD", fieldName: "SD_Name__c", type: "text" },
  { label: "Objective", fieldName: "Name", type: "text" }
];

//const selectedRows = {};

export default class L4lCreateClientObjectives extends LightningElement {
  @wire(MessageContext) messageContext;
  @api recordId = "0012v00002fY86nAAC"; //Andy

  @wire(CurrentPageReference) pageRef;
  @track allObjectives = {};
  @wire(getUnusedObjectives, { clientId: "$recordId" }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  rendered = false;
  isLoading = false;
  popular = true;
  //@track objectives;
  connectedCallback() {
    this.popular = true;
    this.getPopularObjs();
  }

  get resultmessage() {
    if (this.popular) {
      return this.objectives.length > 0
        ? `Showing Popular Records: ${this.objectives.length} records returned.`
        : "";
    } else {
      return this.objectives.length > 0
        ? `Search returned ${this.objectives.length} records.`
        : "";
    }
  }
  logit(level, message, tag, context = null) {
    this.isLoading = true;
    let _level = `${level}`;
    let _message = `${COMPONENT}.${message}`;
    let _tag = `${COMPONENT}.${tag}`;
    let _context = `${context}`;

    console.log(`in logger level=${_level} tag=${_tag} context=${_context}`);
    let logger = this.template.querySelector("c-logger");
    logger.setScenario(`c/${COMPONENT}`);
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
    this.isLoading = false;
  }

  refresh() {
    this.isLoading = true;
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(
      `%crefresh(): calling Apex getUnusedObjectivesBySearch`,
      COLOR
    );
    console.debug(`%crefresh(): parameter clientId=${this.recordId}`, COLOR);
    console.debug(
      `%crefresh(): parameter searchValue=${this.searchValue}`,
      COLOR
    );

    getUnusedObjectivesBySearch({
      clientId: this.recordId,
      searchstring: this.searchValue
    })
      .then((result) => {
        this.objectives = result;
        this.allObjectives = result;
        this.logit(
          DEBUG,
          `refresh(): getUnusedObjectivesBySearch ${result.length} records returned`,
          `refresh()`,
          this.recordId
        );
        this.logit(
          FINE,
          `refresh(): getUnusedObjectivesBySearch result=${JSON.stringify(
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
          `refresh(): getUnusedObjectivesBySearch errored: ${JSON.stringify(
            error
          )} results`,
          `refresh()`,
          this.recordId
        );
      });
    this.isLoading = false;
  }

  handleRefreshPopular(event) {
    this.getPopularObjs();
  }

  getSelectedName(event) {
    this.logit(
      DEBUG,
      `getSelectedName(): entering method`,
      `getSelectedName()`,
      this.recordId
    );
    this.selectedRows = event.detail.selectedRows;
    this.logit(
      FINE,
      `getSelectedName(): this.selectedRows=${JSON.stringify(
        this.selectedRows
      )} `,
      `getSelectedName()`,
      this.recordId
    );
  }

  handleClickArray(event) {
    this.logit(
      DEBUG,
      `handleClickArray(): entering method`,
      `handleClickArray()`,
      this.recordId
    );
    if (this.selectedRows) {
      this.logit(
        DEBUG,
        `handleClickArray(): selectedRows==true`,
        `handleClickArray()`,
        this.recordId
      );
      this.logit(
        FINE,
        `handleClickArray(): jsonstr=selectedRows=${JSON.stringify(
          this.selectedRows
        )}, sess=${this.recordId}`,
        `handleClickArray()`,
        this.recordId
      );
      this.logit(
        DEBUG,
        `handleClickArray(): imperative Call to createClientObjectivesByArray`,
        `handleClickArray()`,
        this.recordId
      );

      createClientObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId
      })
        .then((result) => {
          this.recordsProcessed = result;

          this.logit(
            DEBUG,
            `handleClickArray(): Apex createClientObjectivesByArray result=${result}`,
            `handleClickArray()`,
            this.recordId
          );
        })
        .then(() => {
          console.debug(`????????? what does this .then do ???`, COLOR);
        })
        .then(() => {
          this.showNotification(
            "Success",
            `${this.recordsProcessed} records processed.`,
            "success"
          );
          this.logit(
            FINE,
            `handleClickArray():setting this.objectives=null, calling refresh() `,
            `handleClickArray()`,
            this.recordId
          );
          let inp = this.template.querySelector("input");
          inp.value = "";
          if (this.popular) {
            this.getPopularObjs();
          } else {
            this.refresh();
          }
        })
        .finally(() => {
          this.logit(
            DEBUG,
            `handleClickArray():publishing LMS event`,
            `handleClickArray()`,
            this.recordId
          );
          const message = {
            recordId: "",
            message: "message from l4lCreateClientObjectives",
            source: "LWC",
            recordData: {}
          };
          this.logit(
            FINE,
            `handleClickArray(): Sending message via L4LMC, message=${JSON.stringify(
              message
            )}`,
            `handleClickArray()`,
            this.recordId
          );
          publish(this.messageContext, L4LMC, message);
          this.logit(
            DEBUG,
            `handleClickArray(): published ${JSON.stringify(message)} to L4LMC`,
            `handleClickArray()`
          );
        })
        .catch((error) => {
          this.error = error;
          this.logit(
            ERROR,
            `handleClickArray(): Error ${JSON.stringify(error)}`,
            `handleClickArray()`,
            this.recordId
          );
        });
    }
  }

  handleFilterKeyInput(event) {
    this.logit(
      DEBUG,
      `handleFilteKeyInput(): entering method`,
      `handleFilteKeyInput()`
    );
    const filterKey = event.target.value.toLowerCase();
    this.logit(
      FINE,
      `handleFilteKeyInput(): filterKey=${filterKey}`,
      `handleFilteKeyInput()`
    );

    this.objectives = this.allObjectives.filter(
      (so) =>
        so.Name.toLowerCase().includes(filterKey) ||
        so.Program__c.toLowerCase().includes(filterKey) ||
        so.SD_Name__c.toLowerCase().includes(filterKey)
    );
    this.logit(
      FINE,
      `handleFilterKey(): this.objectives=${JSON.stringify(this.objectives)}`,
      `handleFilterKey()`
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

  handleClickCancel(event) {
    this.logit(
      FINE,
      `handleClickCancel(): dispatching CustomEvent(close)`,
      `handleClickCancel()`
    );
    this.dispatchEvent(new CustomEvent("close"));
  }

  searchKeyword(event) {
    this.searchValue = event.target.value;
  }

  handleSearchKeyword() {
    this.isLoading = true;
    this.logit(
      DEBUG,
      `handleSearchKeyword(): entering, searchValue=${this.searchValue}`,
      `handleSearchKeyword()`
    );
    if (this.searchValue !== "") {
      this.logit(
        DEBUG,
        `handleSearchKeyword(): calling getUnusedbjectivesBySearch`,
        `handleSearchKeyword()`
      );
      this.popular = false;
      getUnusedObjectivesBySearch({
        clientId: this.recordId,
        searchstring: this.searchValue
      })
        .then((result) => {
          // set @track contacts variable with return contact list from server
          this.logit(
            FINE,
            `handleSearchKeyword(): result=${JSON.stringify(result)}`,
            `handleSearchKeyword()`
          );
          this.objectives = result;
          this.allObjectives = result;
        })
        .catch((error) => {
          const event = new ShowToastEvent({
            title: "Error",
            variant: "error",
            message: error.body.message
          });
          this.dispatchEvent(event);
          // reset contacts var with null
        });
    } else {
      // fire toast event if input field is blank
      const event = new ShowToastEvent({
        variant: "error",
        message: "Search text missing.."
      });
      this.dispatchEvent(event);
    }
    this.isLoading = false;
  }

  getPopularObjs() {
    this.isLoading = true;
    this.searchValue = "";
    this.popular = true;
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(
      `%cgetPopularObjs(): calling Apex getPopularObjectives`,
      COLOR
    );

    getPopularObjectives({
      clientId: this.recordId
    })
      .then((result) => {
        this.objectives = result;
        this.allObjectives = result;
        this.logit(
          DEBUG,
          `getPopularObjs(): getPopularObjectives ${result.length} records returned`,
          `getPopularObjs()`,
          this.recordId
        );
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `getPopularObjs(): getPopularObjectives errored: ${JSON.stringify(
            error
          )} results`,
          `refresh()`,
          this.recordId
        );
      });
    this.isLoading = false;
  }
}
