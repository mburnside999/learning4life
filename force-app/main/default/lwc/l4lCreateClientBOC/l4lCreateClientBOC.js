import { LightningElement, api, wire, track } from "lwc";
import getUnusedBOC from "@salesforce/apex/L4LController.getUnusedBOC";
import createClientBOCByArray from "@salesforce/apex/L4LController.createClientBOCByArray";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";

// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LMessageChannel__c";

//debugging
const COMPONENT = "LWC: l4lCreateClientBOC";

const TAG = "L4L-Manage-Client-BOC";
const COLOR = "color:green"; //for console log formatting
const SCENARIO = "Create Client BOC - LWC";
const UI_EVENT_TRACKING_SCENARIO = "l4lCreateClientBOC LWC UI Event Tracking";

const APEX_EVENT_TRACKING_SCENARIO =
  "l4lCreateClientBOC LWC APEX Event Tracking";

const columns = [{ label: "Name", fieldName: "Name", type: "text" }];

/**************************************************************
 * @name l4lCreateClientObjectives
 * @author Mike Burnside
 * @date	2022
 * @group Learning For Life
 * @extends LightningElement
 *
 * @description	LWC to create client objectives.
 * Used typically as a modal from a button on the ClientObjectives record page.
 * Provides filtering, searching and a list of "popular" objectives (those in use by other clients)
 * Uses the Nebula logging framework, and the Lightning Message Service
 */

export default class L4lCreateClientBOC extends LightningElement {
  @wire(MessageContext) messageContext;
  @api recordId = "0012v00002fY86nAAC"; //Andy
  @wire(CurrentPageReference) pageRef;
  @track allBOC = {};
  @wire(getUnusedBOC, { clientId: "$recordId" }) boc;

  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;

  disableButton = false;

  /*******************************************************************************************************
   * @name ConnectedCallback
   * @description Set up logging
   * Do the initial query
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
          `${COMPONENT}: connectedCallback()`,
          `${UI_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, initializing data by calling refresh`,
          `${SCENARIO}`,
          `${TAG}`
        );
        this.refresh();
      })
      .catch((error) => {
        console.log("Error");
      });
  }

  /*******************************************************************************************************
   * @name resultmessage
   * @description a custom getter - constructs a text string for display on the UI as {resultmessage}
   *
   * @param
   * @return
   */

  get resultmessage() {
    return this.boc.length > 0 ? `${this.boc.length} records returned.` : "";
  }

  /*******************************************************************************************************
   * @name refresh
   * @description main refresh method.
   * Finds unused client objectives via callout to Apex getUnusedBOC passing this.searchValue
   * @param
   * @return
   *
   */

