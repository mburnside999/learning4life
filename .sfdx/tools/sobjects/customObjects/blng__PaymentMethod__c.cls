// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__PaymentMethod__c {
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
    global List<blng__PaymentMethod__History> Histories;
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
    global List<blng__PaymentMethod__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global Boolean blng__Active__c;
    global Boolean blng__AutoPay__c;
    global String blng__BankAccountName__c;
    global String blng__BankAccountNumber__c;
    global String blng__BankAccountType__c;
    global String blng__BankName__c;
    global String blng__BankRoutingCode__c;
    global String blng__BillingAddress__c;
    global String blng__BillingCity__c;
    global String blng__BillingCompany__c;
    global String blng__BillingCountry__c;
    global String blng__BillingEmail__c;
    global String blng__BillingFax__c;
    global String blng__BillingFirstName__c;
    global String blng__BillingLastName__c;
    global String blng__BillingPhone__c;
    global String blng__BillingStateProvince__c;
    global String blng__BillingStreet__c;
    global String blng__BillingZipPostal__c;
    global String blng__CVV__c;
    global String blng__CardBIN__c;
    global String blng__CardExpirationMonth__c;
    global String blng__CardExpirationYear__c;
    global String blng__CardLastFour__c;
    global String blng__CardNumber__c;
    global String blng__CardType__c;
    global List<blng__ErrorLog__c> blng__ErrorLogs__r;
    global Id blng__GLRule__c;
    global blng__GLRule__c blng__GLRule__r;
    global Id blng__GLTreatment__c;
    global blng__GLTreatment__c blng__GLTreatment__r;
    global String blng__GatewayResponse__c;
    global List<blng__Invoice__c> blng__Invoices__r;
    global Id blng__LegalEntity__c;
    global blng__LegalEntity__c blng__LegalEntity__r;
    global String blng__Nameoncard__c;
    global String blng__NickName__c;
    global String blng__Notes__c;
    global String blng__PaymentGatewayToken__c;
    global Id blng__PaymentGateway__c;
    global blng__PaymentGateway__c blng__PaymentGateway__r;
    global List<blng__Refund__c> blng__PaymentMethodRefunds__r;
    global List<blng__PaymentTransaction__c> blng__PaymentMethodTransactions__r;
    global String blng__PaymentType__c;
    global List<blng__PaymentAuthorization__c> blng__Payment_Authorizations__r;
    global List<blng__Payment__c> blng__Payments__r;
    global String blng__StreetAddress2__c;

    global blng__PaymentMethod__c () 
    {
    }
}