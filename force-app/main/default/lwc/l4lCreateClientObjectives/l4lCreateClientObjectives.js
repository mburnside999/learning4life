import { LightningElement, api, wire, track } from "lwc";

import getUnusedObjectives from "@salesforce/apex/L4LController.getUnusedObjectives";
import getUnusedObjectivesBySearch from "@salesforce/apex/L4LController.getUnusedObjectivesBySearch";
import createClientObjectivesByArray from "@salesforce/apex/L4LController.createClientObjectivesByArray";
import getPopularObjectives from "@salesforce/apex/L4LController.getPopularObjectives";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";

// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LMessageChannel__c";

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

export default class L4lCreateClientObjectives extends LightningElement {
  @wire(MessageContext) messageContext;
  @api recordId = "0012v00002fY86nAAC"; //Andy
  @wire(CurrentPageReference) pageRef;
  @track allObjectives = {};
  @wire(getUnusedObjectives, { clientId: "$recordId" }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  isLoading = false;
  showPopular = true;

  connectedCallback() {
    this.getPopularClientObjectives();
  }

  //tailored result message on UI, depending on whether we are showing popular records or search results
  get resultmessage() {
    this.logit(
      DEBUG,
      `resultmessage(): entering getter method, this.objectives.length=${this.objectives.length}`,
      `resultmessage`,
      this.recordId
    );
    if (this.showPopular) {
      return this.objectives.length > 0
        ? `Showing a selection of POPULAR client objectives: ${this.objectives.length} records returned.`
        : "";
    } else {
      return this.objectives.length > 0
        ? `Search returned ${this.objectives.length} client objectives.`
        : "";
    }
  }
  //Nebula logging helper
  logit(level, message, tag, context = null) {
    this.isLoading = true;
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
          `refresh(): Apex getUnusedObjectivesBySearch returned ${result.length} records.`,
          `refresh()`,
          this.recordId
        );
        this.logit(
          FINE,
          `refresh(): Apex getUnusedObjectivesBySearch JSON result=${JSON.stringify(
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
          `refresh(): Apex getUnusedObjectivesBySearch errored: ${JSON.stringify(
            error
          )} results`,
          `refresh()`,
          this.recordId
        );
      });
    this.isLoading = false;
  }

  handleRefreshPopular(event) {
    this.logit(
      DEBUG,
      `handleRefreshPopular(): entering method, the Refresh Popular button was pressed`,
      `handleRefreshPopular`,
      this.recordId
    );
    this.getPopularClientObjectives();
  }

  getSelectedName(event) {
    this.logit(
      DEBUG,
      `getSelectedName(): entering method, bound to lightning-datatable onrowselection `,
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
      `handleClickArray(): entering method, bound to lightning-button Create Client Objectives`,
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
        `handleClickArray(): imperative Call to Apex createClientObjectivesByArray`,
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
            `handleClickArray(): Apex createClientObjectivesByArray this.recordsProcessed=${result}`,
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
          this.logit(
            DEBUG,
            `handleClickArray(): after adding client objective records, will now determine whether to show popular records or not`,
            `handleClickArray()`,
            this.recordId
          );
          this.logit(
            DEBUG,
            `handleClickArray(): this.showPopular=${this.showPopular}`,
            `handleClickArray()`,
            this.recordId
          );

          if (this.showPopular) {
            this.logit(
              DEBUG,
              `handleClickArray(): Yes, will show popular, calling this.getPopularClientObjectives() `,
              `handleClickArray()`,
              this.recordId
            );
            this.getPopularClientObjectives();
          } else {
            this.logit(
              DEBUG,
              `handleClickArray(): No, will not show popular, just calling this.refresh()`,
              `handleClickArray()`,
              this.recordId
            );
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
      `handleSearchKeyword(): entering, bound to Search lightning-button.onclick - searchValue=${this.searchValue}`,
      `handleSearchKeyword()`
    );
    if (this.searchValue !== "") {
      this.logit(
        DEBUG,
        `handleSearchKeyword(): calling getUnusedbjectivesBySearch`,
        `handleSearchKeyword()`
      );
      this.showPopular = false;
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

  getPopularClientObjectives() {
    this.isLoading = true;
    this.searchValue = "";
    this.showPopular = true;
    console.info(`%cgetPopularClientObjectives(): entering`, COLOR);
    console.debug(
      `%cgetPopularClientObjectives(): calling Apex getPopularObjectives`,
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
          `getPopularClientObjectives(): Apex getPopularObjectives ${result.length} records returned`,
          `getPopularClientObjectives()`,
          this.recordId
        );
      })
      .catch((error) => {
        this.error = error;
        this.logit(
          ERROR,
          `getPopularClientObjectives(): getPopularObjectives errored: ${JSON.stringify(
            error
          )} results`,
          `refresh()`,
          this.recordId
        );
      });
    this.isLoading = false;
  }
}
