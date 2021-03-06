// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ServiceResourceCapacity {
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global Double CapacityInHours;
    global Integer CapacityInWorkItems;
    global String CapacityNumber;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Date EndDate;
    global String External_ID__c;
    global Boolean FSLDemoTools_Master_Data__c;
    global Double FSL__HoursInUse__c;
    global Double FSL__Last_Updated_Epoch__c;
    global Double FSL__MinutesUsed__c;
    global Double FSL__Work_Items_Allocated__c;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ServiceResourceCapacityFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<ServiceResourceCapacityHistory> Histories;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Boolean MayEdit;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<FlowRecordRelation> RelatedRecord;
    global ServiceResource ServiceResource;
    global Id ServiceResourceId;
    global Date StartDate;
    global Datetime SystemModstamp;
    global String TimePeriod;
    global List<TopicAssignment> TopicAssignments;

    global ServiceResourceCapacity () 
    {
    }
}