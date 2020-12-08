// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class LiveChatTranscript {
    global Integer Abandoned;
    global Account Account;
    global Id AccountId;
    global List<ActivityHistory> ActivityHistories;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global Integer AverageResponseTimeOperator;
    global Integer AverageResponseTimeVisitor;
    global String Body;
    global String Browser;
    global String BrowserLanguage;
    global Case Case;
    global Id CaseId;
    global List<Case> Cases;
    global String Channel_Name__c;
    global String Channel__c;
    global Integer ChatDuration;
    global Id ChatEndUserId__c;
    global User ChatEndUserId__r;
    global String ChatKey;
    global String ChatStartURL__c;
    global List<CombinedAttachment> CombinedAttachments;
    global Contact Contact;
    global Id ContactId;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<ConversationEntry> ConversationEntries;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global List<EmailMessage> Emails;
    global Datetime EndTime;
    global String EndedBy;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<LiveChatTranscriptFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<LiveChatTranscriptHistory> Histories;
    global Id Id;
    global String IpAddress;
    global Boolean IsChatbotSession;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Lead Lead;
    global Id LeadId;
    global LiveChatButton LiveChatButton;
    global Id LiveChatButtonId;
    global LiveChatDeployment LiveChatDeployment;
    global Id LiveChatDeploymentId;
    global List<LiveChatTranscriptEvent> LiveChatTranscriptEvents;
    global List<LiveChatTranscriptSkill> LiveChatTranscriptSkills;
    global LiveChatVisitor LiveChatVisitor;
    global Id LiveChatVisitorId;
    global String Location;
    global Integer MaxResponseTimeOperator;
    global Integer MaxResponseTimeVisitor;
    global Boolean MayEdit;
    global String Name;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global Integer OperatorMessageCount;
    global SObject Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global String Platform;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global String ReferrerUri;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskRelationChangeEvent> Relation;
    global Datetime RequestTime;
    global String SCQuickSetup__CurrentEmail__c;
    global String ScreenResolution;
    global Skill Skill;
    global Id SkillId;
    global List<CaseChangeEvent> Source;
    global Datetime StartTime;
    global String Status;
    global String Subject__c;
    global String SupervisorTranscriptBody;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global String URLsrc__c;
    global String UserAgent;
    global Integer VisitorMessageCount;
    global String VisitorNetwork;
    global Integer WaitTime;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;

    global LiveChatTranscript () 
    {
    }
}