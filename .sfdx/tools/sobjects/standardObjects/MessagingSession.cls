// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class MessagingSession {
    global Datetime AcceptTime;
    global Integer AgentMessageCount;
    global String AgentType;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global Case Case;
    global Id CaseId;
    global List<Case> Cases;
    global String ChannelEndUserFormula;
    global String ChannelGroup;
    global String ChannelIntent;
    global String ChannelKey;
    global String ChannelLocale;
    global String ChannelName;
    global String ChannelType;
    global String Channel__c;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<ConversationEntry> ConversationEntries;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Datetime EndTime;
    global Account EndUserAccount;
    global Id EndUserAccountId;
    global Contact EndUserContact;
    global Id EndUserContactId;
    global Integer EndUserMessageCount;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<MessagingSessionFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<MessagingSessionHistory> Histories;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Lead Lead;
    global Id LeadId;
    global Boolean MayEdit;
    global MessagingChannel MessagingChannel;
    global Id MessagingChannelId;
    global MessagingEndUser MessagingEndUser;
    global Id MessagingEndUserId;
    global String Name;
    global Opportunity Opportunity;
    global Id OpportunityId;
    global String Origin;
    global SObject Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global String PreviewDetails;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global String SessionKey;
    global List<CaseChangeEvent> Source;
    global Datetime StartTime;
    global String Status;
    global String Subject__c;
    global Datetime SystemModstamp;
    global User TargetUser;
    global Id TargetUserId;
    global String URLsrc__c;
    global List<PendingServiceRouting> WorkItem;

    global MessagingSession () 
    {
    }
}