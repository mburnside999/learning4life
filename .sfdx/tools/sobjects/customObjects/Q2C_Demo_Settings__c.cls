// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Q2C_Demo_Settings__c {
    global String Approver_Email__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global String BaseURL__c;
    global List<CombinedAttachment> CombinedAttachments;
    global String Company_City__c;
    global String Company_Country__c;
    global String Company_Email__c;
    global String Company_Fax__c;
    global String Company_Image_Height__c;
    global String Company_Image_URL__c;
    global String Company_Image_Width__c;
    global String Company_Name__c;
    global String Company_Phone__c;
    global String Company_Postal_Code__c;
    global String Company_Primary_Color__c;
    global String Company_Slogan__c;
    global String Company_State__c;
    global String Company_Street__c;
    global List<ContactRequest> ContactRequests;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Credit_Note_Line_Product_Name__c;
    global Boolean DataCannon_Trigger_Disabler__c;
    global String Debit_Note_Line_Product_Name__c;
    global Double Default_Approval_Tier_1__c;
    global Double Default_Approval_Tier_2__c;
    global Double Default_Approval_Tier_3__c;
    global Boolean Delete_Contracted_Prices__c;
    global Double Discount_Variation__c;
    global List<DuplicateRecordItem> DuplicateRecordItems;
    global Boolean Enforce_PO_Logic__c;
    global List<EventRelation> EventRelations;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ContentVersion> FirstPublishLocation;
    global Id Id;
    global Boolean InitBill__c;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global List<PartnerNetworkRecordConnection> LocalRecord;
    global String Master_Quote__c;
    global Boolean MayEdit;
    global String Name;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global Double Number_of_Records__c;
    global List<Opportunity__hd> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global List<PartnerNetworkRecordConnection> ParentRecord;
    global List<PartnerNetworkRecordConnection> PartnerRecord;
    global String Password__c;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global Boolean Randomize_Discounts__c;
    global Boolean Randomize_Quantity__c;
    global Boolean Randomize_Term__c;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<CollaborationGroupRecord> RecordAssociatedGroups;
    global List<FlowRecordRelation> RelatedRecord;
    global List<TaskRelationChangeEvent> Relation;
    global Date Reporting_End_Date__c;
    global Date Reporting_Start_Date__c;
    global SObject SetupOwner;
    global Id SetupOwnerId;
    global List<SurveySubject> SurveySubjectEntities;
    global Datetime SystemModstamp;
    global List<Q2C_Demo_Settings__Tag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<TopicAssignment> TopicAssignments;
    global String Version__c;
    global List<TaskChangeEvent> What;
    global List<PendingServiceRouting> WorkItem;

    global Q2C_Demo_Settings__c () 
    {
    }
}