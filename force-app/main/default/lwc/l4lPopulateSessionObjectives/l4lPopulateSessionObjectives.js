/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getClientObjectivesForSession from "@salesforce/apex/L4LController.getClientObjectivesForSession";
import createSessionObjectivesByArrayWithOrderedResults from "@salesforce/apex/L4LController.createSessionObjectivesByArrayWithOrderedResults";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";

// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LSessionMessageChannel__c";
import { logDebug, logError } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";

const COMPONENT = "l4lPopulateSessionObjectives";
const TAG = "L4L-Populate-Session-Objectives";

const COLOR = "color:olive"; //for console log formatting

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
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): colummns=${this.columns}`,
          `${COMPONENT}.connectedCallback(): colummns=${this.columns}`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback() calling initial refresh `,
          `${COMPONENT}.connectedCallback() calling initial refresh`,
          `${TAG}`
        );
        this.refresh();
      })
      .catch((error) => {
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback() returned error: ${error}`,
          `${COMPONENT}.connectedCallback() returned error: ${error}`,
          `${TAG}`
        );
      });
  }
  renderedCallback() {}

  refresh() {
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(`%crefresh(): calling getClientObjectivesForSession`, COLOR);

    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling Apex getClientObjectivesForSession`,
      `refreshing client objectives, calling Apex getClientObjectivesForSession`,
      `${TAG}`
    );

    getClientObjectivesForSession({
      searchKey: this.recordId
    })
      .then((result) => {
        this.objectives = result;

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getSessionObjectives returned ${result.length} records`,
          `Apex getClientObjectivesForSession returned ${result.length} records`,
          `${TAG}`
        );

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getSessionObjectives result= ${JSON.stringify(
            result
          )}`,
          `${COMPONENT}.refresh()logged result records`,
          `${TAG}`
        );

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh():setting this.filterableObjectives = result `,
          `${COMPONENT}.refresh():setting this.filterableObjectives = result `,
          `${TAG}`
        );

        console.debug(`refresh(): result=${JSON.stringify(result)}`);
        this.filterableObjectives = result;
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.refresh(): error=${error}`,
          `${COMPONENT}.refresh(): error=${error}`,
          `${TAG}`
        );
      });
  }

  getSelectedName(event) {
    let myselectedRows = event.detail.selectedRows;

    logDebug(
      this.recordId,
      `${COMPONENT}.getSelectedName() this.selectedRows=${JSON.stringify(
        myselectedRows
      )}`,
      "check boxed a client objective row, logged selectedRows",
      `${TAG}`
    );

    if (myselectedRows.length > 0) {
      this.breadcrumb =
        myselectedRows[0].Program_Name__c +
        " > " +
        myselectedRows[0].SD_Name__c +
        " > " +
        myselectedRows[0].Objective_Name__c;

      logDebug(
        this.recordId,
        `${COMPONENT}.getSelectedName() this.breadcrumb=${this.breadcrumb}`,
        `${COMPONENT}.getSelectedName() this.breadcrumb=${this.breadcrumb}`,
        `${TAG}`
      );

      this.selectedRows = myselectedRows;

      logDebug(
        this.recordId,
        `${COMPONENT}.getSelectedName() this.selectedRows=${JSON.stringify(
          this.selectedRows
        )}`,
        `${COMPONENT}.getSelectedName() this.selectedRows=${JSON.stringify(
          this.selectedRows
        )}`,
        `${TAG}`
      );

      this.selectCount = this.selectedRows.length;

      logDebug(
        this.recordId,
        `${COMPONENT}.getSelectedName() selectCount=${this.selectCount}`,
        `${COMPONENT}.getSelectedName() selectCount=${this.selectCount}`,
        `${TAG}`
      );
    }
  }

  handleIncrCorrect(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleIncrCorrect()`,
      `${COMPONENT}.handleIncrCorrect()`,
      `${TAG}`
    );

    if (this.selectedRows) {
      this.results.push("C");
      this.skillstring.push({ skill: "C" });

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrCorrect() this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `${COMPONENT}.handleIncrCorrect() pushing C to results and {skill:C} to skillstring -- all logged`,
        `${TAG}`
      );

      this.correctCount += 1;

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrCorrect() this.correctCount=${this.correctCount}`,
        `${COMPONENT}.handleIncrCorrect() this.correctCount=${this.correctCount}`,
        `${TAG}`
      );
    }
  }

  resetCounters() {
    logDebug(
      this.recordId,
      `${COMPONENT}.resetCounters(): reset all counters `,
      `${COMPONENT}.resetCounters(): reset all counters`,
      `${TAG}`
    );

    this.correctCount = 0;
    this.incorrectCount = 0;
    this.promptedCount = 0;
    this.nonResponsiveCount = 0;
    this.results = [];
    this.skillstring = [];
    //this.breadcrumb = "";
  }

  handleIncrIncorrect(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleIncrIncorrect()`,
      `${COMPONENT}.handleIncrIncorrect()`,
      `${TAG}`
    );

    if (this.selectedRows) {
      this.results.push("I");
      this.skillstring.push({ skill: "I" });

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrIncorrect() this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `${COMPONENT}.handleIncrIncorrect() pushing I to results and {skill:I} to skillstring -- all logged`,
        `${TAG}`
      );

      this.incorrectCount += 1;

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrIncorrect() this.incorrectCount=${this.incorrectCount}`,
        `${COMPONENT}.handleIncrIncorrect() this.incorrectCount=${this.incorrectCount}`,
        `${TAG}`
      );
    }
  }

  handleIncrNonResponsive(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleIncrNonResponsive()`,
      `${COMPONENT}.handleIncrNonResponsive()`,
      `${TAG}`
    );

    if (this.selectedRows) {
      this.results.push("N");
      this.skillstring.push({ skill: "N" });

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrNonResponsive() this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `${COMPONENT}.handleIncrNonResponsive() pushing N to results and {skill:N} to skillstring -- all logged`,
        `${TAG}`
      );

      this.nonResponsiveCount += 1;
      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrNonResponsive() this.nonResponsiveCount=${this.nonResponsiveCount}`,
        `${COMPONENT}.handleIncrNonResponsive() this.nonResponsiveCount=${this.nonResponsiveCount}`,
        `${TAG}`
      );
    }
  }

  handleIncrPrompted(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleIncrPrompted()`,
      `${COMPONENT}.handleIncrPrompted()`,
      `${TAG}`
    );

    if (this.selectedRows) {
      this.results.push("P");
      this.skillstring.push({ skill: "P" });

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrPrompted() this.skillstring=${JSON.stringify(
          this.skillstring
        )} this.results=${JSON.stringify(this.results)}`,
        `${COMPONENT}.handleIncrPrompted() pushing P to results and {skill:P} to skillstring -- all logged`,
        `${TAG}`
      );

      this.promptedCount += 1;

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrPrompted() this.promptedCount=${this.promptedCount}`,
        `${COMPONENT}.handleIncrPrompted() this.promptedCount=${this.promptedCount}`,
        `${TAG}`
      );
    }
  }

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
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): entering`,
      `handleClickArray(): entering`,
      `${TAG}`
    );

    if (this.selectedRows) {
      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray() this.selectedRows=${JSON.stringify(
          this.selectedRows
        )}`,
        `handleClickArray():this.selectedRows logged`,
        `${TAG}`
      );

      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): calling Apex createSessionObjectivesByArrayWithOrderedResults()`,
        `${COMPONENT}.handleClickArray(): creating session objectives via Apex createSessionObjectivesByArrayWithOrderedResults `,
        `${TAG}`
      );

      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): createSessionObjectivesByArrayWithOrderedResults parameters: jsonstr=${JSON.stringify(
          this.selectedRows
        )},sess=${this.recordId},skillstring=${JSON.stringify(
          this.skillstring
        )} `,
        `${COMPONENT}.handleClickArray(): apex parameters logged`
      );

      createSessionObjectivesByArrayWithOrderedResults({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId,
        skillstring: JSON.stringify(this.skillstring)
      })
        .then((result) => {
          this.recordsProcessed = result;
          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray(): Apex returned result: ${JSON.stringify(
              result
            )}`,
            `Apex call to create session objectives returned, all good, record payload logged`,
            `${TAG}`
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
          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray(): resetting counters, calling this.resetCounters()`,
            `${COMPONENT}.handleClickArray(): resetting counters, calling this.resetCounters()`,
            `${TAG}`
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

          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray(): Sending message via L4LMC, message=${JSON.stringify(
              message
            )}`,
            `${COMPONENT}.handleClickArray() sending message=${JSON.stringify(
              message
            )}`,
            `${TAG}`
          );
          publish(this.messageContext, L4LMC, message);
        })
        .catch((error) => {
          this.error = error;
          logError(
            this.recordId,
            `${COMPONENT}.handleClickArray(): error=${error}`,
            `${COMPONENT}.handleClickArray(): error=${error}`,
            `${TAG}`
          );
        });
    }
  }

  handleSearchKeyInput(event) {
    const searchKey = event.target.value.toLowerCase();

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput(): searchKey=${searchKey}`,
      `entered Search input: ${searchKey}`,
      `${TAG}`
    );

    this.objectives = this.filterableObjectives.filter(
      (so) =>
        so.Program_Name__c.toLowerCase().includes(searchKey) ||
        (so.Status__c != null &&
          so.Status__c.toLowerCase().includes(searchKey)) ||
        so.SD_Name__c.toLowerCase().includes(searchKey) ||
        so.Objective_Name__c.toLowerCase().includes(searchKey)
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput(): this.objectives=${JSON.stringify(
        this.objectives
      )}`,
      `${COMPONENT}.handleSearchKeyInput(): this.objectives logged}`,
      `${TAG}`
    );
  }

  showNotification(t, m, v) {
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v
    });
    this.dispatchEvent(evt);
  }

  handleClickCancel(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickCancel(): dispatching close event `,
      `${COMPONENT}.handleClickCancel(): dispatching close event `,
      `${TAG}`
    );

    this.dispatchEvent(new CustomEvent("close"));
  }
}
