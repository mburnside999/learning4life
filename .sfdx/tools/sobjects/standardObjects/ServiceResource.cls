// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ServiceResource {
    global Account Account;
    global Id AccountId;
    global List<ActivityHistory> ActivityHistories;
    global Decimal Additional_Job_Revenue__c;
    global Double Additional_Jobs_Scheduled__c;
    global Asset Asset;
    global Id AssetId;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global Id Contractor_s_Service_Territory__c;
    global ServiceTerritory Contractor_s_Service_Territory__r;
    global Decimal Cost_Per_Mile__c;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Description;
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global String External_ID__c;
    global Double FSL__Efficiency__c;
    global String FSL__GanttLabel__c;
    global Double FSL__Online_Offset__c;
    global List<FSL__Optimization_Request__c> FSL__Optimization_Requests__r;
    global String FSL__Picture_Link__c;
    global Double FSL__Priority__c;
    global Double FSL__Travel_Speed__c;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ServiceResourceFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global String Gantt_Color__c;
    global List<ServiceResourceHistory> Histories;
    global Id Id;
    global Boolean IsActive;
    global Boolean IsCapacityBased;
    global Boolean IsLocked;
    global Boolean IsOptimizationCapable;
    global Boolean Is_Contractor__c;
    global Double LastKnownLatitude;
    global Location LastKnownLocation;
    global Datetime LastKnownLocationDate;
    global Double LastKnownLongitude;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Location Location;
    global Id LocationId;
    global Boolean MayEdit;
    global String Name;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global Double Number_of_Jobs_Optimized__c;
    global Double Number_of_Jobs_Scheduled__c;
    global List<OpenActivity> OpenActivities;
    global Boolean Opt_KPI_Reset__c;
    global Boolean Optimization_KPI__c;
    global Decimal Optimization_Revenue__c;
    global Double Original_Travel_Time__c;
    global SObject Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<FlowRecordRelation> RelatedRecord;
    global Id RelatedRecordId;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskRelationChangeEvent> Relation;
    global List<ResourceAbsence> ResourceAbsences;
    global List<ResourcePreference> ResourcePreferences;
    global String ResourceType;
    global String Role__c;
    global List<AssignedResource> ServiceAppointments;
    global ServiceCrew ServiceCrew;
    global Id ServiceCrewId;
    global List<ServiceCrewMember> ServiceCrewMembers;
    global List<ServiceResourceCapacity> ServiceResourceCapacities;
    global List<ServiceResourceSkill> ServiceResourceSkills;
    global List<ServiceTerritoryMember> ServiceTerritories;
    global List<ServiceAppointment> Service_Appointments__r;
    global List<Shift> ShiftServiceResources;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TimeSheet> TimeSheets;
    global List<TopicAssignment> TopicAssignments;
    global Id Tracker_Contact__c;
    global Contact Tracker_Contact__r;
    global Double Travel_Delta__c;
    global Decimal Travel_Savings__c;
    global Double Updated_Travel_Time__c;
    global String User_Type__c;
    global List<TaskChangeEvent> What;

    global ServiceResource () 
    {
    }
}