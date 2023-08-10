import { LightningElement, wire, api } from "lwc";
import { logInfo } from "c/l4lNebulaUtil";
import setNewSession from "@salesforce/apex/L4LNebulaComponentController.setupCache";

import getAcquisitionRateForClientTurbo from "@salesforce/apex/LFLDTDRates.getAcquisitionRateforClientTurbo";

const TAG = "L4L-TimeSeries-Summary-Panel";
const SCENARIO = "View the COTS Summary Panel - LWC";
const COMPONENT = "l4lDTDAcquistionRate";

//const TAG = "L4L-Rates";

export default class LflDTDAcquisitionRate extends LightningElement {
  @api recordId;
  rate = 0;
  startd;
  endd;
  numberAcquiredInPeriod = 0;
  sessionCount = 0;
  weeks = 0;
  acquiredPerSession = 0;
  totalduration = 0;

  @wire(getAcquisitionRateForClientTurbo, {
    clientId: "$recordId"
  })
  wiredRates({ error, data }) {
    if (data) {
      console.log("DATA ===>" + data);
      let dataObj = JSON.parse(data);
      let _i = dataObj.data.length;
      if (_i > 0) {
        this.rate = JSON.stringify(dataObj.rate);
        this.startd = dataObj.data[0].startd;
        this.endd = dataObj.data[_i - 1].endd;
        this.numberAcquiredInPeriod =
          dataObj.data[_i - 1].endAcquiredCount -
          dataObj.data[0].startAcquiredCount;
        this.sessionCount = dataObj.totalsessions;
        this.weeks = dataObj.totalweeks;
        let _rate = this.numberAcquiredInPeriod / this.weeks;
        this.rate = _rate.toFixed(2);
        let _acquiredPerSession =
          this.numberAcquiredInPeriod / this.sessionCount;
        this.acquiredPerSession = _acquiredPerSession.toFixed(2);
      }
    } else if (error) {
      console.log("ERROR");
    }
  }

  connectedCallback() {
    setNewSession()
      .then((returnVal) => {
        console.log("Success");
        logInfo(
          this.recordId,
          `${COMPONENT}.connectedCallback(): all good, call to L4LNebulaComponentController setupCache completed `,
          `${SCENARIO}`,
          `${TAG}`
        );
      })
      .catch((error) => {
        console.log("Error");
        logError(
          this.recordId,
          `${COMPONENT}.connectedCallback() returned error: ${JSON.stringify(
            error
          )}`,
          `${SCENARIO}`,
          `${TAG}`
        );
      });

    // setNewSession().then((returnVal) => {
    //   console.log("Success");
    //   logInfo(
    //     this.recordId,
    //     `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
    //     `${COMPONENT}.connectedCallback(): call to L4LNebulaComponentController setupCache completed `,
    //     `${TAG}`
    //   );
    // });
  }
}
