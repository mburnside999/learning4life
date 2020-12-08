// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__RevenueRecognitionTreatment__c {
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
    global List<blng__RevenueRecognitionTreatment__History> Histories;
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
    global List<blng__RevenueRecognitionTreatment__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Boolean blng__Active__c;
    global Decimal blng__FlatAmount__c;
    global String blng__Notes__c;
    global Double blng__Percentage__c;
    global Double blng__ProcessingOrder__c;
    global String blng__RevenueAgreementAssociation__c;
    global Id blng__RevenueDistributionMethod__c;
    global blng__RevenueDistributionMethod__c blng__RevenueDistributionMethod__r;
    global Id blng__RevenueFinanceBook__c;
    global blng__FinanceBook__c blng__RevenueFinanceBook__r;
    global Id blng__RevenueGLRule__c;
    global blng__GLRule__c blng__RevenueGLRule__r;
    global Id blng__RevenueLegalEntity__c;
    global blng__LegalEntity__c blng__RevenueLegalEntity__r;
    global Id blng__RevenueRecognitionRule__c;
    global blng__RevenueRecognitionRule__c blng__RevenueRecognitionRule__r;
    global List<blng__RevenueSchedule__c> blng__RevenueRecognitionTreaRevenueSchedules__r;
    global String blng__RevenueScheduleAmount__c;
    global String blng__RevenueScheduleCreationAction__c;
    global String blng__Type__c;
    global String blng__UniqueId__c;
    global String blng__ValidateResult__c;

    global blng__RevenueRecognitionTreatment__c () 
    {
    }
}