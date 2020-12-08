// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__BillingTreatment__c {
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
    global List<blng__BillingTreatment__History> Histories;
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
    global List<blng__BillingTreatment__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Boolean blng__Active__c;
    global Id blng__BillingFinanceBook__c;
    global blng__FinanceBook__c blng__BillingFinanceBook__r;
    global Id blng__BillingGLRule__c;
    global blng__GLRule__c blng__BillingGLRule__r;
    global Id blng__BillingLegalEntity__c;
    global blng__LegalEntity__c blng__BillingLegalEntity__r;
    global Id blng__BillingRule__c;
    global blng__BillingRule__c blng__BillingRule__r;
    global List<blng__CreditNoteAllocation__c> blng__BillingTreatmentCreditNoteAllocations__r;
    global List<blng__CreditNoteLine__c> blng__BillingTreatmentCreditNoteLines__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__BillingTreatmentDebitNoteACNLine__r;
    global List<blng__DebitNoteAllocation__c> blng__BillingTreatmentDebitNoteAllocations__r;
    global List<blng__DebitNoteLine__c> blng__BillingTreatmentDebitNoteLines__r;
    global List<blng__InvoiceLine__c> blng__BillingTreatmentInvoiceLines__r;
    global List<OrderItem> blng__BillingTreatmentOrderProducts__r;
    global Id blng__CancellationInvoicePlan__c;
    global blng__InvoicePlan__c blng__CancellationInvoicePlan__r;
    global String blng__CancellationRule__c;
    global Id blng__InvoicePlan__c;
    global blng__InvoicePlan__c blng__InvoicePlan__r;
    global String blng__Notes__c;

    global blng__BillingTreatment__c () 
    {
    }
}