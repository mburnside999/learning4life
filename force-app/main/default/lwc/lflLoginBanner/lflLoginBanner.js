import { LightningElement, api, wire } from "lwc";
import getBannerDetail from "@salesforce/apex/LFLLoginBannerController.getBannerDetail";

export default class LflLoginBanner extends LightningElement {
  @api txtBoxVal;

  @wire(getBannerDetail) banner;

  get message() {
    return this.banner.data.Message__c;
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
}
