// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Campaign {
    global List<ActivityHistory> ActivityHistories;
    global Decimal ActualCost;
    global Decimal AmountAllOpportunities;
    global Decimal AmountWonOpportunities;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global Decimal Budget_Variance__c;
    global Decimal BudgetedCost;
    global List<OpportunityChangeEvent> Campaign;
    global ContentDocument CampaignImage;
    global Id CampaignImageId;
    global RecordType CampaignMemberRecordType;
    global Id CampaignMemberRecordTypeId;
    global List<CampaignMemberStatus> CampaignMemberStatuses;
    global List<CampaignMember> CampaignMembers;
    global Double Campaign_ROI__c;
    global List<Campaign> ChildCampaigns;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<ContentVersion> Content__r;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Double DB_Days__c;
    global String Description;
    global Boolean EDY_ORGCUSTOM__DB__c;
    global String EDY_ORGCUSTOM__Old_Name__c;
    global String Effectiveness_Rating__c;
    global List<EmailMessage> Emails;
    global Date EndDate;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global Double ExpectedResponse;
    global Decimal ExpectedRevenue;
    global String External_ID__c;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<CampaignFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global Decimal HierarchyActualCost;
    global Decimal HierarchyAmountAllOpportunities;
    global Decimal HierarchyAmountWonOpportunities;
    global Decimal HierarchyBudgetedCost;
    global Decimal HierarchyExpectedRevenue;
    global Integer HierarchyNumberOfContacts;
    global Integer HierarchyNumberOfConvertedLeads;
    global Integer HierarchyNumberOfLeads;
    global Integer HierarchyNumberOfOpportunities;
    global Integer HierarchyNumberOfResponses;
    global Integer HierarchyNumberOfWonOpportunities;
    global Double HierarchyNumberSent;
    global List<CampaignHistory> Histories;
    global Id Id;
    global Boolean IsActive;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global Date LastActivityDate;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global List<ListEmailRecipientSource> ListEmailRecipientSources;
    global List<ListEmail> ListEmails;
    global Boolean MayEdit;
    global String Name;
    global Integer NumberOfContacts;
    global Integer NumberOfConvertedLeads;
    global Integer NumberOfLeads;
    global Integer NumberOfOpportunities;
    global Integer NumberOfResponses;
    global Integer NumberOfWonOpportunities;
    global Double NumberSent;
    global List<OpenActivity> OpenActivities;
    global List<Opportunity> Opportunities;
    global User Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global Id ParentId;
    global List<PartnerFundRequest> PartnerFundRequests;
    global String Primary_Offer__c;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global String ROI_Chart__c;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global RecordType RecordType;
    global Id RecordTypeId;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskRelationChangeEvent> Relation;
    global String Revenue_Towards_Goal__c;
    global List<CampaignShare> Shares;
    global Date StartDate;
    global String Status;
    global Datetime SystemModstamp;
    global List<CampaignTag> Tags;
    global List<RecordRecommendation> Target;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global String Type;
    global List<TaskChangeEvent> What;
    global Double db_days_EndDate__c;
    global Double db_days_StartDate__c;
    global List<et4ae5__SMSDefinition__c> et4ae5__SMSDefinitions__r;
    global List<et4ae5__SMSDefinition__c> et4ae5__SMS_Definitions1__r;
    global List<et4ae5__SMSJunction__c> et4ae5__SMS_Definitions__r;
    global List<et4ae5__SendDefinition__c> et4ae5__SendDefinitions__r;
    global List<et4ae5__SendDefinition__c> et4ae5__Send_Definitions1__r;
    global List<et4ae5__SendJunction__c> et4ae5__Send_Definitions__r;
    global List<mcdm_15__ApprovalsPageSettings__c> mcdm_15__Campaign__r;
    global String mcdm_15__LinkedBusinessUnit__c;
    global Id mcdm_15__LinkedJourney__c;
    global mcdm_15__MarketingCloudLinkedJourney__c mcdm_15__LinkedJourney__r;
    global String pi__Pardot_Campaign_Id__c;
    global Boolean pi__Pardot_Has_Dependencies__c;

    global Campaign () 
    {
    }
}