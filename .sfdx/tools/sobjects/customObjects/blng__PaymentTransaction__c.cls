// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__PaymentTransaction__c {
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
    global List<blng__PaymentTransaction__History> Histories;
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
    global List<blng__PaymentTransaction__Share> Shares;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<blng__PaymentTransaction__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global String blng__AVSResponseCode__c;
    global String blng__AVSZip__c;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global Double blng__Amount__c;
    global String blng__Authorization__c;
    global String blng__BankAccountName__c;
    global String blng__BankAccountNumber__c;
    global String blng__BankAccountType__c;
    global String blng__BankName__c;
    global String blng__BankRoutingCode__c;
    global String blng__CardCodeResponse__c;
    global String blng__CardExpirationMonth__c;
    global String blng__CardExpirationYear__c;
    global String blng__CardType__c;
    global List<blng__ErrorLog__c> blng__ErrorLogs__r;
    global String blng__ExceptionMessage__c;
    global Datetime blng__GatewayDate__c;
    global String blng__GatewayID__c;
    global String blng__GatewayStatus__c;
    global Boolean blng__IsPaymentProcessedSuccessfully__c;
    global String blng__Notes__c;
    global List<blng__PaymentTransaction__c> blng__ParentTransactions__r;
    global Id blng__PaymentGateway__c;
    global blng__PaymentGateway__c blng__PaymentGateway__r;
    global Id blng__PaymentMethod__c;
    global blng__PaymentMethod__c blng__PaymentMethod__r;
    global Id blng__PaymentRun__c;
    global blng__PaymentRun__c blng__PaymentRun__r;
    global List<blng__Payment__c> blng__Payments__r;
    global Double blng__ReasonCode__c;
    global String blng__RequestCreditCardNumber__c;
    global Id blng__RequestInvoice__c;
    global blng__Invoice__c blng__RequestInvoice__r;
    global String blng__RequestTransactionType__c;
    global String blng__RequestTypeOfPayment__c;
    global String blng__ResponseCode__c;
    global String blng__ResponseMessage__c;
    global String blng__ResponseStatus__c;
    global String blng__Response__c;
    global String blng__Status__c;
    global Id blng__Transaction__c;
    global blng__PaymentTransaction__c blng__Transaction__r;
    global String blng__Type__c;

    global blng__PaymentTransaction__c () 
    {
    }
}