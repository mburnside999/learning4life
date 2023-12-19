/**************************************************************
 * @name l4lCreateIncidentData
 * @author Mike Burnside
 * @date	2022
 * @group Learning For Life
 *
 * @description	LWC to manage session incidents
 * Uses the Nebula logging framework
 */

import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";

//debugging
const COMPONENT = "LWC: l4lCreateIncidentData";
const TAG = "L4L-Manage-Session-Incidents";
const COLOR = "color:purple"; //for console log formatting
const SCENARIO = "Record session incidents - LWC"; //for console log formatting
const UI_EVENT_TRACKING_SCENARIO =
  "l4lCreateIncidentData LWC UI Event Tracking";
export default class L4lCreateIncidentData extends LightningElement {
  @api lwcTitle="Create Incidental Data";
  @api recordId = "a3N2v000003Gr4VEAS"; //session 31 for testing
  @track showStartBtn = true;
  @track timeVal = "00:00:00";
  timeIntervalInstance;
  totalMilliseconds = 0;
  rendered = false;

  renderedCallback() {}

  /*******************************************************************************************************
   * @name ConnectedCallback
   * @description
   * Sets up logging
   *
   *
   * @param
   * @return
   */
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
        logInfo(
          this.recordId,
          `${COMPONENT}: connectedCallback`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking
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

  /*******************************************************************************************************
   * @name hrs
   * @description getter, returns hours part of timeVal
   *
   * @param
   * @return  integer, hours part of timeVal
   */

  get hrs() {
    return parseInt(this.timeVal.substring(0, 2));
  }

  /*******************************************************************************************************
   * @name hrs
   * @description getter, returns minutes part of timeVal
   *
   * @param
   * @return  integer, minutes part of timeVal
   */

  get mins() {
    return parseInt(this.timeVal.substring(3, 5));
  }

  /*******************************************************************************************************
   * @name secs
   * @description getter, returns seconds part of timeVal
   *
   * @param
   * @return  integer, seconds part of timeVal
   */
  get secs() {
    return parseInt(this.timeVal.substring(6, 8));
  }

  /*******************************************************************************************************
   * @name start
   * @description onclick handler for Start button
   * Starts timer
   * @param event
   * @return
   */

  start(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: Button: Start Timer`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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

  /*******************************************************************************************************
   * @name stop
   * @description onclick handler for Stop button
   * Stops timer
   * @param event
   * @return
   */
  stop(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: Button: Stop Timer`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    logDebug(this.recordId, `${COMPONENT}.stop()`, `${SCENARIO}`, `${TAG}`);
    this.showStartBtn = true;
    clearInterval(this.timeIntervalInstance);
  }

  /*******************************************************************************************************
   * @name reset
   * @description onclick handler for Reset button
   * Resets timer
   * @param event
   * @return
   */
  reset(event) {
    logDebug(this.recordId, `${COMPONENT}.reset()`, `${SCENARIO}`, `${TAG}`);
    console.info(`%creset(): entering`, COLOR);
    this.showStartBtn = true;
    this.timeVal = "00:00:00";
    this.totalMilliseconds = 0;
    clearInterval(this.timeIntervalInstance);
  }

  /*******************************************************************************************************
   * @name pad
   * @description pads single digit time elements with as leading zero
   *
   * @param val
   * @return  padded time element
   */

  pad(val) {
    var valString = val + "";
    if (valString.length < 2) {
      return "0" + valString;
    } else {
      return valString;
    }
  }

  /*******************************************************************************************************
   * @name handleSuccess
   * @description onsuccess handler for the lightning-record-edit-form
   *
   * @param event
   * @return
   */

  handleSuccess(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: Button: Create`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

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

  /*******************************************************************************************************
   * @name handleClickClose
   * @description onclick handler for the Close button
   *
   * @param event
   * @return
   */
  handleClickClose(event) {
    this.dispatchEvent(new CustomEvent("close"));
  }
}
