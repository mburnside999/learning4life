import { LightningElement, api, wire } from "lwc";
import getBannerDetail from "@salesforce/apex/LFLLoginBannerController.getBannerDetail";
import { RefreshEvent } from "lightning/refresh";

export default class LflLoginBanner extends LightningElement {
  @api txtBoxVal;
  hidden = false;
  @wire(getBannerDetail, { hide: false }) banner;

  get message() {
    return this.banner.data.Message__c;
  }

  get notificationlink() {
    return this.banner.data.NotificationLink__c;
  }

  get notificationtext() {
    return this.banner.data.NotificationText__c;
  }

  notificationStartDate() {
    return this.banner && this.banner.data
      ? this.banner.data.Start__c
      : "Loading...";
  }

  notificationEndDate() {
    return this.banner && this.banner.data
      ? this.banner.data.End__c
      : "Loading...";
  }

  get expression() {
    let today = new Date();
    today.setMinutes(new Date().getMinutes() - new Date().getTimezoneOffset());

    // Return today's date in "YYYY-MM-DD" format
    let date = today.toISOString().slice(0, 10);

    let plannedStartDate = this.notificationStartDate();
    let plannedEndDate = this.notificationEndDate();

    if (date >= plannedStartDate && date <= plannedEndDate) {
      return true;
    } else {
      return false;
    }
  }

  handleChange(event) {
    this.hidden = !this.hidden;
    console.log("hidden is now " + this.hidden);
    getBannerDetail({
      hide: this.hidden
    }).then((result) => {
      this.banner = result;
      console.log("returned");
      console.log(`returned ${JSON.stringify(result)}`);
      this.dispatchEvent(new RefreshEvent());
    });
  }
}
