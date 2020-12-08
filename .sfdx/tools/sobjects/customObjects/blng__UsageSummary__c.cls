// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__UsageSummary__c {
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
    global List<blng__UsageSummary__History> Histories;
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
    global List<blng__UsageSummary__Share> Shares;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<blng__UsageSummary__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global Decimal blng__AppliedUnitPrice__c;
    global Decimal blng__BaseCurrencyAmount__c;
    global Date blng__BaseCurrencyFXDate__c;
    global Double blng__BaseCurrencyFXRate__c;
    global String blng__BaseCurrency__c;
    global Double blng__BilledQuantity__c;
    global Decimal blng__BilledRevenue__c;
    global Double blng__GroupedQuantity__c;
    global Double blng__IncludedUnbilledUsage__c;
    global Boolean blng__IncludedUsageExhausted__c;
    global Id blng__InvoiceLine__c;
    global blng__InvoiceLine__c blng__InvoiceLine__r;
    global String blng__InvoiceRunProcessingStatus__c;
    global Datetime blng__InvoiceRunStartDate__c;
    global String blng__InvoiceRunStatusIndex__c;
    global Id blng__InvoiceRun__c;
    global blng__InvoiceRun__c blng__InvoiceRun__r;
    global Id blng__Invoice__c;
    global blng__Invoice__c blng__Invoice__r;
    global String blng__MatchingAttribute__c;
    global String blng__MatchingId__c;
    global Date blng__NextBillingDate__c;
    global String blng__Notes__c;
    global Id blng__OrderProduct__c;
    global OrderItem blng__OrderProduct__r;
    global Id blng__Order__c;
    global Order blng__Order__r;
    global String blng__OverrideStatus__c;
    global Date blng__OverrideSummaryEndDate__c;
    global Date blng__OverrideSummaryStartDate__c;
    global Decimal blng__PreratedAmount__c;
    global Double blng__PreratedQuantity__c;
    global String blng__Source__c;
    global String blng__Status__c;
    global Decimal blng__Subtotal__c;
    global Date blng__SummaryEndDate__c;
    global Date blng__SummaryStartDate__c;
    global Double blng__TotalQuantity__c;
    global Decimal blng__TotalRevenue__c;
    global Double blng__UnbilledQuantity__c;
    global Decimal blng__UnbilledRevenue__c;
    global String blng__UniqueId__c;
    global String blng__UnitOfMeasure__c;
    global Decimal blng__UnitPrice__c;
    global Double blng__UsageCount__c;
    global List<blng__InvoiceLine__c> blng__UsageSummaryInvoiceLines__r;
    global List<blng__Usage__c> blng__Usages__r;

    global blng__UsageSummary__c () 
    {
    }
}