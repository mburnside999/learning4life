import { LightningElement, wire } from "lwc";
import getJSONTree from "@salesforce/apex/LFLTreeUtil.getJSONTree";

import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";
export default class LflTreeView extends LightningElement {
  treeview = [];
  @wire(getJSONTree, { reserved: "x" })
  wiredJSON(value) {
    console.log("yyyyyyyy");
    const { data, error } = value;
    console.log("zzzzzzzzzz" + JSON.stringify(value));
    if (data) {
      console.log("xxxxxxxxx");
      console.log(data);
      this.treeview = JSON.parse(data);
      this.error = undefined;
    } else if (error) {
      this.error = error;
      this.treeview = undefined;
    }
  }
}
