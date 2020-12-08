// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__PaymentRun__ChangeEvent {
    global Object ChangeEventHeader;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Id Id;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global String Name;
    global SObject Owner;
    global Id OwnerId;
    global String ReplayId;
    global String blng__ApexJobIdForCleanUp__c;
    global String blng__ApexJobId__c;
    global String blng__CleanUpStatus__c;
    global Datetime blng__CompletedTime__c;
    global Double blng__FailedTransactions__c;
    global Double blng__InvoicesProcessed__c;
    global Id blng__PaymentGateway__c;
    global Id blng__PaymentScheduler__c;
    global Datetime blng__StartTime__c;
    global String blng__Status__c;
    global Double blng__SuccessfulTransactions__c;
    global Date blng__TargetDate__c;
    global Decimal blng__TotalPaymentProcessed__c;
    global Double blng__TransactionsGenerated__c;

    global blng__PaymentRun__ChangeEvent () 
    {
    }
}