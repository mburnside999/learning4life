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
const COMPONENT = "l4lCreateClientObjectives";
const TAG = "L4L-Manage-Client-Objectives";
const COLOR = "color:green"; //for console log formatting
const SCENARIO = "Create Client Objectives";

const columns = [
  { label: "Program", fieldName: "Program__c", type: "text" },
  { label: "SD", fieldName: "SD_Name__c", type: "text" },
  { label: "Objective", fieldName: "Name", type: "text" }
];

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

  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
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

  //tailored result message on UI, depending on whether we are showing popular records or search results
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

  handleRefreshPopular(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleRefreshPopular(): calling getPopularClientObjectives()`,
      `${SCENARIO}`,
      `${TAG}`
    );
    this.getPopularClientObjectives();
  }

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

  handleClickArray(event) {
    this.disableButton = true;
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

  handleClickCancel(event) {
    logDebug(
      this.recordId,
      `${COMPONENT}.handleClickCancel(): dispatching CustomEvent(close)`,
      `${SCENARIO}`,
      "next-gen-LWC-nebula"
    );
    this.dispatchEvent(new CustomEvent("close"));
  }

  searchKeyword(event) {
    this.searchValue = event.target.value;
  }

  handleSearchKeyword() {
    this.isLoading = true;
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
        console.log(`ERROR XXXXXXXX '+${JSON.stringify(error)}`);
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
