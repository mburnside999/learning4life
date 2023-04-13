/* eslint-disable no-console */

/**************************************************************
 * @author	Mike Burnside
 * @date	2022
 * @group Learning For Life
 *
 * @description	Assess and populate Session objective records. Designed to be a modal.
 *
 */

import { LightningElement, api, wire, track } from "lwc";
import getClientObjectivesForSession from "@salesforce/apex/L4LController.getClientObjectivesForSession";
import createSessionObjectivesByArrayWithOrderedResults from "@salesforce/apex/L4LController.createSessionObjectivesByArrayWithOrderedResults";
import updateSessionObjectiveWithLG from "@salesforce/apex/L4LController.updateSessionObjectiveWithLG";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";

// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LSessionMessageChannel__c";

// Nebula
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";

const COMPONENT = "l4lPopulateSessionObjectives";
const TAG = "L4L-Populate-Session-Objectives";
const SCENARIO = "Score the Session Objectives for a client";
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
  lgbuttondisabled = true;

  /*******************************************************************************************************
   * @description initialise logging, do the initial refresh
   *
   * @param void
   */

  connectedCallback() {
    console.info(`in connectedCallback`, COLOR);
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${SCENARIO}`,
          `${TAG}`
        );
        logDebug(
          this.recordId,
          `${COMPONENT}.connectedCallback(): colummns=${this.columns}`,
          `${SCENARIO}`,
          `${TAG}`
        );
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, calling initial refresh `,
          `${SCENARIO}`,
          `${TAG}`
        );
        this.refresh();
      })
      .catch((error) => {
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }
  renderedCallback() {}

  /*******************************************************************************************************
   * @description main refresh method, calls Apex getClientObjectivesForSession
   *
   * @param void
   */
  refresh() {
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(`%crefresh(): calling getClientObjectivesForSession`, COLOR);
    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling Apex getClientObjectivesForSession`,
      `${SCENARIO}`,
      `${TAG}`
    );

    getClientObjectivesForSession({
      searchKey: this.recordId
    })
      .then((result) => {
        this.objectives = result;

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getClientObjectivesForSession returned ${result.length} records`,
          `${SCENARIO}`,
          `${TAG}`
        );

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getSessionObjectives result= ${JSON.stringify(
            result
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );

        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): setting this.filterableObjectives = result `,
          `${SCENARIO}`,
          `${TAG}`
        );

        console.debug(`refresh(): result=${JSON.stringify(result)}`);
        this.filterableObjectives = result;
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.refresh(): error=${JSON.stringify(error)}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }
  /*******************************************************************************************************
   * @description bound to onrowselection on the datatable, creates the breadcrumbs
   *
   * @param event
   */

  getSelectedName(event) {
    this.lgbuttondisabled = true;
    let myselectedRows = event.detail.selectedRows;

    logDebug(
      this.recordId,
      `${COMPONENT}.getSelectedName() this.selectedRows=${JSON.stringify(
        myselectedRows
      )}`,
      `${SCENARIO}`,
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
        `${SCENARIO}`,
        `${TAG}`
      );

      logDebug(
        this.recordId,
        `${COMPONENT}.getSelectedName() this.selectedRows=${JSON.stringify(
          this.selectedRows
        )}`,
        `${SCENARIO}`,
        `${TAG}`
      );

      this.selectedRows = myselectedRows;
      this.selectCount = this.selectedRows.length;

      logDebug(
        this.recordId,
        `${COMPONENT}.getSelectedName() selectCount=${this.selectCount}`,
        `${SCENARIO}`,
        `${TAG}`
      );
    }
  }

  /*******************************************************************************************************
   * @description bound to onclick for the +C (correct) button, pushes {"skill":"C"} on to the skillstring array
   *
   * @param event
   */

  handleIncrCorrect(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleIncrCorrect(): clicked Correct`,
      `${SCENARIO}`,
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
        `${SCENARIO}`,
        `${TAG}`
      );

      this.correctCount += 1;

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrCorrect(): this.correctCount=${this.correctCount}`,
        `${SCENARIO}`,
        `${TAG}`
      );
    }
  }

  handleClickLG(event) {
    console.log("=======>" + this.selectedRows[0].Id);

    let coid = this.selectedRows[0].Id;
    console.log(`Calling updateSessionObjectiveWithLG ${coid}`);
    updateSessionObjectiveWithLG({
      cobjid: coid
    })
      .then((result) => {
        console.log("returned");
        console.log("updateSessionObjectiveWithLG returned: " + result);
      })
      .then(() => {
        this.showNotification("Success", `LG recorded`, "success");
        this.sessionresults.push("---- LG ----");
      })
      .catch((error) => {
        console.log("ERROR " + JSON.stringify(error));
      })
      .finally(() => {
        this.lgbuttondisabled = true;
        const message = {
          recordId: "",
          message: "message from l4lPopulateSessionObjectives",
          source: "LWC",
          recordData: {}
        };

        logDebug(
          this.recordId,
          `${COMPONENT}.handleClickArray(): publishing message via L4LMC, message=${JSON.stringify(
            message
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
        publish(this.messageContext, L4LMC, message);
      });
  }

  resetCounters() {
    logDebug(
      this.recordId,
      `${COMPONENT}.resetCounters(): reset all counters `,
      `${SCENARIO}`,
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

  /*******************************************************************************************************
   * @description bound to onclick for the +I (incorrect) button, pushes {"skill":"I"} on to the skillstring array
   *
   * @param event
   */
  handleIncrIncorrect(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleIncrIncorrect()`,
      `${SCENARIO}`,
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
        `${SCENARIO}`,
        `${TAG}`
      );

      this.incorrectCount += 1;

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrIncorrect(): this.incorrectCount=${this.incorrectCount}`,
        `${SCENARIO}`,
        `${TAG}`
      );
    }
  }

  /*******************************************************************************************************
   * @description bound to onclick for the +N (nonresponsive) button, pushes {"skill":"N"} on to the skillstring array
   *
   * @param event
   */

  handleIncrNonResponsive(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleIncrNonResponsive()`,
      `${SCENARIO}`,
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
        `${SCENARIO}`,
        `${TAG}`
      );

      this.nonResponsiveCount += 1;
      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrNonResponsive(): this.nonResponsiveCount=${this.nonResponsiveCount}`,
        `${SCENARIO}`,
        `${TAG}`
      );
    }
  }

  /*******************************************************************************************************
   * @description bound to onclick for the +P (prompted) button, pushes {"skill":"P"} on to the skillstring array
   *
   * @param event
   */
  handleIncrPrompted(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleIncrPrompted()`,
      `${SCENARIO}`,
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
        `${SCENARIO}`,
        `${TAG}`
      );

      this.promptedCount += 1;

      logDebug(
        this.recordId,
        `${COMPONENT}.handleIncrPrompted(): this.promptedCount=${this.promptedCount}`,
        `${SCENARIO}`,
        `${TAG}`
      );
    }
  }

  /*******************************************************************************************************
   * @description getter to determine whether the Record Assessment button should light up
   *
   * @param event
   */

  get buttonDisabled() {
    return (
      parseInt(this.correctCount) +
        parseInt(this.nonResponsiveCount) +
        parseInt(this.incorrectCount) +
        parseInt(this.promptedCount) ==
      0
    );
  }

  /*******************************************************************************************************
   * @description bound to onclick for the Record Assessment button. Calls Apex createSessionObjectivesByArrayWithOrderedResults
   *
   * @param event
   */

  handleClickArray(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): entering`,
      `${SCENARIO}`,
      `${TAG}`
    );

    if (this.selectedRows) {
      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): this.selectedRows=${JSON.stringify(
          this.selectedRows
        )}`,
        `${SCENARIO}`,
        `${TAG}`
      );

      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): calling Apex createSessionObjectivesByArrayWithOrderedResults()`,
        `${SCENARIO}`,
        `${TAG}`
      );

      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): createSessionObjectivesByArrayWithOrderedResults parameters: jsonstr=${JSON.stringify(
          this.selectedRows
        )},sess=${this.recordId},skillstring=${JSON.stringify(
          this.skillstring
        )} `,
        `${SCENARIO}`,
        `${TAG}`
      );
      console.log("=========>" + JSON.stringify(this.selectedRows));

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
            `${SCENARIO}`,
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
            `${SCENARIO}`,
            `${TAG}`
          );
          this.resetCounters();
          this.selectCount = 0;
        })
        .catch((error) => {
          this.error = error;
          logError(
            this.recordId,
            `${COMPONENT}.handleClickArray(): error=${JSON.stringify(error)}`,
            `${SCENARIO}`,
            `${TAG}`
          );
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
            `${COMPONENT}.handleClickArray(): publishing message via L4LMC, message=${JSON.stringify(
              message
            )}`,
            `${SCENARIO}`,
            `${TAG}`
          );
          publish(this.messageContext, L4LMC, message);
          this.lgbuttondisabled = false;
        });
    }
  }

  /*******************************************************************************************************
   * @description bound to oninput for the filtering field. Filtering is client side Javascript.
   *
   * @param event
   */

  handleSearchKeyInput(event) {
    const searchKey = event.target.value.toLowerCase();

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSearchKeyInput(): searchKey=${searchKey}`,
      `${SCENARIO}`,
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
      `${SCENARIO}`,
      `${TAG}`
    );
  }

  /*******************************************************************************************************
   * @description helper for showing toast. bound to oninput for the filtering field. Filtering is client side Javascript.
   *
   * @param t Title
   * @param m Message
   * @param v Variant
   */

  showNotification(t, m, v) {
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v
    });
    this.dispatchEvent(evt);
  }

  /*******************************************************************************************************
   * @description bound to onclick for the Close button. Dispatches a custom event to initiate the tear doewn of the modal.
   * @param event
   */

  handleClickCancel(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickCancel(): dispatching close() CustomEvent`,
      `${SCENARIO}`,
      `${TAG}`
    );

    this.dispatchEvent(new CustomEvent("close"));
  }
}
