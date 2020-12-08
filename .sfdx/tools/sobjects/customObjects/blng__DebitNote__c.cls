// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__DebitNote__c {
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
    global List<blng__DebitNote__History> Histories;
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
    global List<blng__DebitNote__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Id blng__Account__c;
    global Account blng__Account__r;
    global Decimal blng__Allocations__c;
    global Decimal blng__AvailableForPayment__c;
    global Decimal blng__Balance__c;
    global Decimal blng__BaseCurrencyAmount__c;
    global Date blng__BaseCurrencyFXDate__c;
    global Double blng__BaseCurrencyFXRate__c;
    global String blng__BaseCurrency__c;
    global Id blng__BillToAccount__c;
    global Account blng__BillToAccount__r;
    global Id blng__BillToContact__c;
    global Contact blng__BillToContact__r;
    global Id blng__BillingFinanceBook__c;
    global blng__FinanceBook__c blng__BillingFinanceBook__r;
    global Id blng__BillingFinancePeriod__c;
    global blng__FinancePeriod__c blng__BillingFinancePeriod__r;
    global Decimal blng__CreditNoteLineAllocations__c;
    global Decimal blng__CreditNoteLineUnallocations__c;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__DebitNoteAllocationsCreditNoteLine__r;
    global List<blng__DebitNoteAllocation__c> blng__DebitNoteAllocationsInvoiceLine__r;
    global Date blng__DebitNoteDate__c;
    global List<blng__DebitNoteLine__c> blng__DebitNoteLines__r;
    global String blng__DebitNoteSourceAction__c;
    global Date blng__EffectiveTaxDate__c;
    global Decimal blng__ImpactAmount__c;
    global Decimal blng__InvoiceLineAllocations__c;
    global Decimal blng__InvoiceLineUnallocations__c;
    global Decimal blng__NetCreditNoteAllocations__c;
    global Decimal blng__NetInvoiceAllocations__c;
    global Decimal blng__NetPaymentAllocations__c;
    global String blng__Notes__c;
    global Decimal blng__PaymentBalance__c;
    global Decimal blng__Payments1__c;
    global Decimal blng__Payments__c;
    global Decimal blng__Refunds__c;
    global String blng__Status__c;
    global Decimal blng__Subtotal__c;
    global Decimal blng__TaxAmount__c;
    global String blng__TaxCity__c;
    global String blng__TaxCountry__c;
    global String blng__TaxErrorMessage__c;
    global String blng__TaxState__c;
    global String blng__TaxStreet2__c;
    global String blng__TaxStreet__c;
    global String blng__TaxZipCode__c;
    global Decimal blng__TotalAmount__c;
    global Decimal blng__TotalAvailableForAllocation__c;
    global Decimal blng__TotalNetAllocations__c;
    global Decimal blng__Unallocations__c;

    global blng__DebitNote__c () 
    {
    }
}