import { LightningElement, api } from "lwc";

import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import warnLog from "@salesforce/apex/L4LNebulaComponentController.logWarning";
import debugLog from "@salesforce/apex/L4LNebulaComponentController.logDebug";

export default class LflNextGenNebulaLogger extends LightningElement {
  @api recordId;

  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
      })
      .catch((error) => {
        console.log("Error");
      });
  }

  logDebug(message, scenario, tag) {
    debugLog({
      recordId: this.recordId,
      message: message,
      scenario: scenario,
      tag: tag
    })
      .then((returnVal) => {
        console.log("Success");
      })
      .catch((error) => {
        console.log("Error");
      });
  }

  handleClick(event) {
    this.logDebug(
      "clicked message1",
      "LflNextGenNebulaLogger.handleClick()",
      "my tag"
    );
  }

  handleClick2(event) {}
}
