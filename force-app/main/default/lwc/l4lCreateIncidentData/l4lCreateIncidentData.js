import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

//debugging
const COMPONENT = "l4lCreateIncidentData";
const COLOR = "color:purple"; //for console log formatting
const DEBUG = "debug";
const INFO = "info";
const ERROR = "error";

export default class L4lCreateIncidentData extends LightningElement {
  @api recordId = "a3N2v000003Gr4VEAS"; //session 31 for testing
  @track showStartBtn = true;
  @track timeVal = "00:00:00";
  timeIntervalInstance;
  totalMilliseconds = 0;
  rendered = false;

  renderedCallback() {
    // if (!this.rendered) {
    //   this.logit(
    //     INFO,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `${COMPONENT}.renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     DEBUG,
    //     "renderedCallback():  ignore - confirming logging",
    //     `${COMPONENT}.renderedCallback()`,
    //     this.recordId
    //   );
    //   this.logit(
    //     ERROR,
    //     "renderedCallback(): ignore  - confirming logging",
    //     `${COMPONENT}.renderedCallback()`,
    //     this.recordId
    //   );
    //   this.rendered = true;
    // }
  }

  logit(level, message, tag, context = null) {
    console.log("in logger");
    let logger = this.template.querySelector("c-logger");
    logger.setScenario(`${COMPONENT}`);
    switch (level) {
      case INFO:
        logger.info(message).setRecordId(context).addTag("logit()").addTag(tag);
        break;
      case DEBUG:
        logger
          .debug(message)
          .setRecordId(context)
          .addTag("logit()")
          .addTag(tag);
        break;
      case ERROR:
        logger
          .error(message)
          .setRecordId(context)
          .addTag("logit()")
          .addTag(tag);
        break;
      default:
    }

    logger.saveLog();
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
    this.logit(
      INFO,
      `${COMPONENT}.start(): in start()`,
      `${COMPONENT}.start()`,
      this.recordId
    );
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
    this.logit(
      INFO,
      `${COMPONENT}.stop(): in stop()`,
      `${COMPONENT}.stop()`,
      this.recordId
    );
    this.showStartBtn = true;
    clearInterval(this.timeIntervalInstance);
  }

  reset(event) {
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
    this.logit(
      INFO,
      `${COMPONENT}.handleSuccess(): in handleSuccess()`,
      `${COMPONENT}.handleSuccess()`,
      this.recordId
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
