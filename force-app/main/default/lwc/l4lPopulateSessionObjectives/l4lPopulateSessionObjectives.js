/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getClientObjectivesForSession from "@salesforce/apex/L4LController.getClientObjectivesForSession";
import createSessionObjectivesByArrayWithOrderedResults from "@salesforce/apex/L4LController.createSessionObjectivesByArrayWithOrderedResults";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";

// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LSessionMessageChannel__c";

const COMPONENT = "l4lPopulatecSessionObjectives";
const COLOR = "color:olive"; //for console log formatting
const DEBUG = "debug";
const INFO = "info";
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
    type: "text"
  },
  {
    label: "Re-Test Due",
    fieldName: "Re_Test_Recommended__c",
    type: "boolean"
  }
];

export default class L4lPopulateSessionObjectives extends LightningElement {
  @wire(CurrentPageReference) pageRef;
  @wire(MessageContext) messageContext;
  @api recordId = "a3N2v000003Gr4VEAS"; //session 31 for testing
  @track filterableObjectives = {};
  //@wire(getObjectives, { sess: '$recordId' }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  @track objectives;

  @track correctCount = 0;
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
    if (!this.rendered) {
      this.logit(
        INFO,
        "renderedCallback(): ignore  - confirming logging",
        `${COMPONENT}.renderedCallback()`,
        this.recordId
      );
      this.logit(
        DEBUG,
        "renderedCallback():  ignore - confirming logging",
        `${COMPONENT}.renderedCallback()`,
        this.recordId
      );
      this.logit(
        ERROR,
        "renderedCallback(): ignore  - confirming logging",
        `${COMPONENT}.renderedCallback()`,
        this.recordId
      );
      this.rendered = true;
    }
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
    console.debug(`%crefresh(): calling getClientObjectivesForSession`, COLOR);

