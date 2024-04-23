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
    fieldName: "identifier",
    label: "Catalog Ref."
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

// set a upper limit for filtering
const MAX_FILTER_RECORDS = 500;

export default class LflTreeView extends LightningElement {
  gridData = [];
  allData = [];
  initData = [];

  gridColumns = COLUMNS;
  @api lwcTitle = "Catalog Browser";
  @api isLoaded = false;
  totalobjectives;
  showFilter;

  @wire(getJSONTree, { reserved: "reserved" })
  wiredJSON(value) {
    const { data, error } = value;
    if (data) {
      console.log(data);
      this.gridData = JSON.parse(data);
      this.allData = JSON.parse(data);
      this.initData = JSON.parse(data);
      //this.displayGridLengths("XXXX @wire");

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

  get resultSize() {
    return this.gridData.length;
  }

  get disableFilter() {
    if (this.totalobjectives > MAX_FILTER_RECORDS) {
      console.log(`more than ${MAX_FILTER_RECORDS} records, disabling filter.`);
      return true;
    } else {
      return false;
    }
  }

  get catalogShape() {
    let _sdarray = [];
    let _objarray = [];
    let _totalprogs = this.gridData.length;
    let _totalsds = 0;
    let _totalobjectives = 0;

    for (let i = 0; i < _totalprogs; i++) {
      _sdarray = this.gridData[i]._children;
      _totalsds += _sdarray.length;
      for (let j = 0; j < _sdarray.length; j++) {
        _objarray = _sdarray[j]._children;
        _totalobjectives += _objarray.length;
      }
    }
    console.log("_totalprogs=" + _totalprogs);
    console.log("_totalsds=" + _totalsds);
    console.log("_totalobjectives=" + _totalobjectives);
    this.totalobjectives = _totalobjectives;
    return (
      "Displaying " +
      _totalprogs +
      " Programs, " +
      _totalsds +
      "  SDs, " +
      _totalobjectives +
      " Objectives"
    );
  }

  handleFilterKeyInput(event) {
    const lightning_tree_grid = this.template.querySelector(
      "lightning-tree-grid"
    );
    lightning_tree_grid.collapseAll();
    this.gridData = JSON.parse(JSON.stringify(this.allData));
    const filterKey = event.target.value;
    if (filterKey.length == 0) {
      this.gridData = JSON.parse(JSON.stringify(this.allData));
    }

    let searchString = filterKey;
    console.log("looking for searchstring= " + searchString);

    let _programs = [];
    _programs = this.gridData;

    let _program;
    let _sds;
    let _sd;
    let _obj;
    let _objectives;

    //keep flags
    let _keepprogram;
    let _keepsd;

    //arrays
    let _progarray = [];
    let _sdarray = [];
    let _objarray = [];

    for (let i = 0; i < _programs.length; i++) {
      _keepsd = false;
      _keepprogram = false;
      _program = _programs[i];

      _sds = _program._children;
      _sdarray = [];
      for (let x = 0; x < _sds.length; x++) {
        _sd = _sds[x];
        if (_sd.name.includes(searchString)) {
          _keepprogram = true;
        }

        console.log("==> sd: " + _sd.name);
        _keepsd = false;
        _objectives = _sd._children;
        _objarray = [];
        for (let y = 0; y < _objectives.length; y++) {
          _obj = _objectives[y];
          console.log("candidate: " + JSON.stringify(_obj));
          //console.log('considering ' + obj.name);
          if (_obj.name.toLowerCase().includes(searchString.toLowerCase())) {
            console.log(
              "y=" +
                y +
                " LEAF MATCH! leaf contains obj: " +
                _obj.name +
                " setting _keepsd=true and _keepprogram=true"
            );
            _keepsd = true;
            _keepprogram = true;
          } else {
            console.log(
              "y=" +
                y +
                " NO LEAF MATCH, pushing leaf to objarray -  " +
                _obj.name +
                ", currently _keepsd=" +
                _keepsd +
                " _keepprogram=" +
                _keepprogram
            );
            _objarray.push(y);
          }
        }

        let _reversedobjectarray = [];
        for (let o = _objarray.length - 1; o >= 0; o--) {
          const valueAtIndex = _objarray[o];
          _reversedobjectarray.push(valueAtIndex);
        }

        for (let o = 0; o < _reversedobjectarray.length; o++) {
          let _ref = _reversedobjectarray[o];
          //console.log("splicing " + JSON.stringify(sds[x]._children[ref]));
          _programs[i]._children[x]._children.splice(_ref, 1);
          this.gridData = _programs;
        }

        console.log("Parent Analysis");
        console.log("currently _keepsd = " + _keepsd);

        if (!_keepsd) {
          console.log("_keepsd is FALSE");
          if (_sds[x].name.toLowerCase().includes(searchString.toLowerCase())) {
            _keepsd = true;
            _keepprogram = true;
          } else {
            _keepsd = false;
          }
        }

        //sdkeep still false
        if (_keepsd == false) {
          _sdarray.push(x);
        } else {
        }
      }

      let _reversedsdarray = [];
      for (let o = _sdarray.length - 1; o >= 0; o--) {
        const valueAtIndex = _sdarray[o];
        _reversedsdarray.push(valueAtIndex);
      }
      console.log("_reversedsdarray=" + _reversedsdarray);
      for (let sd = 0; sd < _reversedsdarray.length; sd++) {
        let ref = _reversedsdarray[sd];
        console.log("splice " + JSON.stringify(_sds[ref]));
        _programs[i]._children.splice(ref, 1);
        this.gridData = _programs;
      }

      if (
        this.gridData[i].name.toLowerCase().includes(searchString.toLowerCase())
      ) {
        _keepprogram = true;
      }

      if (_keepprogram == false) {
        _progarray.push(i);
      }
    }

    let _reversedprogarray = [];

    for (let p = _progarray.length - 1; p >= 0; p--) {
      const valueAtIndex = _progarray[p];
      _reversedprogarray.push(valueAtIndex);
    }

    console.log("reversed progarray=" + _reversedprogarray);

    for (let p = 0; p < _reversedprogarray.length; p++) {
      let _progref = _reversedprogarray[p];
      _programs.splice(_progref, 1);
      this.gridData = _programs;
    }

    this.gridData = _programs.filter((so) => {
      //fakery to get a ui refresh
      return (
        so.name == null || so.name.toLowerCase().includes(so.name.toLowerCase())
      );
    });
  }

  handleSearchKeyword() {
    this.template.querySelector('lightning-input[data-name="filter"]').value =
      "";
    console.log("calling search with parameter " + this.searchValue);
    //this.displayGridLengths("XXXXX entry to handleSearch");
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
        this.gridData = JSON.parse(result);
        this.allData = JSON.parse(result);
        //this.displayGridLengths("XXXXX after getJSONFiltered in handleSearch");
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
    const lightning_tree_grid = this.template.querySelector(
      "lightning-tree-grid"
    );
    lightning_tree_grid.collapseAll();

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

    this.gridData = JSON.parse(JSON.stringify(this.initData));
    this.allData = JSON.parse(JSON.stringify(this.initData));

    this.isLoaded = true;
    //this.displayGridLengths("XXXXX after getJSONTree in handleReset");
  }

  //debugging helper
  displayGridLengths(str) {
    console.log(str + ": initData.length=" + this.initData.length);
    console.log(str + ": gridData.length=" + this.gridData.length);
    console.log(str + ": allData.length=" + this.allData.length);
  }

  handleCollapse(event) {
    const grid = this.template.querySelector("lightning-tree-grid");
    grid.collapseAll();
  }

  handleExpand(event) {
    const grid = this.template.querySelector("lightning-tree-grid");
    grid.expandAll();
  }
}
