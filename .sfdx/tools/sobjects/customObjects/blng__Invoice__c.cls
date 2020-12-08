// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__Invoice__c {
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
    global String Currency_Symbol__c;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ContentVersion> FirstPublishLocation;
    global List<blng__Invoice__History> Histories;
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
    global String Payment_Site__c;
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
    global List<blng__Invoice__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global String blng__ARStatus__c;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global String blng__Action__c;
    global Decimal blng__Balance__c;
    global Decimal blng__BaseCurrencyAmount__c;
    global Date blng__BaseCurrencyFXDate__c;
    global Double blng__BaseCurrencyFXRate__c;
    global String blng__BaseCurrency__c;
    global Id blng__BillToContact__c;
    global Contact blng__BillToContact__r;
    global String blng__CorrectiveAction__c;
    global Decimal blng__Credits__c;
    global Double blng__DaysOutstanding__c;
    global Decimal blng__DebitPayments__c;
    global Decimal blng__Debits__c;
    global Double blng__DeclinedPaymentRunCount__c;
    global String blng__DefaultPaymentType__c;
    global Date blng__DueDate__c;
    global Decimal blng__ImpactAmount__c;
    global List<blng__CreditNote__c> blng__InvoiceCreditNotes__r;
    global Date blng__InvoiceDate__c;
    global List<blng__ErrorLog__c> blng__InvoiceErrorLogs__r;
    global List<blng__InvoiceLine__c> blng__InvoiceInvoiceLines__r;
    global Id blng__InvoiceRunCreatedBy__c;
    global blng__InvoiceRun__c blng__InvoiceRunCreatedBy__r;
    global String blng__InvoiceStatus__c;
    global List<blng__UsageSummary__c> blng__InvoiceUsageMediations__r;
    global Id blng__LastPaymentRunId__c;
    global blng__PaymentRun__c blng__LastPaymentRunId__r;
    global String blng__LastPaymentRunProcessingMessage__c;
    global Decimal blng__NegativeLineConversion__c;
    global String blng__Notes__c;
    global Double blng__NumberOfInvoiceLines__c;
    global Id blng__Order__c;
    global Order blng__Order__r;
    global String blng__PaymentBatch__c;
    global List<blng__PaymentAllocationInvoice__c> blng__PaymentInvoiceAllocations__r;
    global Id blng__PaymentMethod__c;
    global blng__PaymentMethod__c blng__PaymentMethod__r;
    global String blng__PaymentProcessStatus__c;
    global Id blng__PaymentRunId__c;
    global blng__PaymentRun__c blng__PaymentRunId__r;
    global String blng__PaymentRunProcessingMessage__c;
    global String blng__PaymentStatus__c;
    global Decimal blng__PaymentsAgainstInvoiceLines__c;
    global Decimal blng__PaymentsAgainstInvoice__c;
    global List<blng__PaymentMapping__c> blng__Payments_Mapping__r;
    global Decimal blng__Payments__c;
    global List<blng__Payment__c> blng__Payments__r;
    global Decimal blng__RefundsAgainstInvoiceLines__c;
    global Decimal blng__RefundsAgainstInvoice__c;
    global List<blng__PaymentTransaction__c> blng__RequestInvoiceTransactions__r;
    global String blng__StatusFlag__c;
    global Decimal blng__Subtotal__c;
    global Date blng__TargetDate__c;
    global Decimal blng__TaxAmount__c;
    global String blng__TaxErrorMessage__c;
    global Double blng__TaxErrors__c;
    global String blng__TaxStatus__c;
    global Decimal blng__TotalAmount__c;
    global String blng__UniqueId__c;

    global blng__Invoice__c () 
    {
    }
}