/* eslint-disable */
({
  closeMethodInAuraController: function (component, event, helper) {
    $A.get("e.force:closeQuickAction").fire();
  },
  doInit: function (component, event, helper) {
    var SessionId = component.get("v.recordId");
    console.log("AA");

    console.log(JSON.stringify(component.get("v.SessionObject")));
    var clientId = component.get("v.SessionObject").Client__c;
    component.set("v.clientId", clientId);
  },
  closeAll: function (component, event, helper) {
    $A.get("e.force:closeQuickAction").fire();
  }
});
