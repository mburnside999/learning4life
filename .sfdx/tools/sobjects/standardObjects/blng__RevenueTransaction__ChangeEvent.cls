// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__RevenueTransaction__ChangeEvent {
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
    global Id blng__Account__c;
    global Decimal blng__BaseCurrencyAmount__c;
    global Date blng__BaseCurrencyFXDate__c;
    global Double blng__BaseCurrencyFXRate__c;
    global String blng__BaseCurrency__c;
    global Id blng__Contract__c;
    global Id blng__CreditNoteLine__c;
    global Id blng__DebitNoteLine__c;
    global Decimal blng__DeferredBalance__c;
    global Id blng__InvoiceLine__c;
    global Id blng__LegalEntity__c;
    global String blng__Notes__c;
    global Id blng__OrderProduct__c;
    global Id blng__OriginalFinancePeriod__c;
    global Decimal blng__PreviouslyRecognizedRevenue__c;
    global Decimal blng__RevenueAmount__c;
    global String blng__RevenueDistributionMethod__c;
    global String blng__RevenueFinanceBook__c;
    global String blng__RevenueFinancePeriodUniqueId__c;
    global Id blng__RevenueFinancePeriod__c;
    global Id blng__RevenueRecognitionGLRule__c;
    global Id blng__RevenueRecognitionGLTreatment__c;
    global Id blng__RevenueRecognitionRule__c;
    global String blng__RevenueRecognitionTreatment__c;
    global Id blng__RevenueSchedule__c;
    global String blng__Status__c;
    global Date blng__SystemPeriodStartDate__c;

    global blng__RevenueTransaction__ChangeEvent () 
    {
    }
}