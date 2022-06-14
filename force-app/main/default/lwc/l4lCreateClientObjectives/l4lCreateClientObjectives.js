import { LightningElement, api, wire, track } from "lwc";
import getUnusedObjectives from "@salesforce/apex/L4LController.getUnusedObjectives";
import createClientObjectivesByArray from "@salesforce/apex/L4LController.createClientObjectivesByArray";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
//import { fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";
//import { refreshApex } from "@salesforce/apex";
// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LMessageChannel__c";

//debugging
const COMPONENT = "l4lCreateClientObjectives";
const COLOR = "color:green"; //for console log formatting
const DEBUG = "debug";
const INFO = "info";
const ERROR = "error";

const columns = [
  { label: "Name", fieldName: "Name", type: "text" },
  { label: "Program", fieldName: "Program__c", type: "text" },
  { label: "SD_Name__c", fieldName: "SD_Name__c", type: "text" }
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
  //@track objectives;

  connectedCallback() {
    console.info(
      `%cconnectedCallback(): Starting, getting objectives, recordId = ${this.recordId}`,
      COLOR
    );
    console.info(`%cconnectedCallback(): calling refresh()`, COLOR);

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
    console.debug(`%crefresh(): calling Apex getUnusedObjectives`, COLOR);
    console.debug(`%crefresh(): parameter clientId=${this.recordId}`, COLOR);
    getUnusedObjectives({ clientId: this.recordId })
      .then((result) => {
        this.objectives = result;
        this.allObjectives = result;
        this.logit(
          INFO,
          `${COMPONENT}.refresh(): getUnusedObjectives ${result.length} records returned`,
          `${COMPONENT}.refresh()`,
          this.recordId
        );
        this.logit(
          DEBUG,
          `${COMPONENT}.refresh(): getUnusedObjectives result=${JSON.stringify(
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
          `${COMPONENT}.refresh(): getUnusedObjectives errored: ${JSON.stringify(
            error
          )} results`,
          `${COMPONENT}.refresh()`,
          this.recordId
        );
      });
  }

  getSelectedName(event) {
    this.logit(
      INFO,
      `${COMPONENT}.getSelectedName(): entering method`,
      `${COMPONENT}.getSelectedName()`,
      this.recordId
    );
    this.selectedRows = event.detail.selectedRows;
    this.logit(
      DEBUG,
      `${COMPONENT}.getSelectedName(): this.selectedRows=${JSON.stringify(
        this.selectedRows
      )} `,
      `${COMPONENT}.getSelectedName()`,
      this.recordId
    );
  }

  handleClickArray(event) {
    this.logit(
      INFO,
      `${COMPONENT}.handleClickArray(): entering method`,
      `${COMPONENT}.handleClickArray()`,
      this.recordId
    );
    if (this.selectedRows) {
      this.logit(
        INFO,
        `${COMPONENT}.handleClickArray(): selectedRows==true`,
        `${COMPONENT}.handleClickArray()`,
        this.recordId
      );
      this.logit(
        DEBUG,
        `${COMPONENT}.handleClickArray(): jsonstr=selectedRows=${JSON.stringify(
          this.selectedRows
        )}, sess=${this.recordId}`,
        `${COMPONENT}.handleClickArray()`,
        this.recordId
      );
      this.logit(
        INFO,
        `${COMPONENT}.handleClickArray(): imperative Call to createClientObjectivesByArray`,
        `${COMPONENT}.handleClickArray()`,
        this.recordId
      );

      createClientObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId
      })
        .then((result) => {
          this.recordsProcessed = result;
          this.logit(
            INFO,
            `${COMPONENT}.handleClickArray(): Apex createClientObjectivesByArray result=${result}`,
            `${COMPONENT}.handleClickArray()`,
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
            DEBUG,
            `${COMPONENT}.handleClickArray():setting this.objectives=null, calling refresh() `,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
          this.objectives = [];
          this.refresh();
        })
        .finally(() => {
          this.logit(
            INFO,
            `${COMPONENT}.handleClickArray():publishing LMS event`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
          const message = {
            recordId: "",
            message: "message from l4lCreateClientObjectives",
            source: "LWC",
            recordData: {}
          };
          this.logit(
            DEBUG,
            `${COMPONENT}.handleClickArray(): Sending message via L4LMC, message=${JSON.stringify(
              message
            )}`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
          publish(this.messageContext, L4LMC, message);
          this.logit(
            INFO,
            `${COMPONENT}.handleClickArray(): published ${JSON.stringify(
              message
            )} to L4LMC`,
            `${COMPONENT}.handleClickArray()`
          );
        })
        .catch((error) => {
          this.error = error;
          this.logit(
            ERROR,
            `${COMPONENT}.handleClickArray(): Error ${JSON.stringify(error)}`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
        });
    }
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

    this.objectives = this.allObjectives.filter(
      (so) =>
        so.Name.toLowerCase().includes(searchKey) ||
        so.Program__c.toLowerCase().includes(searchKey) ||
        so.SD_Name__c.toLowerCase().includes(searchKey)
    );
    this.logit(
      DEBUG,
      `${COMPONENT}.handleSearchKey(): this.objectives=${JSON.stringify(
        this.objectives
      )}`,
      `${COMPONENT}.handleSearchKey()`
    );
  }

  showNotification(t, m, v) {
    this.logit(
      DEBUG,
      `${COMPONENT}.showNotification(): entering method, t=${t}, m=${m}, v=${v}`,
      `${COMPONENT}.showNotification()`
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
      DEBUG,
      `${COMPONENT}.handleClickCancel(): dispatching CustomEvent(close)`,
      `${COMPONENT}.handleClickCancel()`
    );
    this.dispatchEvent(new CustomEvent("close"));
  }
}
