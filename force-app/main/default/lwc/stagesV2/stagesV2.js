import { LightningElement, api, wire, track } from "lwc";
import getSDUsage from "@salesforce/apex/L4LStagesByArea.getSDUsage";

export default class L4LStagesByArea extends LightningElement {
  // Obtain the Id of the current record from the page
  @api recordId;

  //Modal Code - for the two Modals with Screenflows Add Objectives and Set CAB Status
  //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded
  @track isModalOpen = false;
  @track CABModalOpen = false;
  get inputVariables() {
    return [
      {
        name: "clientId",
        type: "String",
        value: this.recordId
      },
      {
        name: "SDId",
        type: "String",
        value: this.currentRecord
      }
    ];
  }

  // set behavior after a finished flow interview
  handleStatusChange(event) {
    if (event.detail.status === "FINISHED") {
      this.isModalOpen = false;
      this.getUsage();
    }
  }
  handleCABFlowEnd(event) {
    if (event.detail.status === "FINISHED") {
      this.CABModalOpen = false;
      this.getUsage();
    }
  }
  openModal(event) {
    // to open modal set isModalOpen track value as true
    this.currentRecord = event.target.getAttribute("data-id");
    this.isModalOpen = true;
  }
  openCABModal(event) {
    // to open modal set isModalOpen track value as true
    this.currentRecord = event.target.getAttribute("data-id");
    this.CABModalOpen = true;
  }
  closeModal() {
    // to close modal set isModalOpen track value as false
    this.isModalOpen = false;
  }
  closeCABModal() {
    // to close modal set isModalOpen track value as false
    this.CABModalOpen = false;
  }
  submitDetails() {
    // Note this button is not enabled on the screen
    // to close modal set isModalOpen track value as false
    //Add your code to call apex method or do some processing
    this.isModalOpen = false;
  }
  submitCABDetails() {
    // Note this button is not enabled on the screen
    // to close modal set isModalOpen track value as false
    //Add your code to call apex method or do some processing
    this.CABModalOpen = false;
  }

  // Populate the Stage Filter
  stageOptions = [
    { label: "Stage One", value: "Stage One" },
    { label: "Stage Two", value: "Stage Two" },
    { label: "Stage Three", value: "Stage Three" },
    { label: "Stage Four", value: "Stage Four" },
    { label: "Stage Five", value: "Stage Five" },
    { label: "Stage Six", value: "Stage Six" }
  ];

  // Declare a variable to store the filter value
  @track stageFilter = "Stage One";

  // Declare a list to store the unique SD__c records and Stage filtered SD__c records
  sdRecords = [];
  fsdRecords = [];
  @track agfsdRecords = [];
  gfsdRecords = [];

  getUsage() {
    getSDUsage({ clientId: this.recordId })
      .then(data => {
        if(data) this.processUsageData(data);
      }).catch(error => {
        console.log(error.message);
      })
  }

  processUsageData(data) {
    this.sdRecords = [];
    this.fsdRecords = [];
    this.agfsdRecords = [];
    this.gfsdRecords = [];

    // If the Apex method returns successfully, store the unique SD__c records in the list then filter to display the default stage
      let d = JSON.parse(data);

      //this.sdRecords = data;
      this.sdRecords = d;
      console.log("sdRecords:", this.sdRecords);
      this.stageFilter = "Stage One";

      // Loop through the filtered SD__c records and group them by Area__c
      this.sdRecords.forEach((record) => {
        record.sd.CABStatus = record.CABStatus;
        record.sd.NotUsed = record.NotUsed;
        if (record.sd.Area__c) {
          // only process records where Area__c is defined
          if (!this.gfsdRecords[record.sd.Area__c]) {
            this.gfsdRecords[record.sd.Area__c] = [];
          }
          this.gfsdRecords[record.sd.Area__c].push(record.sd);
        }
      });
      // Convert the Object gfsdRecords into the Array agfsdRecords
      this.agfsdRecords = Object.entries(this.gfsdRecords)
        .map(([area, records]) => ({
          area,
          records
        }))
        .filter((obj) => {
          return obj.records.some(
            (record) => record.Stage__c === this.stageFilter
          );
        });
      console.log("agfsdRecords:", JSON.stringify(this.agfsdRecords));
  }

  /*
  // Use the @wire decorator to call the getSDUsage Apex method
  @wire(getSDUsage, { clientId: "$recordId" })
  wiredgetSDUsage({ error, data }) {
    if (data) {
      // If the Apex method returns successfully, store the unique SD__c records in the list then filter to display the default stage
      let d = JSON.parse(data);

      //this.sdRecords = data;
      this.sdRecords = d;
      console.log("sdRecords:", this.sdRecords);
      this.stageFilter = "Stage One";

      // Loop through the filtered SD__c records and group them by Area__c
      this.sdRecords.forEach((record) => {
        record.sd.CABStatus = record.CABStatus;
        if (record.sd.Area__c) {
          // only process records where Area__c is defined
          if (!this.gfsdRecords[record.sd.Area__c]) {
            this.gfsdRecords[record.sd.Area__c] = [];
          }
          this.gfsdRecords[record.sd.Area__c].push(record.sd);
        }
      });
      // Convert the Object gfsdRecords into the Array agfsdRecords
      this.agfsdRecords = Object.entries(this.gfsdRecords)
        .map(([area, records]) => ({
          area,
          records
        }))
        .filter((obj) => {
          return obj.records.some(
            (record) => record.Stage__c === this.stageFilter
          );
        });
      console.log("agfsdRecords:", this.agfsdRecords);
      return this.agfsdRecords;
    } else if (error) {
      // If an error occurs, log the error to the console
      console.error("================ " + error);

      console.error(error);
    }
  }
  */

  // Declare a change handler for the filter input then return the filtered results as fsdRecords
  handleFilterChange(event) {
    // Update the filter value
    this.stageFilter = event.target.value;
    // Convert the Object gfsdRecords into the Array agfsdRecords
    this.agfsdRecords = Object.entries(this.gfsdRecords)
      .map(([area, records]) => ({
        area,
        records
      }))
      .filter((obj) => {
        return obj.records.some(
          (record) => record.Stage__c === this.stageFilter
        );
      });
    console.log("agfsdRecords:", this.agfsdRecords);
    return this.agfsdRecords;
  }

  connectedCallback() {
    this.getUsage();
  }
}