  refresh() {
    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling Apex getUnusedBOC`,
      `${SCENARIO}`,
      `${TAG}`
    );

    console.info(`%crefresh(): entering`, COLOR);
    console.debug(`%crefresh(): calling Apex getUnusedBOC`, COLOR);
    console.debug(`%crefresh(): parameter clientId=${this.recordId}`, COLOR);

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LController.getUnusedBOC`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    getUnusedBOC({
      clientId: this.recordId
    })
      .then((result) => {
        console.log(JSON.stringify(result));
        this.boc = result;
        this.allBOC = result;
        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getUnusedBOC returned result=${JSON.stringify(
            result
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .catch((error) => {
        this.error = error;
        logError(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getUnusedBOC error=${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
  }

  /*******************************************************************************************************
   * @name getSelectedName
   * @description handler for lightning-datatable onrowselection
   * @param event, the event sent from the datatable
   * @return
   *
   */

  getSelectedName(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.getSelectedName() bound to lightning-datatable onrowselection `,
      `${SCENARIO}`,
      `${TAG}`
    );

    this.selectedRows = event.detail.selectedRows;

    logDebug(
      this.recordId,
      `${COMPONENT}.getSelectedName() getSelectedName(): this.selectedRows=${JSON.stringify(
        this.selectedRows
      )}`,
      `${SCENARIO}`,
      "next-gen-LWC-nebula"
    );
  }

  /*******************************************************************************************************
   * @name handleClickArray
   * @description handler for the Create Client Objectives button.
   * Creates Client Objectives  via call to Apex createClientObjectivesByArray, passing a JSON array of selected records.
   * Calls refresh() after creating the Client Objectives which effectively makes them disappear as they are
   * now assigned.
   * Publishes to the L4LMC MessageChannel
   * @param event, the event sent from the button
   * @return
   *
   */

  handleClickArray(event) {
    this.disableButton = true;

    logInfo(
      this.recordId,
      `${COMPONENT}: DataTable MultiRow Button: Create Client BOC`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): entering method, bound to lightning-button Create Client BOC`,
      `${SCENARIO}`,
      "next-gen-LWC-nebula"
    );
    if (this.selectedRows) {
      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): jsonstr=selectedRows=${JSON.stringify(
          this.selectedRows
        )}, clientId=${this.recordId}`,
        `${SCENARIO}`,
        "next-gen-LWC-nebula"
      );

      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): imperative Call to Apex createClientObjectivesByArray`,
        `${SCENARIO}`,
        "next-gen-LWC-nebula"
      );

      console.log(JSON.stringify(this.selectedRows));

      logInfo(
        this.recordId,
        `${COMPONENT}: Apex Call: L4LController.createClientBOCByArray`,
        `${APEX_EVENT_TRACKING_SCENARIO}`,
        `${TAG}`
      ); // adoption tracking

      createClientBOCByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        clientId: this.recordId
      })
        .then((result) => {
          this.recordsProcessed = result;
          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray():handleClickArray(): Apex createClientBOCByArray this.recordsProcessed=${result}`,
            `${SCENARIO}`,
            "next-gen-LWC-nebula"
          );
        })
        .then(() => {
          console.debug(`????????? what does this .then do ???`, COLOR);
        })
        .then(() => {
          this.showNotification(
            "Success",
            `${this.recordsProcessed} records processed.`,
            "success"
          );

          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray():setting this.boc=null, calling refresh() `,
            `${SCENARIO}`,
            "next-gen-LWC-nebula"
          );
          let inp = this.template.querySelector("input");
          inp.value = "";
          this.refresh();
        })
        .catch((error) => {
          this.error = error;
          this.showNotification(
            "An error occurred when creating Client Objectives. ",
            `Error: Limit exceeded (100 records) or client objective is already assigned `,
            "error"
          );
        })
        .finally(() => {
          this.disableButton = false;
          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray():publishing LMS event`,
            `${SCENARIO}`,
            "next-gen-LWC-nebula"
          );
          const message = {
            recordId: "",
            message: "message from l4lCreateClientObjectives",
            source: "LWC",
            recordData: {}
          };

          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray():Sending message via L4LMC, message=${JSON.stringify(
              message
            )}`,
            `${SCENARIO}`,
            "next-gen-LWC-nebula"
          );

          publish(this.messageContext, L4LMC, message);

          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray():published ${JSON.stringify(
              message
            )} to L4LMC`,
            `${SCENARIO}`,
            "next-gen-LWC-nebula"
          );
        })
        .catch((error) => {
          this.error = error;

          logError(
            this.recordId,
            `${COMPONENT}.handleClickArray():Error ${JSON.stringify(error)}`,
            `${SCENARIO}`,
            "next-gen-LWC-nebula"
          );
        });
    }
  }

  /*******************************************************************************************************
   * @name handleFilterKeyInput
   * @description Filters the list of objectives on Name,Program and SD
   * @param event, the event sent from oninput on the filter input HTML element
   * @return
   *
   */

  handleFilterKeyInput(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleFilteKeyInput(): entering method`,
      `${SCENARIO}`,
      "next-gen-LWC-nebula"
    );
    const filterKey = event.target.value.toLowerCase();

    this.boc = this.allBOC.filter((so) =>
      so.Name.toLowerCase().includes(filterKey)
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.handleFilterKeyInput(): this.boc=${JSON.stringify(
        this.boc
      )}`,
      `${SCENARIO}`,
      "next-gen-LWC-nebula"
    );
  }

  /*******************************************************************************************************
   * @name showNotification
   * @description helper to fire Toast notifications
   * @param t, the title
   * @param m, the message
   * @param v, variant
   *
   */

  showNotification(t, m, v) {
    logDebug(
      this.recordId,
      `${COMPONENT}.showNotification(): entering method, t=${t}, m=${m}, v=${v}`,
      `${SCENARIO}`,
      "next-gen-LWC-nebula"
    );
    const evt = new ShowToastEvent({
      title: t,
      message: m,
      variant: v
    });
    this.dispatchEvent(evt);
  }

  /*******************************************************************************************************
   * @name handleClickClose
   * @description handler for the Cancel button on the UI
   * @param event
   *
   */

  handleClickClose(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: Button: Close`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickClose(): dispatching CustomEvent(close)`,
      `${SCENARIO}`,
      "next-gen-LWC-nebula"
    );
    this.dispatchEvent(new CustomEvent("close"));
  }
}
