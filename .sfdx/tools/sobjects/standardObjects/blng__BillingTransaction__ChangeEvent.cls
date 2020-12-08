// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__BillingTransaction__ChangeEvent {
    global Object ChangeEventHeader;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Id Id;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global String Name;
    global String ReplayId;
    global Decimal blng__AmountToBeBilled__c;
    global Decimal blng__Amount__c;
    global Id blng__BillingSchedule__c;
    global Date blng__BillingTargetDate__c;
    global String blng__CalculatedStatus__c;
    global Id blng__InvoicePlanLine__c;
    global Decimal blng__OverrideAmount__c;
    global Date blng__OverrideBillingTargetDate__c;
    global String blng__OverrideStatus__c;
    global Double blng__Quantity__c;
    global Date blng__ServicePeriodEnd__c;
    global Date blng__ServicePeriodStart__c;
    global String blng__Source__c;
    global String blng__Status__c;

    global blng__BillingTransaction__ChangeEvent () 
    {
    }
}