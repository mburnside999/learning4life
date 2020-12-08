// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__RevenueAdjustmentLine__c {
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
    global List<blng__RevenueAdjustmentLine__History> Histories;
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
    global List<blng__RevenueAdjustmentLine__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global Decimal blng__AdjustmentAmount__c;
    global Id blng__FinanceBook__c;
    global blng__FinanceBook__c blng__FinanceBook__r;
    global Id blng__FinancePeriod__c;
    global blng__FinancePeriod__c blng__FinancePeriod__r;
    global Id blng__GLRule__c;
    global blng__GLRule__c blng__GLRule__r;
    global Id blng__GLTreatment__c;
    global blng__GLTreatment__c blng__GLTreatment__r;
    global Id blng__LegalEntity__c;
    global blng__LegalEntity__c blng__LegalEntity__r;
    global String blng__Notes__c;
    global Date blng__RevenueAdjustmentDate__c;
    global Id blng__RevenueAdjustment__c;
    global blng__RevenueAdjustment__c blng__RevenueAdjustment__r;
    global String blng__Status__c;
    global Id blng__TargetRevenueSchedule__c;
    global blng__RevenueSchedule__c blng__TargetRevenueSchedule__r;
    global String blng__Type__c;

    global blng__RevenueAdjustmentLine__c () 
    {
    }
}