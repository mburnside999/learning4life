// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__DebitNoteAllocation__c {
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
    global List<blng__DebitNoteAllocation__History> Histories;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
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
    global List<blng__DebitNoteAllocation__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Decimal blng__Amount__c;
    global Decimal blng__Balance__c;
    global Id blng__BillingFinanceBook__c;
    global blng__FinanceBook__c blng__BillingFinanceBook__r;
    global Id blng__BillingFinancePeriod__c;
    global blng__FinancePeriod__c blng__BillingFinancePeriod__r;
    global Id blng__BillingGLRule__c;
    global blng__GLRule__c blng__BillingGLRule__r;
    global Id blng__BillingGLTreatment__c;
    global blng__GLTreatment__c blng__BillingGLTreatment__r;
    global Id blng__BillingRule__c;
    global blng__BillingRule__c blng__BillingRule__r;
    global Id blng__BillingTreatment__c;
    global blng__BillingTreatment__c blng__BillingTreatment__r;
    global Id blng__DebitNoteLine__c;
    global blng__DebitNoteLine__c blng__DebitNoteLine__r;
    global Id blng__DebitNote__c;
    global blng__DebitNote__c blng__DebitNote__r;
    global Decimal blng__ImpactAmount__c;
    global Id blng__InvoiceLine__c;
    global blng__InvoiceLine__c blng__InvoiceLine__r;
    global Id blng__LegalEntity__c;
    global blng__LegalEntity__c blng__LegalEntity__r;
    global String blng__Notes__c;
    global Decimal blng__PaymentAmount__c;
    global Decimal blng__Payments__c;
    global Decimal blng__RefundAmount__c;
    global Decimal blng__Refunds__c;
    global Id blng__TaxGLRule__c;
    global blng__GLRule__c blng__TaxGLRule__r;
    global Id blng__TaxGLTreatment__c;
    global blng__GLTreatment__c blng__TaxGLTreatment__r;
    global Id blng__TaxRule__c;
    global blng__TaxRule__c blng__TaxRule__r;
    global Id blng__TaxTreatment__c;
    global blng__TaxTreatment__c blng__TaxTreatment__r;
    global String blng__Type__c;
    global Boolean blng__Unallocated__c;

    global blng__DebitNoteAllocation__c () 
    {
    }
}