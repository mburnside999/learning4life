// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class mcdm_15__LinkedBusinessUnit__c {
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
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<mcdm_15__LinkedBusinessUnit__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global String mcdm_15__AccountName__c;
    global String mcdm_15__AuthProviderName__c;
    global String mcdm_15__AuthSettingsId__c;
    global String mcdm_15__BusinessUnitName__c;
    global String mcdm_15__Connection_Status__c;
    global String mcdm_15__DisplayName__c;
    global Boolean mcdm_15__Enabled__c;
    global Boolean mcdm_15__IsAuthorized__c;
    global List<mcdm_15__MarketingCloudLinkedJourney__c> mcdm_15__Linked_Journeys__r;
    global String mcdm_15__Mid__c;
    global String mcdm_15__NamedCredentialApiName__c;
    global String mcdm_15__NamedCredentialId__c;
    global List<mcdm_15__QuickSendJourney__c> mcdm_15__Quick_Send_Journeys__r;
    global String mcdm_15__StubAuthSettingsId__c;
    global List<mcdm_15__SubmissionSendSettings__c> mcdm_15__SubmissionSendSettings__r;
    global String mcdm_15__SuffixNumber__c;
    global String mcdm_15__Username__c;

    global mcdm_15__LinkedBusinessUnit__c () 
    {
    }
}