    getClientObjectivesForSession({
      searchKey: this.recordId
    })
      .then((result) => {
        this.objectives = result;
        this.logit(
          INFO,
          `refresh(): getClientObjectivesForSession returned ${this.objectives.length} results`,
          `${COMPONENT}.refresh()`,
          this.recordId
        );
        this.logit(
          DEBUG,
          `refresh(): getClientObjectivesForSession result= ${JSON.stringify(
            result
          )}`,
          `${COMPONENT}.refresh()`,
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
          `${COMPONENT}.refresh()`,
          this.recordId
        );
      });
  }

  getSelectedName(event) {
    this.logit(
      INFO,
      `getSelectedName(): entering method`,
      `${COMPONENT}.getSelectedName()`,
      this.recordId
    );

    let myselectedRows = event.detail.selectedRows;

    this.logit(
      DEBUG,
      `getSelectedName(): myselectedRows=${JSON.stringify(myselectedRows)} `,
      `${COMPONENT}.getSelectedName()`,
      this.recordId
    );
    if (myselectedRows.length > 0) {
      this.breadcrumb =
        myselectedRows[0].Program_Name__c +
        " > " +
        myselectedRows[0].SD_Name__c +
        " > " +
        myselectedRows[0].Objective_Name__c;
      this.logit(
        DEBUG,
        `getSelectedName(): this.breadcrumb=${this.breadcrumb}
          )} `,
        `${COMPONENT}.getSelectedName()`,
        this.recordId
      );

      this.selectedRows = myselectedRows;

      this.logit(
        DEBUG,
        `getSelectedName(): this.selectedRows=myselectedrows=${JSON.stringify(
          this.selectedRows
        )}
        )} `,
        `${COMPONENT}.getSelectedName()`,
        this.recordId
      );

      this.selectCount = this.selectedRows.length;
    }
  }

  handleIncrCorrect(event) {
    this.logit(
      INFO,
      `handleIncrCorrect(): entering handleIncrCorrect() `,
      `${COMPONENT}.handleIncrCorrect()`,
      this.recordId
    );

    if (this.selectedRows) {
      this.results.push("C");
      this.skillstring.push({ skill: "C" });

      this.logit(
        DEBUG,
        `handleIncrCorrect(): this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `${COMPONENT}.handleIncrCorrect()`,
        this.recordId
      );
      this.correctCount += 1;
    }
  }

  resetCounters() {
    this.correctCount = 0;
    this.incorrectCount = 0;
    this.promptedCount = 0;
    this.results = [];
    this.skillstring = [];
    //this.breadcrumb = "";
  }

  handleIncrIncorrect(event) {
    this.logit(
      INFO,
      `handleIncrCorrect(): entering handleIncrIncorrect() `,
      `${COMPONENT}.handleIncrIncorrect()`,
      this.recordId
    );

    if (this.selectedRows) {
      this.results.push("I");
      this.skillstring.push({ skill: "I" });

      this.logit(
        DEBUG,
        `handleIncrIncorrect(): this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `${COMPONENT}.handleIncrIncorrect()`,
        this.recordId
      );

      this.incorrectCount += 1;
    }
  }

  handleIncrPrompted(event) {
    this.logit(
      INFO,
      `handleIncrPrompted(): entering handleIncrPrompted() `,
      `${COMPONENT}.handleIncrPromnpted()`,
      this.recordId
    );

    if (this.selectedRows) {
      this.results.push("P");
      this.skillstring.push({ skill: "P" });

      this.logit(
        DEBUG,
        `handleIncrPrompted(): this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `${COMPONENT}.handleIncrPrompted()`,
        this.recordId
      );
      this.promptedCount += 1;
    }
  }

  // get sumOfCounts(){
  //     //parseInt Converts a string to an integer.
  //         return (parseInt(this.correctCount)+parseInt(this.incorrectCount)+parseInt(this.promptedCount))*this.selectCount;
  // }

  get buttonDisabled() {
    return (
      parseInt(this.correctCount) +
        parseInt(this.incorrectCount) +
        parseInt(this.promptedCount) ==
      0
    );
  }

  handleClickArray(event) {
    this.logit(
      INFO,
      `handleClickArray(): entering method`,
      `${COMPONENT}.handleClickArray()`,
      this.recordId
    );

    if (this.selectedRows) {
      this.logit(
        INFO,
        `handleClickArray(): selectedRows==true`,
        `${COMPONENT}.handleClickArray()`,
        this.recordId
      );
      this.logit(
        DEBUG,
        `handleClickArray(): jsonstr=selectedRows=${JSON.stringify(
          this.selectedRows
        )}, sess=${this.recordId}`,
        `${COMPONENT}.handleClickArray()`,
        this.recordId
      );
      this.logit(
        INFO,
        `handleClickArray(): imperative Call to createSessionObjectivesByArrayWithOrderedResults()`,
        `${COMPONENT}.handleClickArray()`,
        this.recordId
      );

      createSessionObjectivesByArrayWithOrderedResults({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId,
        skillstring: JSON.stringify(this.skillstring)
      })
        .then((result) => {
          this.recordsProcessed = result;
          this.logit(
            INFO,
            `handleClickArray(): Apex createClientObjectivesByArray result=${result}`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
        })
        .then(() => {
          console.debug(
            `%chandleClickArray(): this is an empty then ?????`,
            COLOR
          );
        })
        .then(() => {
          this.showNotification(
            "Success",
            `${this.recordsProcessed} records processed.`,
            "success"
          );
          this.sessionresults.push(
            this.breadcrumb + " : " + this.results.toString()
          );
          this.logit(
            DEBUG,
            `handleClickArray():reset counters, set this.selectCount=0 `,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
          this.resetCounters();
          this.selectCount = 0;
        })
        .finally(() => {
          const message = {
            recordId: "",
            message: "message from l4lPopulateSessionObjectives",
            source: "LWC",
            recordData: {}
          };
          this.logit(
            INFO,
            `handleClickArray():publishing LMS event`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
          this.logit(
            DEBUG,
            `handleClickArray(): Sending message via L4LMC, message=${JSON.stringify(
              message
            )}`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
          publish(this.messageContext, L4LMC, message);
          this.logit(
            DEBUG,
            `handleClickArray(): published ${JSON.stringify(message)} to L4LMC`,
            `${COMPONENT}.handleClickArray()`
          );
        })
        .catch((error) => {
          this.error = error;
          this.logit(
            ERROR,
            `handleClickArray(): Error ${JSON.stringify(error)}`,
            `${COMPONENT}.handleClickArray()`,
            this.recordId
          );
        });
    }
  }

  handleSearchKeyInput(event) {
    this.logit(
      INFO,
      `handleSearchKey(): entering method`,
      `${COMPONENT}.handleSearchKey()`
    );
    const searchKey = event.target.value.toLowerCase();

    this.logit(
      DEBUG,
      `handleSearchKey(): searchKey=${searchKey}`,
      `${COMPONENT}.handleSearchKey()`
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
      DEBUG,
      `handleSearchKey(): this.objectives=${JSON.stringify(this.objectives)}`,
      `${COMPONENT}.handleSearchKey()`
    );
  }

  showNotification(t, m, v) {
    this.logit(
      DEBUG,
      `showNotification(): entering method, t=${t}, m=${m}, v=${v}`,
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
      `dispatching CustomEvent(close)`,
      `${COMPONENT}.handleClickCancel()`
    );
    this.dispatchEvent(new CustomEvent("close"));
  }
}
