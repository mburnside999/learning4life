/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getClientObjectivesForSession from "@salesforce/apex/L4LController.getClientObjectivesForSession";
import createSessionObjectivesByArrayWithOrderedResults from "@salesforce/apex/L4LController.createSessionObjectivesByArrayWithOrderedResults";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";

// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LSessionMessageChannel__c";

const COLOR = "color:olive";

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

export default class Lwcpopulatsessionobjectivesnew extends LightningElement {
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

  connectedCallback() {
    console.info(`in connectedCallback`, COLOR);
    this.refresh();
  }

  refresh() {
    console.info(`%crefresh(): entering`, COLOR);
    console.debug(`%crefresh(): calling getClientObjectivesForSession`, COLOR);

    getClientObjectivesForSession({
      searchKey: this.recordId
    })
      .then((result) => {
        console.debug(
          `%crefresh(): getClientObjectivesForSession returned result=${JSON.stringify(
            result
          )}`,
          COLOR
        );
        this.objectives = result;
        //console.debug(`refresh(): result=${JSON.stringify(result)}`);
        this.filterableObjectives = result;
        console.debug(
          `%crefresh(): this.objectives= ${JSON.stringify(this.objectives)}`,
          COLOR
        );
      })
      .catch((error) => {
        this.error = error;
        console.error(`%crefresh(): ERROR ${JSON.stringify(error)}`, COLOR);
      });
  }

  getSelectedName(event) {
    console.info(`%cgetSelectedName(): entering`, COLOR);
    console.debug(
      `%cgetSelectedName(): ${JSON.stringify(event.detail.selectedRows)}`,
      COLOR
    );

    let myselectedRows = event.detail.selectedRows;
    console.debug(
      `getSelectedName():myselectedRows.length=${myselectedRows.length}`,
      COLOR
    );
    if (myselectedRows.length > 0) {
      console.debug("%cgetSelectedName() setting this.breadcrumb");
      this.breadcrumb =
        myselectedRows[0].Program_Name__c +
        " > " +
        myselectedRows[0].SD_Name__c +
        " > " +
        myselectedRows[0].Objective_Name__c;
      console.debug(
        `%cgetSelectedName(): this.breadcrumb=${JSON.stringify(
          this.breadcrumb
        )}`,
        COLOR
      );
      this.selectedRows = myselectedRows;
      console.debug(
        `%cgetSelectedName(): this.selectedRows=${JSON.stringify(
          this.selectedRows
        )}`,
        COLOR
      );
      this.selectCount = this.selectedRows.length;
    }
  }

  handleIncrCorrect(event) {
    console.info(`%chandleIncrCorrect(): entering`, COLOR);

    if (this.selectedRows) {
      this.results.push("C");
      this.skillstring.push({ skill: "C" });
      console.debug(
        `%chandleIncrCorrect(): this.results=${JSON.stringify(this.results)}`,
        COLOR
      );
      console.debug(
        `%chandleIncrCorrect(): this.skillstring=${JSON.stringify(
          this.skillstring
        )}`,
        COLOR
      );

      this.correctCount += 1;
    }
    console.debug(
      `%chandleIncrCorrect(): correctCount= ${this.correctCount}`,
      COLOR
    );
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
    console.info(`%chandleIncrIncorrect(): entering`, COLOR);

    if (this.selectedRows) {
      this.results.push("I");
      this.skillstring.push({ skill: "I" });
      console.debug(
        `%chandleIncrIncorrect(): this.results=${JSON.stringify(this.results)}`,
        COLOR
      );
      console.debug(
        `%chandleIncrIncorrect(): this.skillstring=${JSON.stringify(
          this.skillstring
        )}`,
        COLOR
      );

      this.incorrectCount += 1;
    }
    console.debug(`%cincorrectCount= ${this.incorrectCount}`, COLOR);
  }

  handleIncrPrompted(event) {
    console.info(`%chandleIncrPrompted(): entering`, COLOR);

    if (this.selectedRows) {
      this.results.push("P");
      this.skillstring.push({ skill: "P" });
      console.debug(
        `%chandleIncrPrompted(): this.results=${JSON.stringify(this.results)}`,
        COLOR
      );
      console.debug(
        `%chandleIncrPrompted(): this.skillstring=${JSON.stringify(
          this.skillstring
        )}`,
        COLOR
      );

      this.promptedCount += 1;
    }
    console.debug(`%cpromptedCount= ${this.promptedCount}`, COLOR);
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
    console.info(`%chandleClickArray(): entering`, COLOR);

    if (this.selectedRows) {
      console.debug(
        `%chandleClickArray(): this.selectedRows= ${JSON.stringify(
          this.selectedRows
        )}`,
        COLOR
      );
      console.debug(
        `%chandleClickArray(): this.recordId= ${this.recordId}`,
        COLOR
      );

      console.debug(
        `%chandleClickArray(): correctcount= + ${this.correctCount}`,
        COLOR
      );
      console.debug(
        `%chandleClickArray(): JSON this.skillstring= ${JSON.stringify(
          this.skillstring
        )}`,
        COLOR
      );
      console.debug(
        `%cCommencing imperative Call to createSessionObjectivesByArrayWithOrderedResults()`,
        COLOR
      );
      createSessionObjectivesByArrayWithOrderedResults({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId,
        skillstring: JSON.stringify(this.skillstring)
      })
        .then((result) => {
          console.log(
            `%chandleClickArray(): Apex returned result ${result}`,
            COLOR
          );
          this.recordsProcessed = result;
          console.debug(
            `%chandleClickArray(): ${this.recordsProcessed} records processed.`,
            COLOR
          );
        })
        .then(() => {
          console.log("Refreshing");
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
          console.debug(
            `%chandleClickArray(): this.sessionresults= ${this.sessionresults}`,
            COLOR
          );
          this.resetCounters();
          this.selectCount = 0;
        })
        .finally(() => {
          const message = {
            recordId: "",
            message: "message from lwcpopulatesessionobjectives",
            source: "LWC",
            recordData: {}
          };
          console.debug(
            `%chandleClickArray(): Publishing message via L4LMC to L4LSessionMessageChannel__c, message=${JSON.stringify(
              message
            )}`,
            COLOR
          );
          publish(this.messageContext, L4LMC, message);
        })
        .catch((error) => {
          this.error = error;
          console.error(`%chandleClickArray(): ERROR ${JSON.stringify(error)}`);
        });
    }
  }

  handleSearchKeyInput(event) {
    console.info(`%chandleSearchKeyInput(): entering`, COLOR);

    const searchKey = event.target.value.toLowerCase();
    console.info(`%chandleSearchKeyInput(): searchKey={searchKey}`, COLOR);
    this.objectives = this.filterableObjectives.filter(
      (so) =>
        so.Program_Name__c.toLowerCase().includes(searchKey) ||
        (so.Status__c != null &&
          so.Status__c.toLowerCase().includes(searchKey)) ||
        so.SD_Name__c.toLowerCase().includes(searchKey) ||
        so.Objective_Name__c.toLowerCase().includes(searchKey)
    );
  }

  showNotification(t, m, v) {
    console.info(`%cshowNotification(): entering`, COLOR);
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v
    });
    this.dispatchEvent(evt);
  }

  handleClickCancel(event) {
    console.info(`%chandleClickCancel(): entering`, COLOR);
    this.dispatchEvent(new CustomEvent("close"));
  }
}
