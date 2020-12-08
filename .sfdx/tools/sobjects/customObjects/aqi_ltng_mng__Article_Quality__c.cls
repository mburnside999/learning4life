// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class aqi_ltng_mng__Article_Quality__c {
    global List<ActivityHistory> ActivityHistories;
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
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<aqi_ltng_mng__Article_Quality__Feed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<aqi_ltng_mng__Article_Quality__History> Histories;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global Date LastActivityDate;
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
    global List<OpenActivity> OpenActivities;
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
    global List<OutgoingEmail> RelatedTo;
    global List<TaskRelationChangeEvent> Relation;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<aqi_ltng_mng__Article_Quality__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Double aqi_ltng_mng__AQ_Score__c;
    global Id aqi_ltng_mng__Action_Assigned_To__c;
    global User aqi_ltng_mng__Action_Assigned_To__r;
    global Date aqi_ltng_mng__Action_Date__c;
    global Boolean aqi_ltng_mng__Action_Needed__c;
    global String aqi_ltng_mng__Action_Taken__c;
    global Id aqi_ltng_mng__Agent__c;
    global User aqi_ltng_mng__Agent__r;
    global Boolean aqi_ltng_mng__Art_Meets_Content_Standard__c;
    global Datetime aqi_ltng_mng__ArticleFirstPublishedDate__c;
    global Id aqi_ltng_mng__Article_Created_By__c;
    global User aqi_ltng_mng__Article_Created_By__r;
    global Datetime aqi_ltng_mng__Article_Created_Date__c;
    global String aqi_ltng_mng__Article_Link__c;
    global String aqi_ltng_mng__Article_Number__c;
    global String aqi_ltng_mng__Article_Title__c;
    global String aqi_ltng_mng__Article_Type__c;
    global Boolean aqi_ltng_mng__Article_Unique__c;
    global Double aqi_ltng_mng__Article_Version__c;
    global String aqi_ltng_mng__Comment__c;
    global Boolean aqi_ltng_mng__Content_Complete__c;
    global Boolean aqi_ltng_mng__Content_Understandable__c;
    global String aqi_ltng_mng__Internal_Notes__c;
    global String aqi_ltng_mng__Knowledge_Article_Id__c;
    global String aqi_ltng_mng__Knowledge_Article_Version_Id__c;
    global String aqi_ltng_mng__Language__c;
    global Id aqi_ltng_mng__Last_Modified_By__c;
    global User aqi_ltng_mng__Last_Modified_By__r;
    global Datetime aqi_ltng_mng__Last_Modified_Date__c;
    global Id aqi_ltng_mng__Last_Published_By__c;
    global User aqi_ltng_mng__Last_Published_By__r;
    global Datetime aqi_ltng_mng__Last_Published_Date__c;
    global Boolean aqi_ltng_mng__Links_In_Article_Valid__c;
    global Double aqi_ltng_mng__Possible_Points__c;
    global Boolean aqi_ltng_mng__Properties_Set_Appropriately__c;
    global Boolean aqi_ltng_mng__Title_Accurate__c;

    global aqi_ltng_mng__Article_Quality__c () 
    {
    }
}