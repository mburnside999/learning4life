import { LightningElement, api, wire, track } from "lwc";
import getUnusedObjectives from "@salesforce/apex/L4LController.getUnusedObjectives";
import getUnusedObjectivesBySearch from "@salesforce/apex/L4LController.getUnusedObjectivesBySearch";
import createClientObjectivesByArray from "@salesforce/apex/L4LController.createClientObjectivesByArray";
import getPopularObjectives from "@salesforce/apex/L4LController.getPopularObjectives";
import { logDebug, logInfo, logError } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { CurrentPageReference } from "lightning/navigation";

// Lightning Message Service
import { publish, MessageContext } from "lightning/messageService";
import L4LMC from "@salesforce/messageChannel/L4LMessageChannel__c";

//debugging
const COMPONENT = "LWC: l4lCreateClientObjectives";

const TAG = "L4L-Manage-Client-Objectives";
const COLOR = "color:green"; //for console log formatting
const SCENARIO = "Create Client Objectives - LWC";
const UI_EVENT_TRACKING_SCENARIO =
  "l4lCreateClientObjectives LWC UI Event Tracking";

const APEX_EVENT_TRACKING_SCENARIO =
  "l4lCreateClientObjectives LWC APEX Event Tracking";
const columns = [
  { label: "Program", fieldName: "Program__c", type: "text" },
  { label: "SD", fieldName: "SD_Name__c", type: "text" },
  { label: "Objective", fieldName: "Name", type: "text" }
];

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

export default class L4lCreateClientObjectives extends LightningElement {
  @wire(MessageContext) messageContext;
  @api recordId = "0012v00002fY86nAAC"; //Andy
  @wire(CurrentPageReference) pageRef;
  @track allObjectives = {};
  @wire(getUnusedObjectives, { clientId: "$recordId" }) objectives;
  @track error;
  @track columns = columns;
  @track recordsProcessed = 0;
  isLoading = false;
  showPopular = true;
  disableButton = false;

  /*******************************************************************************************************
   * @name ConnectedCallback
   * @description Set up logging
   * Do the initial query for popular objectives using local function getPopularClientObjectives()
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
          `${COMPONENT}: Apex Call: @wire L4LController.getUnusedObjectives`,
          `${APEX_EVENT_TRACKING_SCENARIO}`,
          `${TAG}`
        ); // adoption tracking

        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, initializing data by calling getPopularClientObjectives()`,
          `${SCENARIO}`,
          `${TAG}`
        );
        this.getPopularClientObjectives();
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
    logDebug(
      this.recordId,
      `${COMPONENT}.resultmessage(): tailoring a result message for display`,
      `${SCENARIO}`,
      `${TAG}`
    );
    if (this.showPopular) {
      return this.objectives.length > 0
        ? `Showing a selection of POPULAR client objectives: ${this.objectives.length} records returned.`
        : "";
    } else {
      return this.objectives.length > 0
        ? `Search returned ${this.objectives.length} client objectives.`
        : "";
    }
  }

  /*******************************************************************************************************
   * @name refresh
   * @description main refresh method.
   * Finds unused client objectives via callout to Apex getUnusedbjectivesBySearch passing this.searchValue
   * @param
   * @return
   *
   */

