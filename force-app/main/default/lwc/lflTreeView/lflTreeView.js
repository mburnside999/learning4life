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
  allData = [];
  initData = [];

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
      this.allData = JSON.parse(data);
      this.initData = JSON.parse(data);
      this.displayGridLengths("XXXX @wire");

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

  get grid() {
    return this.gridData;
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
    //const filterKey = event.target.value.toLowerCase();
    const filterKey = event.target.value;
    this.displayGridLengths("XXXX handleFilterKey");
    //this.gridData = this.allData;
    if (filterKey.length == 0) {
      this.displayGridLengths("XXXX filterkey length 0");
      // if (this.searchValue) {
      //   this.handleSearchKeyword();
      // }
      this.gridData = JSON.parse(JSON.stringify(this.allData));
    }

    console.log("CATALOG");

    let searchString = filterKey;

    console.log("looking for " + searchString);
    let programs = [];
    //test
    programs = this.gridData;
    // programs = JSON.parse(JSON.stringify(this.allData));

    let program;
    let sds;
    let sd;
    let obj;
    let objectives;

    let progkeep;
    let sdkeep;
    let progarray = [];
    let sdarray = [];
    let objarray = [];

    for (let i = 0; i < programs.length; i++) {
      sdkeep = false;
      progkeep = false;
      program = programs[i];
      console.log("\nprogram: " + program.name);

      sds = program._children;
      sdarray = [];
      for (let x = 0; x < sds.length; x++) {
        sd = sds[x];
        if (sd.name.includes(searchString)) {
          progkeep = true;
        }

        console.log("==> sd: " + sd.name);
        sdkeep = false;
        objectives = sd._children;
        objarray = [];
        for (let y = 0; y < objectives.length; y++) {
          obj = objectives[y];
          console.log("candidate: " + JSON.stringify(obj));
          //console.log('considering ' + obj.name);
          if (obj.name.toLowerCase().includes(searchString.toLowerCase())) {
            console.log(
              "y=" +
                y +
                " LEAF MATCH! leaf contains obj: " +
                obj.name +
                " setting sdkeep=true and progkeep=true"
            );
            sdkeep = true;
            progkeep = true;
          } else {
            console.log(
              "y=" +
                y +
                " NO LEAF MATCH, pushing leaf to objarray -  " +
                obj.name +
                ", currently sdkeep=" +
                sdkeep +
                " progkeep=" +
                progkeep
            );
            objarray.push(y);
          }
        }

        //console.log("Process object deletions,obj array = " + objarray);
        //console.log("Reversing...");

        let reversedobjectarray = [];

        for (let o = objarray.length - 1; o >= 0; o--) {
          const valueAtIndex = objarray[o];
          reversedobjectarray.push(valueAtIndex);
        }

        //console.log("reversedobjectarray=" + reversedobjectarray);

        for (let o = 0; o < reversedobjectarray.length; o++) {
          let ref = reversedobjectarray[o];
          //console.log("splicing " + JSON.stringify(sds[x]._children[ref]));
          programs[i]._children[x]._children.splice(ref, 1);
          this.gridData = programs;
        }

        console.log("Parent Analysis");
        console.log("currently sdkeep = " + sdkeep);

        if (!sdkeep) {
          console.log("sdkeep is FALSE");
          if (sds[x].name.toLowerCase().includes(searchString.toLowerCase())) {
            sdkeep = true;
            progkeep = true;

            // //console.log(
            //   "PARENT found, will keep sd, adjusted keep values: " +
            //     sds[x].name +
            //     " has searchString, sdkeep=" +
            //     sdkeep +
            //     " progkeep=" +
            //     progkeep
            // );
          } else {
            sdkeep = false;
            //console.log(
            //"PARENT " + sds[x].name + " does not contain " + searchString
            //);
          }
        }

        //sdkeep still false
        if (sdkeep == false) {
          //console.log("SD SPLICE" + this.gridData[i]._children[x].name);
          //console.log("SD SPLICE pushing _children[" + x + "] to sdarray");
          sdarray.push(x);
        } else {
          //console.log("Keeping " + programs[i]._children[x].name);
        }
      }

      //console.log("Process SD deletions, sdarray = " + sdarray);

      //console.log("Reversing...");

      let reversedsdarray = [];

      for (let o = sdarray.length - 1; o >= 0; o--) {
        const valueAtIndex = sdarray[o];
        reversedsdarray.push(valueAtIndex);
      }
      console.log("reversedsdarray=" + reversedsdarray);

      for (let sd = 0; sd < reversedsdarray.length; sd++) {
        let ref = reversedsdarray[sd];
        console.log("splice " + JSON.stringify(sds[ref]));
        programs[i]._children.splice(ref, 1);
        this.gridData = programs;
      }

      if (
        this.gridData[i].name.toLowerCase().includes(searchString.toLowerCase())
      ) {
        //console.log("Program name contains search string, keeping");
        progkeep = true;
      }

      if (progkeep == false) {
        progarray.push(i);
      }
    }

    //console.log("Process Program deletions, progarray = " + progarray);
    //console.log("Reversing...");

    let reversedprogarray = [];

    for (let p = progarray.length - 1; p >= 0; p--) {
      const valueAtIndex = progarray[p];
      reversedprogarray.push(valueAtIndex);
    }

    console.log("reversed progarray=" + reversedprogarray);

    for (let p = 0; p < reversedprogarray.length; p++) {
      let ref = reversedprogarray[p];
      // console.log("SPLICING PROG" + JSON.stringify(programs[ref]));
      programs.splice(ref, 1);
      this.gridData = programs;
    }

    //   console.log("this.gridData.length=" + this.gridData.length);
    //   console.log("programs.length=" + programs.length);
    //   console.log(JSON.stringify(programs));
    //   console.log("this.gridData=programs");
    //   this.gridData = programs;
    // console.log("this.gridData.length=" + this.gridData.length);
    //console.log("this.gridData" + JSON.stringify(this.gridData));
    this.displayGridLengths("XXXXX in program splicing");
    //this.dispatchEvent(new RefreshEvent());
    //
    //this.dataGrid = programs.filter((so) => so.name != null);
    this.gridData = programs.filter((so) => {
      //fakery to get a ui refresh
      return (
        so.name == null || so.name.toLowerCase().includes(so.name.toLowerCase())
      );
    });
    // console.log("@filter initData.length=" + this.initData.length);
    // console.log("@filter gridData.length=" + this.gridData.length);
    // console.log("@filter allData.length=" + this.allData.length);
    //
    // }
  }

  handleSearchKeyword() {
    console.log("calling search with parameter " + this.searchValue);
    this.displayGridLengths("XXXXX entry to handleSearch");
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
        this.allData = JSON.parse(result);
        this.displayGridLengths("XXXXX after getJSONFiltered in handleSearch");
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
    this.template.querySelector('lightning-input[data-name="filter"]').value =
      "";
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
    //this.isLoaded = false;
    getJSONTree({
      searchStr: "reserved"
    })
      .then((result) => {
        // set @track contacts variable with return contact list from server
        // this.logit(
        //   FINE,
        //   `handleSearchKeyword(): result=${JSON.stringify(result)}`,
        //   `handleSearchKeyword()`
        // );
        this.gridData = JSON.parse(result);
        this.allData = JSON.parse(result);
        this.initData = JSON.parse(result);
        this.displayGridLengths("XXXXX after getJSONTree in handleReset");
        //this.isloaded = true;
      })
      .catch((error) => {
        const event = new ShowToastEvent({
          title: "Error",
          variant: "error",
          message: error.body.message
        });
        this.dispatchEvent(event);
        // reset contacts var with null
      })
      .finally(() => {
        //this.isLoaded = true;
        this.template.querySelector(
          'lightning-input[data-name="search"]'
        ).value = "";
        this.template.querySelector(
          'lightning-input[data-name="filter"]'
        ).value = "";
      });
  }

  displayGridLengths(str) {
    console.log(str + ": initData.length=" + this.initData.length);
    console.log(str + ": gridData.length=" + this.gridData.length);
    console.log(str + ": allData.length=" + this.allData.length);
  }
}
