// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class PartnerMarketingBudget {
    global List<ActivityHistory> ActivityHistories;
    global Decimal Amount;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global Account ChannelPartner;
    global Id ChannelPartnerId;
    global List<PartnerMarketingBudget> ChildPartnerMarketingBudgets;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Description;
    global List<EmailMessage> Emails;
    global Date EndDate;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<PartnerMarketingBudgetFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<PartnerMarketingBudgetHistory> Histories;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsIgnoreValidation;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Boolean MayEdit;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global SObject Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global PartnerMarketingBudget ParentMdfBudget;
    global Id ParentMdfBudgetId;
    global List<PartnerFundAllocation> PartnerFundAllocations;
    global List<PartnerFundClaim> PartnerFundClaims;
    global List<PartnerFundRequest> PartnerFundRequests;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskRelationChangeEvent> Relation;
    global Date StartDate;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global String Title;
    global List<TopicAssignment> TopicAssignments;
    global Decimal TotalAllocatedAmount;
    global Decimal TotalApprovedFcs;
    global Decimal TotalApprovedFrs;
    global Decimal TotalReimbursedFcs;
    global String Type;
    global List<TaskChangeEvent> What;

    global PartnerMarketingBudget () 
    {
    }
}