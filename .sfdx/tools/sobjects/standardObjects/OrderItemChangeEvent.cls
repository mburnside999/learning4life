// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class OrderItemChangeEvent {
    global Double AvailableQuantity;
    global Object ChangeEventHeader;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Description;
    global Date EndDate;
    global Id Id;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Decimal ListPrice;
    global Order Order;
    global Id OrderId;
    global String OrderItemNumber;
    global OrderItem OriginalOrderItem;
    global Id OriginalOrderItemId;
    global PricebookEntry PricebookEntry;
    global Id PricebookEntryId;
    global String Product_Name__c;
    global Double Quantity;
    global QuoteLineItem QuoteLineItem;
    global Id QuoteLineItemId;
    global String ReplayId;
    global Date ServiceDate;
    global Decimal UnitPrice;
    global Decimal blng__AllocatedRevenueAmount__c;
    global Date blng__BillThroughDateOverride__c;
    global Decimal blng__BillableUnitPrice__c;
    global Decimal blng__BilledAmountwithouttax__c;
    global Decimal blng__BilledTax__c;
    global Id blng__BillingAccount__c;
    global Id blng__BillingGLRule__c;
    global Id blng__BillingGLTreatment__c;
    global Id blng__BillingRule__c;
    global Id blng__BillingTreatment__c;
    global Decimal blng__CanceledBillings__c;
    global Id blng__FinanceBookAccounting__c;
    global String blng__GroupId__c;
    global Double blng__GroupQuantity__c;
    global Decimal blng__GroupUnitPrice__c;
    global String blng__HoldBilling__c;
    global Double blng__IncludedUsage__c;
    global String blng__InvoiceGroupId__c;
    global String blng__InvoiceGrouping__c;
    global String blng__InvoiceRunProcessingStatus__c;
    global Datetime blng__InvoiceRunStartDate__c;
    global String blng__InvoiceRunStatusIndex__c;
    global Id blng__InvoiceRun__c;
    global Date blng__LastChargeToDate__c;
    global Date blng__LastInvoiceTargetDate__c;
    global String blng__LegalEntityReference__c;
    global Id blng__LegalEntity__c;
    global Date blng__NextBillingDate__c;
    global Date blng__NextChargeDate__c;
    global Decimal blng__OverrideBillableUnitPrice__c;
    global Date blng__OverrideInitialRevenueEndDate__c;
    global Date blng__OverrideInitialRevenueStartDate__c;
    global Date blng__OverrideNextBillingDate__c;
    global Decimal blng__PendingBillings__c;
    global Decimal blng__RevenueExpectedAmount__c;
    global Decimal blng__RevenueLiabilityAmount__c;
    global Decimal blng__RevenueMostLikelyAmount__c;
    global Id blng__RevenueRecognitionRule__c;
    global String blng__RevenueScheduleStatus__c;
    global String blng__TaxCity__c;
    global String blng__TaxCountry__c;
    global String blng__TaxCounty__c;
    global String blng__TaxErrorMessage__c;
    global Id blng__TaxGLRule__c;
    global Id blng__TaxGLTreatment__c;
    global Double blng__TaxPercentageApplied__c;
    global Id blng__TaxRule__c;
    global String blng__TaxState__c;
    global String blng__TaxStatus__c;
    global String blng__TaxStreet2__c;
    global String blng__TaxStreet__c;
    global Id blng__TaxTreatment__c;
    global String blng__TaxZipCode__c;
    global Decimal blng__TerminatedBillings__c;
    global Decimal blng__TotalBilling__c;
    global String blng__UniqueId__c;
    global Double blng__UsageFloorQuantity__c;

    global OrderItemChangeEvent () 
    {
    }
}