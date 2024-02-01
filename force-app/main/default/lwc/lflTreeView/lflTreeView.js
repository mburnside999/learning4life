import { LightningElement, api, wire } from "lwc";
import getJSONTree from "@salesforce/apex/LFLTreeUtil.getJSONTree";
import getJSONTreeFiltered from "@salesforce/apex/LFLTreeUtil.getJSONTreeFiltered";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";

const COLUMNS = [
  {
    type: "text",
    fieldName: "name",
    label: "Name"
  },
  {
    type: "text",
    fieldName: "type",
    label: "Program, SD, Objective"
  },
  {
    type: "text",
    fieldName: "status",
    label: "Status"
  },
  {
    type: "url",
    fieldName: "IdUrl",
    label: "Go To Record Page",
    typeAttributes: { label: { fieldName: "name" }, target: "_blank" }
  }
];

const COMPONENT = "l4lTreeView";
const TAG = "L4L-Manage-Catalog";
const SCENARIO = "View Catalog Tree - LWC";
const UI_EVENT_TRACKING_SCENARIO = "LWC UI: lflTreeView";
const APEX_EVENT_TRACKING_SCENARIO = "LWC Apex: lflTreeView";

export default class LflTreeView extends LightningElement {
  gridData = [];
  o = 0;
  gridColumns = COLUMNS;
  @api lwcTitle = "Catalog Browser";
  @api isLoaded = false;
  @wire(getJSONTree, { reserved: "reserved" })
  wiredJSON(value) {
    const { data, error } = value;
    if (data) {
      console.log(data);
      this.gridData = JSON.parse(data);
      this.allData = this.gridData;
      this.initData = this.gridData;
      this.error = undefined;
      this.isLoaded = true;
    } else if (error) {
      this.error = error;
      this.gridData = undefined;
    }
  }

  /*******************************************************************************************************
   * @name ConnectedCallback
   * @description
   * sets up logging
   * sets up subscription handle for Messaging Service
   * performs initial call to refresh()
   *
   * @param
   * @return
   */

  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logDebug(
          null,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${SCENARIO}`,
          `${TAG}`
        );
        logInfo(
          null,
          `${COMPONENT}.connectedCallback(): All good,session is commencing `,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .catch((error) => {
        console.log("Error");
        logError(
          null,
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  get resultSize() {
    return this.gridData.length;
  }

  get catalogShape() {
    let y = [];
    let z = [];
    let ptotal = this.gridData.length;
    let sdtotal = 0;
    let objtotal = 0;

    for (let i = 0; i < ptotal; i++) {
      y = this.gridData[i]._children;
      sdtotal += y.length;
      for (let j = 0; j < y.length; j++) {
        z = y[j]._children;
        objtotal += z.length;
      }
    }
    console.log("ptotal=" + ptotal);
    console.log("sdtotal=" + sdtotal);
    console.log("objtotal=" + objtotal);

    return (
      "Displaying " +
      ptotal +
      " Programs, " +
      sdtotal +
      "  SDs, " +
      objtotal +
      " Objectives"
    );
  }

  handleFilterKeyInput(event) {
    logInfo(
      null,
      `${COMPONENT}: handleFilterKeyInput: ${event.target.value.toLowerCase()}`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    const filterKey = event.target.value.toLowerCase();
    if (filterKey.length == 0) {
      //this.gridData = this.allData;
      console.log("REFRESH");
    }
    this.gridData = this.allData.filter((so) => {
      return so.name.toLowerCase().includes(filterKey);
    });
  }

  handleSearchKeyword() {
    console.log("calling search with parameter " + this.searchValue);

    logInfo(
      null,
      `${COMPONENT}: handleSearchKeyword: ${this.searchValue}`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    logInfo(
      null,
      `${COMPONENT}: Apex Call: getJSONTreeFiltered`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    getJSONTreeFiltered({
      searchStr: this.searchValue
    })
      .then((result) => {
        // set @track contacts variable with return contact list from server
        // this.logit(
        //   FINE,
        //   `handleSearchKeyword(): result=${JSON.stringify(result)}`,
        //   `handleSearchKeyword()`
        // );
        this.gridData = JSON.parse(result);
        this.allData = this.gridData;
      })
      .catch((error) => {
        logError(
          null,
          `${COMPONENT}.handleSearchKeyword(): error=${JSON.stringify(error)}`,
          `${SCENARIO}`,
          `${TAG}`
        );

        const event = new ShowToastEvent({
          title: "Error",
          variant: "error",
          message: error.body.message
        });
        this.dispatchEvent(event);
        // reset contacts var with null
      });
  }

  handleSearchValueChange(event) {
    this.searchValue = event.target.value;
  }

  handleReset(event) {
    logInfo(
      null,
      `${COMPONENT}: handleReset: Pressed reset`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    this.template.querySelector('lightning-input[data-name="search"]').value =
      "";
    this.template.querySelector('lightning-input[data-name="filter"]').value =
      "";

    this.gridData = this.initData;
    this.allData = this.initData;
  }
}
