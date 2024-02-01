import { LightningElement, api, wire } from "lwc";
import getJSONTree from "@salesforce/apex/LFLTreeUtil.getJSONTree";
import getJSONTreeFiltered from "@salesforce/apex/LFLTreeUtil.getJSONTreeFiltered";

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

import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";
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
      " Programs: " + ptotal + ", SDs: " + sdtotal + ", Objectives: " + objtotal
    );
  }

  get countA() {
    let total = 0;
    this.gridData.forEach((entry) => (total += entry._children.length));
    // this.gridData._children._children.forEach(
    //   (entry) => (grandtotal += entry._children.length)
    // );
    return total;
  }

  get countB() {
    let x = [];
    let y = [];
    let grandtotal = 0;

    for (let i = 0; i < this.gridData.length; i++) {
      x = this.gridData[i]._children;
      console.log("zzzzzz" + x.length);
      for (let j = 0; j < x.length; j++) {
        y = x[j]._children;
        grandtotal += y.length;
      }
      return grandtotal;
    }
  }

  handleFilterKeyInput(event) {
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
    console.log("calling filter with parameter " + this.searchValue);
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
    this.template.querySelector('lightning-input[data-name="search"]').value =
      "";
    this.template.querySelector('lightning-input[data-name="filter"]').value =
      "";

    this.gridData = this.initData;
    this.allData = this.initData;
  }
}
