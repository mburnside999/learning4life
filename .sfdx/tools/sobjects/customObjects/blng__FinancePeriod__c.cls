// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__FinancePeriod__c {
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CombinedAttachment> CombinedAttachments;
    global PartnerNetworkConnection ConnectionReceived;
    global Id ConnectionReceivedId;
    global PartnerNetworkConnection ConnectionSent;
    global Id ConnectionSentId;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EventRelation> EventRelations;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ContentVersion> FirstPublishLocation;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global List<PartnerNetworkRecordConnection> LocalRecord;
    global Boolean MayEdit;
    global String Name;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<Opportunity__hd> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global List<PartnerNetworkRecordConnection> ParentRecord;
    global List<PartnerNetworkRecordConnection> PartnerRecord;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskRelationChangeEvent> Relation;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<blng__FinancePeriod__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global List<blng__CreditNoteAllocation__c> blng__BillingFinancePerioCreditNoteAllocations__r;
    global List<blng__CreditNote__c> blng__BillingFinancePeriodCreditNotes__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__BillingFinancePeriodDebitNoteACNL__r;
    global List<blng__DebitNoteAllocation__c> blng__BillingFinancePeriodDebitNoteAllocations__r;
    global List<blng__DebitNote__c> blng__BillingFinancePeriodDebitNotes__r;
    global List<blng__InvoiceLine__c> blng__BillingFinancePeriodInvoiceLines__r;
    global List<blng__Payment__c> blng__BillingFinancePeriodPayments__r;
    global String blng__Family__c;
    global Id blng__FinanceBook__c;
    global blng__FinanceBook__c blng__FinanceBook__r;
    global List<blng__CreditNoteLine__c> blng__FinancePeriodCreditNoteLines__r;
    global List<blng__DebitNoteLine__c> blng__FinancePeriodDebitNoteLines__r;
    global String blng__FinancePeriodFamily__c;
    global List<blng__PaymentAllocationDebitNoteLine__c> blng__FinancePeriodPaymentAllocationDebitLines__r;
    global List<blng__PaymentAllocationInvoice__c> blng__FinancePeriodPaymentAllocationInvoices__r;
    global List<blng__PaymentAllocationInvoiceLine__c> blng__FinancePeriodPaymentInvoiceLines__r;
    global List<blng__RefundLineCreditNoteLine__c> blng__FinancePeriodRefundCreditLines__r;
    global List<blng__RefundLinePayment__c> blng__FinancePeriodRefundLinePayments__r;
    global List<blng__RevenueAdjustmentLine__c> blng__FinancePeriodRevenueAdjustmentLines__r;
    global List<blng__RevenueAdjustment__c> blng__FinancePeriodRevenueAdjustments__r;
    global List<blng__RevenueSchedule__c> blng__FinancePeriodRevenueSchedules__r;
    global List<blng__RevenueTransaction__c> blng__FinancePeriodRevenueTransactions__r;
    global Id blng__LegalEntity__c;
    global blng__LegalEntity__c blng__LegalEntity__r;
    global Boolean blng__NextOpenPeriod__c;
    global String blng__Notes__c;
    global List<blng__Payment__c> blng__Payments__r;
    global Date blng__PeriodEndDate__c;
    global Date blng__PeriodStartDate__c;
    global String blng__PeriodStatus__c;
    global String blng__PeriodType__c;
    global String blng__ReferenceId__c;
    global List<blng__RevenueTransaction__c> blng__RevenueTransactions__r;
    global String blng__UniqueId__c;

    global blng__FinancePeriod__c () 
    {
    }
}