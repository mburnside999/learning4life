// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__GLRule__c {
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
    global List<blng__GLRule__History> Histories;
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
    global List<blng__GLRule__Share> Shares;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<blng__GLRule__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Boolean blng__Active__c;
    global List<blng__BillingTreatment__c> blng__BillingGLRuleBillingTreatments__r;
    global List<blng__CreditNoteAllocation__c> blng__BillingGLRuleCreditNoteAllocations__r;
    global List<blng__CreditNoteLine__c> blng__BillingGLRuleCreditNoteLines__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__BillingGLRuleDebitNoteACNL__r;
    global List<blng__DebitNoteAllocation__c> blng__BillingGLRuleDebitNoteAllocations__r;
    global List<blng__DebitNoteLine__c> blng__BillingGLRuleDebitNoteLines__r;
    global List<blng__InvoiceLine__c> blng__BillingGLRuleInvoiceLines__r;
    global List<OrderItem> blng__BillingGLRuleOrderProducts__r;
    global List<blng__RevenueAdjustmentLine__c> blng__GLRuleRevenueAdjustmentLines__r;
    global List<blng__RevenueRecognitionTreatment__c> blng__GLRuleRevenueRecognitionTreatments__r;
    global List<blng__RevenueTransaction__c> blng__GLRuleRevenueTransactions__r;
    global List<blng__GLTreatment__c> blng__GLTreatments__r;
    global String blng__Notes__c;
    global List<blng__PaymentMethod__c> blng__PaymentMethods__r;
    global List<blng__Payment__c> blng__Payments__r;
    global List<blng__RefundLineCreditNoteLine__c> blng__RefundLinesCreditNoteLineGLRule__r;
    global List<blng__RefundLinePayment__c> blng__RefundLinesPaymentGLRule__r;
    global List<blng__Refund__c> blng__RefundsGLRule__r;
    global List<blng__RevenueSchedule__c> blng__RevenueRecognitioGLRuleRevenueSchedules__r;
    global List<blng__CreditNoteAllocation__c> blng__TaxGLRuleCreditNoteAllocations__r;
    global List<blng__CreditNoteLine__c> blng__TaxGLRuleCreditNoteLines__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__TaxGLRuleDebitNoteAllocationsCNLine__r;
    global List<blng__DebitNoteAllocation__c> blng__TaxGLRuleDebitNoteAllocations__r;
    global List<blng__DebitNoteLine__c> blng__TaxGLRuleDebitNoteLines__r;
    global List<blng__InvoiceLine__c> blng__TaxGLRuleInvoiceLines__r;
    global List<OrderItem> blng__TaxGLRuleOrderProducts__r;
    global List<blng__TaxTreatment__c> blng__TaxGLRuleTaxTreatments__r;

    global blng__GLRule__c () 
    {
    }
}