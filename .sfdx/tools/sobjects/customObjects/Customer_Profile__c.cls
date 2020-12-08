// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Customer_Profile__c {
    global Date Activation_Date__c;
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
    global String Contract__c;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Date Deactivation_Date__c;
    global Double Dependents__c;
    global String Device_Protection__c;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global String Email__c;
    global List<EventRelation> EventRelations;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ContentVersion> FirstPublishLocation;
    global String First_Name__c;
    global String First_Year_Attrition_Outcome__c;
    global String Gender__c;
    global Double Homeowner__c;
    global Id Id;
    global String Income_Range__c;
    global Double Index__c;
    global String Internet_Service__c;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global String Last_Name__c;
    global Double Likelihood_to_Attrit_in_1st_Year__c;
    global List<PartnerNetworkRecordConnection> LocalRecord;
    global String Mailing_City__c;
    global String Mailing_State__c;
    global String Mailing_street__c;
    global String Marital_Status__c;
    global Boolean MayEdit;
    global Double Monthly_Charges__c;
    global String Multiple_Lines__c;
    global String Name;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global String Occupation__c;
    global String Online_Backup__c;
    global String Online_Security__c;
    global SObject Owner;
    global Id OwnerId;
    global Double Paperless_Billing__c;
    global List<Opportunity__hd> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global List<PartnerNetworkRecordConnection> ParentRecord;
    global List<PartnerNetworkRecordConnection> PartnerRecord;
    global Double Partner__c;
    global String Payment_Method__c;
    global Double Phone_Service__c;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskRelationChangeEvent> Relation;
    global Double Senior_Citizen__c;
    global List<Customer_Profile__Share> Shares;
    global String Streaming_Movies__c;
    global String Streaming_TV__c;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<Customer_Profile__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global String Tech_Support__c;
    global List<TopicAssignment> TopicAssignments;
    global Double Total_Charges__c;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;

    global Customer_Profile__c () 
    {
    }
}