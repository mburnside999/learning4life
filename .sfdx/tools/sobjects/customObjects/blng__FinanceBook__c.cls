// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__FinanceBook__c {
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
    global List<blng__FinanceBook__History> Histories;
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
    global SObject Owner;
    global Id OwnerId;
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
    global List<blng__FinanceBook__Share> Shares;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<blng__FinanceBook__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global List<OrderItem> blng__AccountingOrderProducts__r;
    global Boolean blng__Active__c;
    global List<blng__BillingTreatment__c> blng__BillingFinanceBookBillingTreatments__r;
    global List<blng__CreditNoteAllocation__c> blng__BillingFinanceBookCreditNoteAllocations__r;
    global List<blng__CreditNoteLine__c> blng__BillingFinanceBookCreditNoteLines__r;
    global List<blng__CreditNote__c> blng__BillingFinanceBookCreditNotes__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__BillingFinanceBookDebitNoteACNL__r;
    global List<blng__DebitNoteAllocation__c> blng__BillingFinanceBookDebitNoteAllocations__r;
    global List<blng__DebitNoteLine__c> blng__BillingFinanceBookDebitNoteLines__r;
    global List<blng__DebitNote__c> blng__BillingFinanceBookDebitNotes__r;
    global List<blng__InvoiceLine__c> blng__BillingFinanceBookInvoiceLines__r;
    global List<blng__Payment__c> blng__BillingFinanceBookPayments__r;
    global List<blng__PaymentAllocationDebitNoteLine__c> blng__FinanceBookPaymentAllocationDebitLine__r;
    global List<blng__PaymentAllocationInvoice__c> blng__FinanceBookPaymentAllocationInvoices__r;
    global List<blng__PaymentAllocationInvoiceLine__c> blng__FinanceBookPaymentInvoiceLines__r;
    global List<blng__RefundLineCreditNoteLine__c> blng__FinanceBookRefundCreditLines__r;
    global List<blng__RefundLinePayment__c> blng__FinanceBookRefundlinePayments__r;
    global List<blng__RevenueAdjustmentLine__c> blng__FinanceBookRevenueAdjustmentLines__r;
    global List<blng__RevenueAdjustment__c> blng__FinanceBookRevenueAdjustments__r;
    global List<blng__RevenueRecognitionTreatment__c> blng__FinanceBookRevenueRecognitionTreatments__r;
    global List<blng__RevenueSchedule__c> blng__FinanceBookRevenueSchedules__r;
    global List<blng__FinancePeriod__c> blng__FinancePeriods__r;
    global String blng__Notes__c;
    global String blng__PeriodType__c;
    global List<blng__Refund__c> blng__Refunds__r;
    global List<blng__RevenueSchedule__c> blng__RevenueFinanceBookRevenueSchedules__r;

    global blng__FinanceBook__c () 
    {
    }
}