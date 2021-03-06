// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Shipment {
    global List<ActivityHistory> ActivityHistories;
    global Datetime ActualDeliveryDate;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global SObject DeliveredTo;
    global Id DeliveredToId;
    global String Description;
    global Location DestinationLocation;
    global Id DestinationLocationId;
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global Datetime ExpectedDeliveryDate;
    global Boolean FSL_Late_Delivery__c;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ShipmentFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<ShipmentHistory> Histories;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Boolean MayEdit;
    global List<OpenActivity> OpenActivities;
    global SObject Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<ProductTransfer> ProductTransfers;
    global Id Product_Request__c;
    global ProductRequest Product_Request__r;
    global String Provider;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskRelationChangeEvent> Relation;
    global Address ShipFromAddress;
    global String ShipFromCity;
    global String ShipFromCountry;
    global String ShipFromGeocodeAccuracy;
    global Double ShipFromLatitude;
    global Double ShipFromLongitude;
    global String ShipFromPostalCode;
    global String ShipFromState;
    global String ShipFromStreet;
    global Address ShipToAddress;
    global String ShipToCity;
    global String ShipToCountry;
    global String ShipToGeocodeAccuracy;
    global Double ShipToLatitude;
    global Double ShipToLongitude;
    global String ShipToName;
    global String ShipToPostalCode;
    global String ShipToState;
    global String ShipToStreet;
    global String ShipmentNumber;
    global Location SourceLocation;
    global Id SourceLocationId;
    global String Status;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global String TrackingNumber;
    global String TrackingUrl;
    global List<TaskChangeEvent> What;

    global Shipment () 
    {
    }
}