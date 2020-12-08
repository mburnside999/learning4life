// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__TaxTreatment__c {
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
    global List<blng__TaxTreatment__History> Histories;
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
    global List<blng__TaxTreatment__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Boolean blng__Active__c;
    global String blng__Notes__c;
    global String blng__TaxCode__c;
    global Id blng__TaxGLRule__c;
    global blng__GLRule__c blng__TaxGLRule__r;
    global Id blng__TaxIntegration__c;
    global blng__TaxIntegration__c blng__TaxIntegration__r;
    global Id blng__TaxLegalEntity__c;
    global blng__LegalEntity__c blng__TaxLegalEntity__r;
    global Id blng__TaxRule__c;
    global blng__TaxRule__c blng__TaxRule__r;
    global List<blng__CreditNoteAllocation__c> blng__TaxTreatmentCreditNoteAllocations__r;
    global List<blng__CreditNoteLine__c> blng__TaxTreatmentCreditNoteLines__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__TaxTreatmentDebitNoteAllocationsCNLine__r;
    global List<blng__DebitNoteAllocation__c> blng__TaxTreatmentDebitNoteAllocations__r;
    global List<blng__DebitNoteLine__c> blng__TaxTreatmentDebitNoteLines__r;
    global List<blng__InvoiceLine__c> blng__TaxTreatmentInvoiceLines__r;
    global List<OrderItem> blng__TaxTreatmentOrderProducts__r;

    global blng__TaxTreatment__c () 
    {
    }
}