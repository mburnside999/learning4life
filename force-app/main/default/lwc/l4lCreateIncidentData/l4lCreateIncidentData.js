/**************************************************************
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	....
 *
 */

import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";

//debugging
const COMPONENT = "l4lCreateIncidentData";
const TAG = "L4L-Manage-Session-Incidents";
const COLOR = "color:purple"; //for console log formatting
const SCENARIO = "Record session incidents"; //for console log formatting

export default class L4lCreateIncidentData extends LightningElement {
  @api recordId = "a3N2v000003Gr4VEAS"; //session 31 for testing
  @track showStartBtn = true;
  @track timeVal = "00:00:00";
  timeIntervalInstance;
  totalMilliseconds = 0;
  rendered = false;

  renderedCallback() {}

  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback(): error: ${JSON.stringify(error)} `,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  get hrs() {
    return parseInt(this.timeVal.substring(0, 2));
  }
  get mins() {
    return parseInt(this.timeVal.substring(3, 5));
  }
  get secs() {
    return parseInt(this.timeVal.substring(6, 8));
  }

  start(event) {
    logDebug(this.recordId, `${COMPONENT}.start()`, `${SCENARIO}`, `${TAG}`);

    this.showStartBtn = false;
    var parentThis = this;

    // Run timer code in every 100 milliseconds
    this.timeIntervalInstance = setInterval(() => {
      // Time calculations for hours, minutes, seconds and milliseconds
      var hours = Math.floor(
        (parentThis.totalMilliseconds % (1000 * 60 * 60 * 24)) /
          (1000 * 60 * 60)
      );
      var minutes = Math.floor(
        (parentThis.totalMilliseconds % (1000 * 60 * 60)) / (1000 * 60)
      );
      var seconds = Math.floor(
        (parentThis.totalMilliseconds % (1000 * 60)) / 1000
      );

      // Output the result in the timeVal variable
      parentThis.timeVal =
        parentThis.pad(hours) +
        ":" +
        parentThis.pad(minutes) +
        ":" +
        parentThis.pad(seconds);
      parentThis.totalMilliseconds += 1000;
    }, 1000);
  }

  stop(event) {
    logDebug(this.recordId, `${COMPONENT}.stop()`, `${SCENARIO}`, `${TAG}`);
    this.showStartBtn = true;
    clearInterval(this.timeIntervalInstance);
  }

  reset(event) {
    logDebug(this.recordId, `${COMPONENT}.reset()`, `${SCENARIO}`, `${TAG}`);
    console.info(`%creset(): entering`, COLOR);
    this.showStartBtn = true;
    this.timeVal = "00:00:00";
    this.totalMilliseconds = 0;
    clearInterval(this.timeIntervalInstance);
  }

  pad(val) {
    var valString = val + "";
    if (valString.length < 2) {
      return "0" + valString;
    } else {
      return valString;
    }
  }

  handleSuccess(event) {
    // this.logit(
    //   INFO,
    //   `${COMPONENT}.handleSuccess(): in handleSuccess()`,
    //   `${COMPONENT}.handleSuccess()`,
    //   this.recordId
    // );

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSuccess() - successfully saved incident`,
      `${SCENARIO}`,
      `${TAG}`
    );
    const evt = new ShowToastEvent({
      title: "Success",
      message: "Incidental Data recorded",
      variant: "success"
    });
    this.dispatchEvent(evt);
  }

  handleClickCancel(event) {
    this.dispatchEvent(new CustomEvent("close"));
  }
}
