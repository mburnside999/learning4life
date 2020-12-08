// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class OrderItem {
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global Double AvailableQuantity;
    global List<OrderItem> ChildOrderItems;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Description;
    global Date EndDate;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<OrderItemFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<OrderItemHistory> Histories;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Decimal ListPrice;
    global Boolean MayEdit;
    global Order Order;
    global Id OrderId;
    global String OrderItemNumber;
    global List<OrderItemChangeEvent> OriginalOrderItem;
    global Id OriginalOrderItemId;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global PricebookEntry PricebookEntry;
    global Id PricebookEntryId;
    global Product2 Product2;
    global Id Product2Id;
    global String Product_Name__c;
    global Double Quantity;
    global QuoteLineItem QuoteLineItem;
    global Id QuoteLineItemId;
    global List<FlowRecordRelation> RelatedRecord;
    global List<ReturnOrderLineItem> ReturnOrderLineItems;
    global Date ServiceDate;
    global Datetime SystemModstamp;
    global Decimal TotalPrice;
    global Decimal UnitPrice;
    global Decimal blng__AllocatedRevenueAmount__c;
    global Date blng__BillThroughDateOverride__c;
    global Decimal blng__BillableUnitPrice__c;
    global Decimal blng__BilledAmountwithouttax__c;
    global Decimal blng__BilledTax__c;
    global Id blng__BillingAccount__c;
    global Account blng__BillingAccount__r;
    global Id blng__BillingGLRule__c;
    global blng__GLRule__c blng__BillingGLRule__r;
    global Id blng__BillingGLTreatment__c;
    global blng__GLTreatment__c blng__BillingGLTreatment__r;
    global Id blng__BillingRule__c;
    global blng__BillingRule__c blng__BillingRule__r;
    global List<blng__BillingSchedule__c> blng__BillingSchedulesOrderProduct__r;
    global Id blng__BillingTreatment__c;
    global blng__BillingTreatment__c blng__BillingTreatment__r;
    global Decimal blng__CanceledBillings__c;
    global Id blng__FinanceBookAccounting__c;
    global blng__FinanceBook__c blng__FinanceBookAccounting__r;
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
    global blng__InvoiceRun__c blng__InvoiceRun__r;
    global Date blng__LastChargeToDate__c;
    global Date blng__LastInvoiceTargetDate__c;
    global String blng__LegalEntityReference__c;
    global Id blng__LegalEntity__c;
    global blng__LegalEntity__c blng__LegalEntity__r;
    global Date blng__NextBillingDate__c;
    global Date blng__NextChargeDate__c;
    global List<blng__ErrorLog__c> blng__OrderProductErrorLogs__r;
    global List<blng__InvoiceLine__c> blng__OrderProductInvoiceLines__r;
    global List<blng__RevenueAgreement__c> blng__OrderProductRevenueAgreements__r;
    global List<blng__RevenueTransaction__c> blng__OrderProductRevenueTransactions__r;
    global List<blng__SubInvoiceLine__c> blng__OrderProductSubInvoiceLines__r;
    global List<blng__UsageSummary__c> blng__OrderProductUsageMediations__r;
    global List<blng__Usage__c> blng__OrderProductUsages__r;
    global List<blng__RevenueSchedule__c> blng__OrderProductsRevenueSchedules__r;
    global Decimal blng__OverrideBillableUnitPrice__c;
    global Date blng__OverrideInitialRevenueEndDate__c;
    global Date blng__OverrideInitialRevenueStartDate__c;
    global Date blng__OverrideNextBillingDate__c;
    global List<blng__PaymentMapping__c> blng__Payments_Mapping__r;
    global Decimal blng__PendingBillings__c;
    global Decimal blng__RevenueExpectedAmount__c;
    global Decimal blng__RevenueLiabilityAmount__c;
    global Decimal blng__RevenueMostLikelyAmount__c;
    global Id blng__RevenueRecognitionRule__c;
    global blng__RevenueRecognitionRule__c blng__RevenueRecognitionRule__r;
    global String blng__RevenueScheduleStatus__c;
    global String blng__TaxCity__c;
    global String blng__TaxCountry__c;
    global String blng__TaxCounty__c;
    global String blng__TaxErrorMessage__c;
    global Id blng__TaxGLRule__c;
    global blng__GLRule__c blng__TaxGLRule__r;
    global Id blng__TaxGLTreatment__c;
    global blng__GLTreatment__c blng__TaxGLTreatment__r;
    global Double blng__TaxPercentageApplied__c;
    global Id blng__TaxRule__c;
    global blng__TaxRule__c blng__TaxRule__r;
    global String blng__TaxState__c;
    global String blng__TaxStatus__c;
    global String blng__TaxStreet2__c;
    global String blng__TaxStreet__c;
    global Id blng__TaxTreatment__c;
    global blng__TaxTreatment__c blng__TaxTreatment__r;
    global String blng__TaxZipCode__c;
    global Decimal blng__TerminatedBillings__c;
    global Decimal blng__TotalBilling__c;
    global String blng__UniqueId__c;
    global Double blng__UsageFloorQuantity__c;

    global OrderItem () 
    {
    }
}