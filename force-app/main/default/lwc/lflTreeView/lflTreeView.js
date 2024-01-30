import { LightningElement, api, wire } from "lwc";
import getJSONTree from "@salesforce/apex/LFLTreeUtil.getJSONTree";

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
  gridColumns = COLUMNS;
  @api lwcTitle = "Catalog Browser";

  @wire(getJSONTree, { reserved: "x" })
  wiredJSON(value) {
    const { data, error } = value;
    if (data) {
      console.log(data);
      this.gridData = JSON.parse(data);
      this.allData = this.gridData;
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.gridData = undefined;
    }
  }

  handleFilterKeyInput(event) {
    const filterKey = event.target.value.toLowerCase();

    this.gridData = this.allData.filter((so) =>
      so.name.toLowerCase().includes(filterKey)
    );
  }
}
