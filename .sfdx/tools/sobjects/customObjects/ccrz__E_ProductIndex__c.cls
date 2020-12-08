// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ccrz__E_ProductIndex__c {
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
    global List<ContentVersion> FirstPublishLocation;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global Date LastActivityDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
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
    global List<ccrz__E_ProductIndex__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Boolean ccrz__Active__c;
    global Date ccrz__CategoryEndDate__c;
    global Date ccrz__CategoryStartDate__c;
    global String ccrz__Category__c;
    global String ccrz__FilterData__c;
    global String ccrz__IndexCurrency__c;
    global String ccrz__IndexPrice__c;
    global String ccrz__IndexType__c;
    global Boolean ccrz__LastIndex__c;
    global String ccrz__Locale__c;
    global String ccrz__LongDescription__c;
    global String ccrz__PriceLists__c;
    global Date ccrz__ProductCategoryEndDate__c;
    global Double ccrz__ProductCategorySequence__c;
    global Date ccrz__ProductCategoryStartDate__c;
    global Id ccrz__ProductCategory__c;
    global ccrz__E_ProductCategory__c ccrz__ProductCategory__r;
    global Date ccrz__ProductEndDate__c;
    global String ccrz__ProductName__c;
    global Date ccrz__ProductStartDate__c;
    global String ccrz__ProductStatus__c;
    global Id ccrz__Product__c;
    global ccrz__E_Product__c ccrz__Product__r;
    global String ccrz__SEOKeywords__c;
    global String ccrz__SKU__c;
    global String ccrz__ShortDescription__c;
    global String ccrz__Storefront__c;

    global ccrz__E_ProductIndex__c () 
    {
    }
}