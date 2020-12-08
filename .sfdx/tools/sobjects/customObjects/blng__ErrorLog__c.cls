// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__ErrorLog__c {
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
    global List<blng__ErrorLog__Share> Shares;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<blng__ErrorLog__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global Id blng__BalanceSnapshotRun__c;
    global blng__BalanceSnapShotRun__c blng__BalanceSnapshotRun__r;
    global Id blng__BatchJob__c;
    global blng__BillingBatchJob__c blng__BatchJob__r;
    global Id blng__CreditNoteLine__c;
    global blng__CreditNoteLine__c blng__CreditNoteLine__r;
    global Id blng__DebitNoteLine__c;
    global blng__DebitNoteLine__c blng__DebitNoteLine__r;
    global String blng__ErrorCode__c;
    global String blng__ErrorName__c;
    global String blng__ErrorOrigin__c;
    global String blng__FullErrorLog__c;
    global Id blng__InvoiceLine__c;
    global blng__InvoiceLine__c blng__InvoiceLine__r;
    global Id blng__InvoiceRun__c;
    global blng__InvoiceRun__c blng__InvoiceRun__r;
    global Id blng__InvoiceScheduler__c;
    global blng__InvoiceScheduler__c blng__InvoiceScheduler__r;
    global Id blng__Invoice__c;
    global blng__Invoice__c blng__Invoice__r;
    global String blng__Notes__c;
    global Id blng__OrderProduct__c;
    global OrderItem blng__OrderProduct__r;
    global Id blng__Order__c;
    global Order blng__Order__r;
    global String blng__OriginMethod__c;
    global Id blng__PaymentAllocationDebitNoteLine__c;
    global blng__PaymentAllocationDebitNoteLine__c blng__PaymentAllocationDebitNoteLine__r;
    global Id blng__PaymentAllocationInvoiceLine__c;
    global blng__PaymentAllocationInvoiceLine__c blng__PaymentAllocationInvoiceLine__r;
    global Id blng__PaymentAllocationInvoice__c;
    global blng__PaymentAllocationInvoice__c blng__PaymentAllocationInvoice__r;
    global Id blng__PaymentMethod__c;
    global blng__PaymentMethod__c blng__PaymentMethod__r;
    global Id blng__PaymentRun__c;
    global blng__PaymentRun__c blng__PaymentRun__r;
    global Id blng__PaymentScheduler__c;
    global blng__PaymentScheduler__c blng__PaymentScheduler__r;
    global Id blng__Payment__c;
    global blng__Payment__c blng__Payment__r;
    global String blng__ReferenceId__c;
    global Id blng__Refund__c;
    global blng__Refund__c blng__Refund__r;
    global Id blng__RevenueSchedule__c;
    global blng__RevenueSchedule__c blng__RevenueSchedule__r;
    global String blng__Summary__c;
    global Id blng__Transaction__c;
    global blng__PaymentTransaction__c blng__Transaction__r;
    global String blng__UniqueId__c;
    global Id blng__Usage__c;
    global blng__Usage__c blng__Usage__r;

    global blng__ErrorLog__c () 
    {
    }
}