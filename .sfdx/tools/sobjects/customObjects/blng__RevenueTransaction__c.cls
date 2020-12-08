// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__RevenueTransaction__c {
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
    global List<blng__RevenueTransaction__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global Decimal blng__BaseCurrencyAmount__c;
    global Date blng__BaseCurrencyFXDate__c;
    global Double blng__BaseCurrencyFXRate__c;
    global String blng__BaseCurrency__c;
    global Id blng__Contract__c;
    global Contract blng__Contract__r;
    global Id blng__CreditNoteLine__c;
    global blng__CreditNoteLine__c blng__CreditNoteLine__r;
    global Id blng__DebitNoteLine__c;
    global blng__DebitNoteLine__c blng__DebitNoteLine__r;
    global Decimal blng__DeferredBalance__c;
    global Id blng__InvoiceLine__c;
    global blng__InvoiceLine__c blng__InvoiceLine__r;
    global Id blng__LegalEntity__c;
    global blng__LegalEntity__c blng__LegalEntity__r;
    global String blng__Notes__c;
    global Id blng__OrderProduct__c;
    global OrderItem blng__OrderProduct__r;
    global Id blng__OriginalFinancePeriod__c;
    global blng__FinancePeriod__c blng__OriginalFinancePeriod__r;
    global Decimal blng__PreviouslyRecognizedRevenue__c;
    global Decimal blng__RevenueAmount__c;
    global String blng__RevenueDistributionMethod__c;
    global String blng__RevenueFinanceBook__c;
    global String blng__RevenueFinancePeriodUniqueId__c;
    global Id blng__RevenueFinancePeriod__c;
    global blng__FinancePeriod__c blng__RevenueFinancePeriod__r;
    global Id blng__RevenueRecognitionGLRule__c;
    global blng__GLRule__c blng__RevenueRecognitionGLRule__r;
    global Id blng__RevenueRecognitionGLTreatment__c;
    global blng__GLTreatment__c blng__RevenueRecognitionGLTreatment__r;
    global Id blng__RevenueRecognitionRule__c;
    global blng__RevenueRecognitionRule__c blng__RevenueRecognitionRule__r;
    global String blng__RevenueRecognitionTreatment__c;
    global Id blng__RevenueSchedule__c;
    global blng__RevenueSchedule__c blng__RevenueSchedule__r;
    global String blng__Status__c;
    global Date blng__SystemPeriodStartDate__c;

    global blng__RevenueTransaction__c () 
    {
    }
}