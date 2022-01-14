/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement, api, wire, track } from "lwc";
import getClientObjectivesForSession from "@salesforce/apex/MBSessionObjectives.getClientObjectivesForSession";
import createSessionObjectivesByArrayWithOrderedResults from "@salesforce/apex/MBSessionObjectives.createSessionObjectivesByArrayWithOrderedResults";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { fireEvent } from "c/pubsub";
import { CurrentPageReference } from "lightning/navigation";

const columns = [
  {
    label: "Prog",
    fieldName: "Program_Name__c",
    type: "text",
  },
  {
    label: "SD",
    fieldName: "SD_Name__c",
    type: "text",
  },
  {
    label: "Obj",
    fieldName: "Objective_Name__c",
    type: "text",
  },
  {
    label: "Status",
    fieldName: "Status__c",
    type: "text",
  },
  {
    label: "Re-Test Due",
    fieldName: "Re_Test_Recommended__c",
    type: "boolean",
  },
];

export default class Lwcpopulatsessionobjectivesnew extends LightningElement {
  @wire(CurrentPageReference) pageRef;
  @api recordId = "a3N2v000003Gr4VEAS"; //session 31 for testing
  @track allObjectives = {};
  //@wire(getObjectives, { sess: '$recordId' }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  @track objectives;

  @track correctCount = 0;
  @track incorrectCount = 0;
  @track promptedCount = 0;
  @track selectCount = 0;
  @track thisrow = "";
  @track results = [];
  @track sessionresults = [];
  @track skillstring = [];

  connectedCallback() {
    console.info("connectedCallback():  entering");
    this.refresh();
  }

  refresh() {
    console.info("refresh(): entering");
    console.debug("refresh(): calling getClientObjectivesForSession ");

    getClientObjectivesForSession({
      searchKey: this.recordId,
    })
      .then((result) => {
        console.debug("refresh(): getClientObjectivesForSession returned result");
        this.objectives = result;
        console.debug(`refresh(): result=${JSON.stringify(result)}`);
        this.allObjectives = result;
        console.debug(`refresh(): this.objectives= ${JSON.stringify(this.objectives)}`);
      })
      .catch((error) => {
        this.error = error;
        console.error(`refresh(): ERROR ${JSON.stringify(error)}`);
      });
  }

  getSelectedName(event) {
    console.info('getSelectedName(): entering');
    console.debug(
      `getSelectedName(): ${JSON.stringify(event.detail.selectedRows)}`);

    let myselectedRows = event.detail.selectedRows;
    if (myselectedRows.length > 0) {
      this.thisrow =
        myselectedRows[0].Program_Name__c +
        " > " +
        myselectedRows[0].SD_Name__c +
        " > " +
        myselectedRows[0].Objective_Name__c;
      this.selectedRows = myselectedRows;
      this.selectCount = this.selectedRows.length;
    }
  }

  handleIncrCorrect(event) {
    console.info('handleIncrCorrect(): entering');

    if (this.selectedRows) {
      this.results.push("C");
      this.skillstring.push({ skill: "C" });
      console.log(JSON.stringify(this.results));
      this.correctCount += 1;
    }
    console.debug(`handleIncrCorrect(): correctCount= ${this.correctCount}`);
  }

  resetCounters() {
    this.correctCount = 0;
    this.incorrectCount = 0;
    this.promptedCount = 0;
    this.results = [];
    this.skillstring = [];
    this.thisrow = "";
  }

  handleIncrIncorrect(event) {
    console.info('handleIncrIncorrect(): entering');

    if (this.selectedRows) {
      this.results.push("I");
      this.skillstring.push({ skill: "I" });
      this.incorrectCount += 1;
    }
    console.debug(`incorrectCount= ${this.incorrectCount}`);
  }

  handleIncrPrompted(event) {
    console.info('handleIncrPrompted(): entering');

    if (this.selectedRows) {
      this.results.push("P");
      this.skillstring.push({ skill: "P" });
      this.promptedCount += 1;
    }
    console.debug(`promptedCount= ${this.promptedCount}`);
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
    console.info('handleClickArray(): entering');

    if (this.selectedRows) {
      console.debug(`handleClickArray(): this.selectedRows= ${JSON.stringify(this.selectedRows)}`);
      console.debug(`handleClickArray(): this.recordId= ${this.recordId}`);
      
      console.debug(`handleClickArray(): correctcount= + ${this.correctCount}`);
      console.debug(`handleClickArray(): JSON this.skillstring= ${JSON.stringify(this.skillstring)}`);
      console.debug(
        "Commencing imperative Call to createSessionObjectivesByArrayWithOrderedResults() "
      );
      createSessionObjectivesByArrayWithOrderedResults({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId,
        skillstring: JSON.stringify(this.skillstring),
      })
        .then((result) => {
          console.log(`handleClickArray(): Apex returned result ${result}`);
          this.recordsProcessed = result;
          console.debug(`handleClickArray(): ${this.recordsProcessed} records processed.`);
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
            this.selectedRows[0].Program_Name__c +
              " > " +
              this.selectedRows[0].SD_Name__c +
              " > " +
              this.selectedRows[0].Objective_Name__c +
              " : " +
              this.results.toString()
          );
          console.debug(`handleClickArray(): this.sessionresults= ${this.sessionresults}`);
          this.resetCounters();
          this.selectCount = 0;
        })
        .finally(() => {
          console.debug(
            "handleClickArray(): firing event to notify listeners that the sesion objectives have been saved"
          );
          fireEvent(this.pageRef, "inputChangeEvent", this.recordId);
        })
        .catch((error) => {
          this.error = error;
          console.error(`handleClickArray(): ERROR ${JSON.stringify(error)}`);
        });
    }
  }

  handleSearchKeyInput(event) {
    const searchKey = event.target.value.toLowerCase();
    console.log(
      "SEARCHKEY=" +
        searchKey +
        ". this.allObjectives= " +
        JSON.stringify(this.allObjectives)
    );
    this.objectives = this.allObjectives.filter(
      (so) =>
        so.Program_Name__c.toLowerCase().includes(searchKey) ||
        (so.Status__c != null &&
          so.Status__c.toLowerCase().includes(searchKey)) ||
        so.SD_Name__c.toLowerCase().includes(searchKey) ||
        so.Objective_Name__c.toLowerCase().includes(searchKey)
    );
  }

  showNotification(t, m, v) {
    console.info('showNotification(): entering');
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v,
    });
    this.dispatchEvent(evt);
  }

  handleClickCancel(event) {
    this.dispatchEvent(new CustomEvent("close"));
  }
}