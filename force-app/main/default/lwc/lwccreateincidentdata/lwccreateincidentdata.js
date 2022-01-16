import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

const COLOUR="color:purple";




export default class Lwccreateincidentdata extends LightningElement {

    @api recordId = "a3N2v000003Gr4VEAS"; //session 31 for testing
 
    @track showStartBtn = true;
    @track timeVal = '00:00:00';
    timeIntervalInstance;
    totalMilliseconds = 0;

    get hrs() {
        return parseInt(this.timeVal.substring(0,2));
    }
    get mins() {
        return parseInt(this.timeVal.substring(3,5));
    }
    get secs() {
        return parseInt(this.timeVal.substring(6,8));
    }

    start(event) {
        console.info(`%cstart(): entering`,COLOUR);
        this.showStartBtn = false;
        var parentThis = this;

        // Run timer code in every 100 milliseconds
        this.timeIntervalInstance = setInterval(() => {

            // Time calculations for hours, minutes, seconds and milliseconds
            var hours = Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            var minutes = Math.floor((parentThis.totalMilliseconds % (1000 * 60 * 60)) / (1000 * 60));
            var seconds = Math.floor((parentThis.totalMilliseconds % (1000 * 60)) / 1000);
            
            // Output the result in the timeVal variable
            parentThis.timeVal = parentThis.pad(hours) + ":" + parentThis.pad(minutes) + ":" + parentThis.pad(seconds);
            parentThis.totalMilliseconds += 1000;
        }, 1000);
    }

    stop(event) {
        console.info(`%cstop(): entering`,COLOUR);
        this.showStartBtn = true;
        clearInterval(this.timeIntervalInstance);
    }

    reset(event) {
        console.info(`%creset(): entering`,COLOUR);
        this.showStartBtn = true;
        this.timeVal = '00:00:00';
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
        const evt = new ShowToastEvent({
            title: "Success",
            message: "Incidental Data recorded",
            variant: "success"
        });
        console.debug(`%chandleSuccess(): dispatching evt`,COLOUR);
        this.dispatchEvent(evt);

    }

    handleClickCancel(event) {
        this.dispatchEvent(new CustomEvent("close"));
      }

   

}