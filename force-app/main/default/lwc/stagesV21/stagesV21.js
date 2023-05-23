import { LightningElement, api, track } from "lwc";
import getSDUsage from "@salesforce/apex/L4LStagesByArea.getSDUsage";
import { logInfo, logError } from "c/l4lNebulaUtil";

import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";

const COMPONENT = "stagesV21";
const TAG = "L4L-Manage-Client-Objectives";
const SCENARIO = "StagesV21 - Client Objectives Board - LWC";
const UI_EVENT_TRACKING_SCENARIO = "stagesV21 LWC UI Event Tracking";
const APEX_EVENT_TRACKING_SCENARIO = "stages21 LWC APEX Event Tracking";

export default class L4LStagesByArea extends LightningElement {
  // Obtain the Id of the current record from the page
  @api recordId;

  //Modal Code - for the two Modals with Screenflows Add Objectives and Set CAB Status
  //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded
  @track isModalOpen = false;
  @track startFlow = false;
  @track startCABFlow = false;
  @track CABModalOpen = false;
  @track showStage = true;
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
      // this.isModalOpen = false;
      this.startFlow = false; // This variable controls the Flow for adding Objectives
      this.showStage = true; // This shows the Stage Picklist Selector
      this.getUsage(); // This repopulates the variable Area/SD data after the flow
    }
  }
  handleCABFlowEnd(event) {
    if (event.detail.status === "FINISHED") {
      this.CABModalOpen = false;
      this.startCABFlow = false;
      this.showStage = true;
      this.getUsage();
    }
  }
  openModal(event) {
    // to open modal set isModalOpen track value as true- it used to be a modal - it's just the Flow screen now
    this.currentRecord = event.target.getAttribute("data-id");
    // this.isModalOpen = true;
    this.startFlow = true;
    this.showStage = false;
    this.agfsdRecords = []; // This line sets the existing variable data to blank - clearing the screen
  }
  openCABModal(event) {
    // to open modal set isModalOpen track value as true
    this.currentRecord = event.target.getAttribute("data-id");
    this.startCABFlow = true;
    this.showStage = false;
    this.agfsdRecords = []; // This line sets the existing variable data to blank - clearing the screen
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

  // Declare a list to store the unique SD__c records and Stage filtered SD__c records also sets values to blank
  sdRecords = [];
  fsdRecords = [];
  @track agfsdRecords = [];
  gfsdRecords = [];

  // Calling Apex Imperativitaly - rather than using @wire method
  getUsage() {
    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LStagesByArea.getSDUsage`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    getSDUsage({ clientId: this.recordId })
      .then((data) => {
        if (data) this.processUsageData(data);
      })
      .catch((error) => {
        console.log(error.message);
      });
  }
  // Need to reset the variable data to Blank as opposed to declaring and setting to blank as per above
  processUsageData(data) {
    this.sdRecords = [];
    this.fsdRecords = [];
    this.agfsdRecords = [];
    this.gfsdRecords = [];

    // If the Apex method returns successfully, store the unique SD__c records in the list then filter to display the default stage
    let d = JSON.parse(data);

    //this.sdRecords = data;
    this.sdRecords = d;
    // console.log("sdRecords:", this.sdRecords);
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

  // Declare a change handler for the filter input then return the filtered results as fsdRecords
  handleFilterChange(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: Stage Filter change`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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
  // This is the function that connects to the data via the function getUsage
  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Successfully executed Nebula setNewSession()");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, calling getUsage()`,
          `${SCENARIO}`,
          `${TAG}`
        );
        logInfo(
          this.recordId,
          `${COMPONENT}: connectedCallback`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking
        this.getUsage();
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback(): error: ${error}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }
}
