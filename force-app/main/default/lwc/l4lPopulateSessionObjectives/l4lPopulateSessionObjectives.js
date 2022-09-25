/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getClientObjectivesForSession from "@salesforce/apex/L4LController.getClientObjectivesForSession";
import createSessionObjectivesByArrayWithOrderedResults from "@salesforce/apex/L4LController.createSessionObjectivesByArrayWithOrderedResults";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";

// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LSessionMessageChannel__c";

const COMPONENT = "l4lPopulateSessionObjectives";
const COLOR = "color:olive"; //for console log formatting
const DEBUG = "debug";
const INFO = "info";
const FINE = "fine";

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
  @track nonResponsiveCount = 0;
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
    // if (!this.rendered) {
    //   this.logit(
    //     DEBUG,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     FINE,
    //     "renderedCallback():  ignore - confirming logging",
    //     `renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     ERROR,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `renderedCallback()`,
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
          DEBUG,
          `refresh(): getClientObjectivesForSession returned ${this.objectives.length} results`,
          `refresh()`,
          this.recordId
        );
        this.logit(
          FINE,
          `refresh(): getClientObjectivesForSession result= ${JSON.stringify(
            result
          )}`,
          `refresh()`,
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
          `refresh()`,
          this.recordId
        );
      });
  }

  getSelectedName(event) {
    this.logit(
      DEBUG,
      `getSelectedName(): entering method`,
      `getSelectedName()`,
      this.recordId
    );

    let myselectedRows = event.detail.selectedRows;

    this.logit(
      FINE,
      `getSelectedName(): myselectedRows=${JSON.stringify(myselectedRows)} `,
      `getSelectedName()`,
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
        FINE,
        `getSelectedName(): this.breadcrumb=${this.breadcrumb}
          )} `,
        `getSelectedName()`,
        this.recordId
      );

      this.selectedRows = myselectedRows;

      this.logit(
        FINE,
        `getSelectedName(): this.selectedRows=myselectedrows=${JSON.stringify(
          this.selectedRows
        )}
        )} `,
        `getSelectedName()`,
        this.recordId
      );

      this.selectCount = this.selectedRows.length;
    }
  }

  handleIncrCorrect(event) {
    this.logit(
      DEBUG,
      `handleIncrCorrect(): entering handleIncrCorrect() `,
      `handleIncrCorrect()`,
      this.recordId
    );

    if (this.selectedRows) {
      this.results.push("C");
      this.skillstring.push({ skill: "C" });

      this.logit(
        FINE,
        `handleIncrCorrect(): this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `handleIncrCorrect()`,
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
      DEBUG,
      `handleIncrCorrect(): entering handleIncrIncorrect() `,
      `handleIncrIncorrect()`,
      this.recordId
    );

    if (this.selectedRows) {
      this.results.push("I");
      this.skillstring.push({ skill: "I" });

      this.logit(
        FINE,
        `handleIncrIncorrect(): this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `handleIncrIncorrect()`,
        this.recordId
      );

      this.incorrectCount += 1;
    }
  }

  handleIncrNonResponsive(event) {
    this.logit(
      DEBUG,
      `handleIncrNonResponsive(): entering handleIncrNonResponsive() `,
      `handleIncrNonResponsive()`,
      this.recordId
    );

    if (this.selectedRows) {
      this.results.push("N");
      this.skillstring.push({ skill: "N" });

      this.logit(
        FINE,
        `handleIncrNonResponsive(): this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `handleIncrNonResponsive()`,
        this.recordId
      );

      this.nonResponsiveCount += 1;
    }
  }

  handleIncrPrompted(event) {
    this.logit(
      DEBUG,
      `handleIncrPrompted(): entering handleIncrPrompted() `,
      `handleIncrPromnpted()`,
      this.recordId
    );

    if (this.selectedRows) {
      this.results.push("P");
      this.skillstring.push({ skill: "P" });

      this.logit(
        FINE,
        `handleIncrPrompted(): this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `handleIncrPrompted()`,
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
        parseInt(this.nonResponsiveCount) +
        parseInt(this.incorrectCount) +
        parseInt(this.promptedCount) ==
      0
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
        `handleClickArray(): imperative Call to createSessionObjectivesByArrayWithOrderedResults()`,
        `handleClickArray()`,
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
            DEBUG,
            `handleClickArray(): Apex createClientObjectivesByArray result=${result}`,
            `handleClickArray()`,
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
            FINE,
            `handleClickArray():reset counters, set this.selectCount=0 `,
            `handleClickArray()`,
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
            DEBUG,
            `handleClickArray():publishing LMS event`,
            `handleClickArray()`,
            this.recordId
          );
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
            FINE,
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

  handleSearchKeyInput(event) {
    this.logit(
      DEBUG,
      `handleSearchKey(): entering method`,
      `handleSearchKey()`
    );
    const searchKey = event.target.value.toLowerCase();

    this.logit(
      FINE,
      `handleSearchKey(): searchKey=${searchKey}`,
      `handleSearchKey()`
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
      FINE,
      `handleSearchKey(): this.objectives=${JSON.stringify(this.objectives)}`,
      `handleSearchKey()`
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
}
