// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__BillingSchedule__c {
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
    global List<blng__BillingSchedule__Share> Shares;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<blng__BillingSchedule__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Decimal blng__Amount__c;
    global Decimal blng__BilledAmount__c;
    global List<blng__BillingTransaction__c> blng__BillingTransactionsBillingSchedule__r;
    global Id blng__InvoicePlan__c;
    global blng__InvoicePlan__c blng__InvoicePlan__r;
    global Double blng__NumberOfBilledBillingTransactions__c;
    global Double blng__NumberOfBillingTransactions__c;
    global Double blng__NumberOfCanceledBillingTransactions__c;
    global Id blng__OrderProduct__c;
    global OrderItem blng__OrderProduct__r;
    global String blng__Source__c;
    global String blng__Status__c;
    global String blng__TaxCity__c;
    global String blng__TaxCountry__c;
    global String blng__TaxState__c;
    global String blng__TaxStreet__c;
    global String blng__TaxZipCode__c;

    global blng__BillingSchedule__c () 
    {
    }
}