// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__Refund__c {
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
    global List<blng__Refund__History> Histories;
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
    global List<blng__Refund__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global Decimal blng__Amount__c;
    global Decimal blng__BaseCurrencyAmount__c;
    global Date blng__BaseCurrencyFXDate__c;
    global Double blng__BaseCurrencyFXRate__c;
    global String blng__BaseCurrency__c;
    global Id blng__BillingFinanceBook__c;
    global blng__FinanceBook__c blng__BillingFinanceBook__r;
    global String blng__CheckNumber__c;
    global List<blng__ErrorLog__c> blng__Error_Logs__r;
    global Id blng__GLRule__c;
    global blng__GLRule__c blng__GLRule__r;
    global Id blng__GLTreatment__c;
    global blng__GLTreatment__c blng__GLTreatment__r;
    global Decimal blng__ImpactAmount__c;
    global Id blng__LegalEntity__c;
    global blng__LegalEntity__c blng__LegalEntity__r;
    global String blng__Notes__c;
    global String blng__PaymentGatewayTransactionID__c;
    global Date blng__RefundDate__c;
    global String blng__RefundDescription__c;
    global String blng__RefundLineCreationStatus__c;
    global List<blng__RefundLineCreditNoteLine__c> blng__RefundLinesCreditNoteLine__r;
    global String blng__RefundMode__c;
    global Id blng__RefundPaymentMethod__c;
    global blng__PaymentMethod__c blng__RefundPaymentMethod__r;
    global List<blng__RefundLinePayment__c> blng__RefundRefundLines__r;
    global String blng__RefundType__c;
    global Decimal blng__RefundedfromCreditNoteLines__c;
    global Decimal blng__RefundedfromPayments__c;
    global String blng__Status__c;

    global blng__Refund__c () 
    {
    }
}