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

  isButtonDisabled = true;

  //test
  @track results = [];
  @track sessionresults = [];
  @track skillstring = [];

  connectedCallback() {
    console.log("in connetedCallback calling refresh()");
    this.refresh();
  }

  refresh() {
    console.log("in refactored refresh()");
    getClientObjectivesForSession({
      searchKey: this.recordId,
    })
      .then((result) => {
        console.log("RETURNED");
        this.objectives = result;
        this.allObjectives = result;
        console.log(JSON.stringify(this.objectives));
      })
      .catch((error) => {
        this.error = error;
        console.log("ERROR" + JSON.stringify(error));
      });
  }

  getSelectedName(event) {
    console.log(
      "in getSelectedName ",
      JSON.stringify(event.detail.selectedRows)
    );

    let myselectedRows = event.detail.selectedRows;
    console.log("populating the this row");
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
    if (this.selectedRows) {
      this.results.push("C");
      this.skillstring.push({ skill: "C" });
      console.log(JSON.stringify(this.results));
      this.correctCount += 1;
      isButtonDisabled = false;
    }
    console.log("correctCount " + this.correctCount);
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
    if (this.selectedRows) {
      this.results.push("I");
      this.skillstring.push({ skill: "I" });
      this.incorrectCount += 1;
    }
    console.log("incorrectCount " + this.incorrectCount);
  }

  handleIncrPrompted(event) {
    if (this.selectedRows) {
      this.results.push("P");
      this.skillstring.push({ skill: "P" });
      this.promptedCount += 1;
    }
    console.log("promptedCount: " + this.promptedCount);
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
    if (this.selectedRows) {
      console.log("logging JSON: " + JSON.stringify(this.selectedRows));
      console.log("loging session: " + this.recordId);
      console.log(
        "Commencing imperative Call to createSessionObjectivesByArrayWithOrderedResults() "
      );
      console.log("correctcount=" + this.correctCount);
      console.log("JSON results", JSON.stringify(this.skillstring));
      createSessionObjectivesByArrayWithOrderedResults({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId,
        skillstring: JSON.stringify(this.skillstring),
      })
        .then((result) => {
          console.log("RETURNED");
          this.recordsProcessed = result;
          console.log(this.recordsProcessed + "records processed.");
        })
        .then(() => {
          console.log("Refreshing");
        })
        .then(() => {
          this.showNotification(
            "Success",
            this.recordsProcessed + " records processed.",
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
          console.log("sessionresults", this.sessionresults);
          //this.objectives = [];
          //this.refresh();
          this.resetCounters();
          this.selectCount = 0;
        })
        .finally(() => {
          console.log(
            "firing event to notify listeners that the sesion objectives have been saved"
          );
          fireEvent(this.pageRef, "inputChangeEvent", this.recordId);
        })
        .catch((error) => {
          this.error = error;
          console.log("ERRORED" + JSON.stringify(error));
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
    console.log("Toast...");
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
