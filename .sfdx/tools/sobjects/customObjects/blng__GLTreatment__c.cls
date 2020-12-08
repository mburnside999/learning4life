// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__GLTreatment__c {
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
    global List<blng__GLTreatment__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Boolean blng__Active__c;
    global List<blng__CreditNoteAllocation__c> blng__BillingGLTreatmentCreditNoteAllocations__r;
    global List<blng__CreditNoteLine__c> blng__BillingGLTreatmentCreditNoteLines__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__BillingGLTreatmentDebitNoteACNL__r;
    global List<blng__DebitNoteAllocation__c> blng__BillingGLTreatmentDebitNoteAllocations__r;
    global List<blng__DebitNoteLine__c> blng__BillingGLTreatmentDebitNoteLines__r;
    global List<blng__InvoiceLine__c> blng__BillingGLTreatmentInvoiceLines__r;
    global List<OrderItem> blng__BillingGLTreatmentOrderProducts__r;
    global Id blng__CreditGLAccount__c;
    global blng__GLAccount__c blng__CreditGLAccount__r;
    global Id blng__DebitGLAccount__c;
    global blng__GLAccount__c blng__DebitGLAccount__r;
    global Id blng__GLLegalEntity__c;
    global blng__LegalEntity__c blng__GLLegalEntity__r;
    global Id blng__GLRule__c;
    global blng__GLRule__c blng__GLRule__r;
    global List<blng__RevenueAdjustmentLine__c> blng__GLTreatmentRevenueAdjustmentLines__r;
    global List<blng__RevenueSchedule__c> blng__GLTreatmentRevenueSchedules__r;
    global List<blng__RevenueTransaction__c> blng__GLTreatmentRevenueTransactions__r;
    global String blng__Notes__c;
    global List<blng__PaymentMethod__c> blng__Payment_Methods__r;
    global List<blng__Payment__c> blng__Payments__r;
    global List<blng__RefundLineCreditNoteLine__c> blng__RefundLinesCreditNoteLineGLTreatment__r;
    global List<blng__RefundLinePayment__c> blng__RefundLinesPaymentGLTreatment__r;
    global List<blng__Refund__c> blng__RefundsGLTreatment__r;
    global List<blng__CreditNoteAllocation__c> blng__TaxGLTreatmentCreditNoteAllocations__r;
    global List<blng__CreditNoteLine__c> blng__TaxGLTreatmentCreditNoteLines__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__TaxGLTreatmentDebitNoteAllocationsCNLine__r;
    global List<blng__DebitNoteAllocation__c> blng__TaxGLTreatmentDebitNoteAllocations__r;
    global List<blng__DebitNoteLine__c> blng__TaxGLTreatmentDebitNoteLines__r;
    global List<blng__InvoiceLine__c> blng__TaxGLTreatmentInvoiceLines__r;
    global List<OrderItem> blng__TaxGLTreatmentOrderProducts__r;
    global String blng__UniqueId__c;

    global blng__GLTreatment__c () 
    {
    }
}