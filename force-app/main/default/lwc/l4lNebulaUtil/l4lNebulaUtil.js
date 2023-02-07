import debugLog from "@salesforce/apex/L4LNebulaComponentController.logDebug";
import errorLog from "@salesforce/apex/L4LNebulaComponentController.logError";
import fineLog from "@salesforce/apex/L4LNebulaComponentController.logFine";

function logDebug(recordId, message, scenario, tag) {
  debugLog({
    recordId: recordId,
    message: message,
    scenario: scenario,
    tag: tag
  })
    .then((returnVal) => {
      console.log(
        "Successfully returned from L4LNebulaComponentController.logDebug"
      );
    })
    .catch((error) => {
      console.log(
        "Error encountered in call to logDebug: " + JSON.stringify(error)
      );
    });
}

function logFine(recordId, message, scenario, tag) {
  fineLog({
    recordId: recordId,
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

function logError(recordId, message, scenario, tag) {
  errorLog({
    recordId: recordId,
    message: message,
    scenario: scenario,
    tag: tag
  })
    .then((returnVal) => {
      "Successfully returned from L4LNebulaComponentController.logError";
    })
    .catch((error) => {
      "Error encountered in call to logDebug: " + JSON.stringify(error);
    });
}

export { logDebug, logFine, logError };
