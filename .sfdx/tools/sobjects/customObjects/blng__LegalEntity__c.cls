// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__LegalEntity__c {
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
    global List<blng__LegalEntity__History> Histories;
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
    global List<blng__LegalEntity__Share> Shares;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<blng__LegalEntity__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;
    global Boolean blng__Active__c;
    global List<blng__BillingTreatment__c> blng__BillingLegalEntityBillingTreatments__r;
    global String blng__City__c;
    global String blng__Country__c;
    global String blng__County__c;
    global List<blng__CreditNoteAllocation__c> blng__Credit_Note_Allocations__r;
    global List<blng__DebitNoteAllocation__c> blng__Debit_Note_Allocations__r;
    global List<blng__FinancePeriod__c> blng__FinancePeriods__r;
    global List<blng__CreditNoteLine__c> blng__LegalEntityCreditNoteLines__r;
    global List<blng__DebitNoteAllocationCreditNoteLine__c> blng__LegalEntityDebitNoteAllocationsCNLine__r;
    global List<blng__DebitNoteLine__c> blng__LegalEntityDebitNoteLines__r;
    global List<blng__GLTreatment__c> blng__LegalEntityGLTreatments__r;
    global List<blng__InvoiceLine__c> blng__LegalEntityInvoiceLines__r;
    global String blng__LegalEntityNumber__c;
    global List<blng__RevenueAdjustmentLine__c> blng__LegalEntityRevenueAdjustmentLines__r;
    global List<blng__RevenueAdjustment__c> blng__LegalEntityRevenueAdjustments__r;
    global List<blng__RevenueRecognitionTreatment__c> blng__LegalEntityRevenueRecognitionTreatments__r;
    global List<blng__RevenueTransaction__c> blng__LegalEntityRevenueTransactions__r;
    global List<blng__TaxRate__c> blng__LegalEntityTaxRates__r;
    global String blng__Notes__c;
    global List<OrderItem> blng__OrderProducts__r;
    global List<blng__PaymentMethod__c> blng__PaymentMethods__r;
    global List<blng__PaymentAllocationDebitNoteLine__c> blng__Payment_Allocations_Debit_Note_Line__r;
    global List<blng__PaymentAllocationInvoiceLine__c> blng__Payment_Allocations_Invoice_Line__r;
    global List<blng__Payment__c> blng__Payments__r;
    global List<blng__RefundLineCreditNoteLine__c> blng__RefundLinesCreditNoteLineLegalEntity__r;
    global List<blng__RefundLinePayment__c> blng__RefundLinesPaymentLegalEntity__r;
    global List<blng__Refund__c> blng__RefundsLegalEntity__r;
    global List<blng__RevenueSchedule__c> blng__RevenueSchedules__r;
    global String blng__State__c;
    global String blng__Street1__c;
    global String blng__Street2__c;
    global List<blng__TaxTreatment__c> blng__TaxLegalEntityTaxTreatments__r;
    global String blng__ZipPostalCode__c;

    global blng__LegalEntity__c () 
    {
    }
}