  refresh() {
    this.isLoading = true;

    logDebug(
      this.recordId,
      `${COMPONENT}.refresh(): calling Apex getUnusedObjectivesBySearch`,
      `${SCENARIO}`,
      `${TAG}`
    );

    console.info(`%crefresh(): entering`, COLOR);
    console.debug(
      `%crefresh(): calling Apex getUnusedObjectivesBySearch`,
      COLOR
    );
    console.debug(`%crefresh(): parameter clientId=${this.recordId}`, COLOR);
    console.debug(
      `%crefresh(): parameter searchValue=${this.searchValue}`,
      COLOR
    );

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LController.getUnusedObjectivesBySearch`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    getUnusedObjectivesBySearch({
      clientId: this.recordId,
      searchstring: this.searchValue
    })
      .then((result) => {
        this.objectives = result;
        this.allObjectives = result;
        logDebug(
          this.recordId,
          `${COMPONENT}.refresh(): Apex getUnusedObjectivesBySearch returned result=${JSON.stringify(
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
          `${COMPONENT}.refresh(): Apex getUnusedObjectivesBySearch error=${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
    this.isLoading = false;
  }

  /*******************************************************************************************************
   * @name handleRefreshPopular
   * @description onclick handler for the Refresh Popular button
   * @param
   * @return
   *
   */

  handleRefreshPopular(event) {
    logInfo(
      this.recordId,
      `${COMPONENT}: Button: Refresh Popular`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    logDebug(
      this.recordId,
      `${COMPONENT}.handleRefreshPopular(): calling getPopularClientObjectives()`,
      `${SCENARIO}`,
      `${TAG}`
    );
    this.getPopularClientObjectives();
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
   * now assigned.  Also conditionally refreshes the "popular" list.
   * Publishes to the L4LMC MessageChannel
   * @param event, the event sent from the button
   * @return
   *
   */

  handleClickArray(event) {
    this.disableButton = true;

    logInfo(
      this.recordId,
      `${COMPONENT}: DataTable MultiRow Button: Create Client Objectives`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickArray(): entering method, bound to lightning-button Create Client Objectives`,
      `${SCENARIO}`,
      "next-gen-LWC-nebula"
    );
    if (this.selectedRows) {
      logDebug(
        this.recordId,
        `${COMPONENT}.handleClickArray(): jsonstr=selectedRows=${JSON.stringify(
          this.selectedRows
        )}, sess=${this.recordId}`,
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
        `${COMPONENT}: Apex Call: L4LController.createClientObjectivesByArray`,
        `${APEX_EVENT_TRACKING_SCENARIO}`,
        `${TAG}`
      ); // adoption tracking

      createClientObjectivesByArray({
        jsonstr: JSON.stringify(this.selectedRows),
        sess: this.recordId
      })
        .then((result) => {
          this.recordsProcessed = result;
          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray():handleClickArray(): Apex createClientObjectivesByArray this.recordsProcessed=${result}`,
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
            `${COMPONENT}.handleClickArray():setting this.objectives=null, calling refresh() `,
            `${SCENARIO}`,
            "next-gen-LWC-nebula"
          );
          let inp = this.template.querySelector("input");
          inp.value = "";

          logDebug(
            this.recordId,
            `${COMPONENT}.handleClickArray():handleClickArray(): this.showPopular=${this.showPopular}`,
            `${SCENARIO}`,
            "next-gen-LWC-nebula"
          );

          if (this.showPopular) {
            logDebug(
              this.recordId,
              `${COMPONENT}.handleClickArray():Yes, will show popular, calling this.getPopularClientObjectives()`,
              `${SCENARIO}`,
              "next-gen-LWC-nebula"
            );
            this.getPopularClientObjectives();
          } else {
            logDebug(
              this.recordId,
              `${COMPONENT}.handleClickArray():No, will not show popular, just calling this.refresh()`,
              `${SCENARIO}`,
              "next-gen-LWC-nebula"
            );
            this.refresh();
          }
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

    this.objectives = this.allObjectives.filter(
      (so) =>
        so.Name.toLowerCase().includes(filterKey) ||
        so.Program__c.toLowerCase().includes(filterKey) ||
        so.SD_Name__c.toLowerCase().includes(filterKey)
    );

    logDebug(
      this.recordId,
      `${COMPONENT}.handleFilterKeyInput(): this.objectives=${JSON.stringify(
        this.objectives
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

  /*******************************************************************************************************
   * @name handleSearchValueChange
   * @description bound to the onchange event for the lightning-input search field on the UI
   * Updates this.searchValue with the text typed into the input field
   * @param event
   *
   */

  handleSearchValueChange(event) {
    this.searchValue = event.target.value;
  }

  /*******************************************************************************************************
   * @name handleSearchKeyword
   * @description handler for the onchange event for the Search button on the UI.c/clientObjBoard
   * Finds unused client objectives via callout to Apex getUnusedbjectivesBySearch passing this.searchValue
   * @param
   *
   */
  handleSearchKeyword() {
    this.isLoading = true;

    logInfo(
      this.recordId,
      `${COMPONENT}: Button: Search`,
      `${UI_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    logDebug(
      this.recordId,
      `${COMPONENT}.handleSearchWord(): entering, bound to Search lightning-button.onclick - searchValue=${this.searchValue}`,
      `${SCENARIO}`,
      `${TAG}`
    );

    if (this.searchValue !== "") {
      logDebug(
        this.recordId,
        `${COMPONENT}.handleSearchKeyword(): calling getUnusedbjectivesBySearch, searchstring=${this.searchValue}`,
        `${SCENARIO}`,
        `${TAG}`
      );

      logInfo(
        this.recordId,
        `${COMPONENT}: Apex Call: L4LController.getUnusedObjectivesBySearch`,
        `${APEX_EVENT_TRACKING_SCENARIO}`,
        `${TAG}`
      ); // adoption tracking

      this.showPopular = false;
      getUnusedObjectivesBySearch({
        clientId: this.recordId,
        searchstring: this.searchValue
      })
        .then((result) => {
          // set @track contacts variable with return contact list from server
          // this.logit(
          //   FINE,
          //   `handleSearchKeyword(): result=${JSON.stringify(result)}`,
          //   `handleSearchKeyword()`
          // );
          logDebug(
            this.recordId,
            `${COMPONENT}.handleSearchKeyword(): result=${JSON.stringify(
              result
            )}`,
            `${SCENARIO}`,
            `${TAG}`
          );
          this.objectives = result;
          this.allObjectives = result;
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
    } else {
      // fire toast event if input field is blank
      const event = new ShowToastEvent({
        variant: "error",
        message: "Search text missing.."
      });
      this.dispatchEvent(event);
    }
    this.isLoading = false;
  }

  /*******************************************************************************************************
   * @name getPopularClientObjectives
   * @description calls Apex getPopularObjectives to find client objectives used for other clients
   * @param
   *
   */

  getPopularClientObjectives() {
    this.isLoading = true;
    this.searchValue = "";
    this.showPopular = true;

    logDebug(
      this.recordId,
      `${COMPONENT}.getPopularClientObjectives(): isLoading=${this.isLoading}, searchValue=${this.searchValue}, showPopular=${this.showPopular}, calling Apex getPopularObjectives`,
      `${SCENARIO}`,
      `${TAG}`
    );

    console.info(`%cgetPopularClientObjectives(): entering`, COLOR);
    console.debug(
      `%cgetPopularClientObjectives(): calling Apex getPopularObjectives`,
      COLOR
    );

    logInfo(
      this.recordId,
      `${COMPONENT}: Apex Call: L4LController.getPopularObjectives`,
      `${APEX_EVENT_TRACKING_SCENARIO}`,
      `${TAG}`
    ); // adoption tracking

    getPopularObjectives({
      clientId: this.recordId
    })
      .then((result) => {
        this.objectives = result;
        this.allObjectives = result;
        console.log(JSON.stringify(result));
        logDebug(
          this.recordId,
          `${COMPONENT}.getPopularClientObjectives(): Apex getPopularObjectives ${result.length} records returned`,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .catch((error) => {
        this.error = error;
        console.log(`ERROR: '+${JSON.stringify(error)}`);
        logError(
          this.recordId,
          `${COMPONENT}.getPopularClientObjectives(): getPopularObjectives errored: ${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });
    this.isLoading = false;
  }
}
