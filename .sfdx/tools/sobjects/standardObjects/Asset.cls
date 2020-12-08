// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Asset {
    global Account Account;
    global Id AccountId;
    global List<ActivityHistory> ActivityHistories;
    global List<EntitlementChangeEvent> Asset;
    global Integer AssetLevel;
    global Account AssetProvidedBy;
    global Id AssetProvidedById;
    global Account AssetServicedBy;
    global Id AssetServicedById;
    global String Asset_Combo__c;
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<Attachment> Attachments;
    global Id CC_Order_Item__c;
    global ccrz__E_OrderItem__c CC_Order_Item__r;
    global Id CC_Order__c;
    global ccrz__E_Order__c CC_Order__r;
    global List<Case> Cases;
    global List<Asset> ChildAssets;
    global List<CombinedAttachment> CombinedAttachments;
    global Contact Contact;
    global Id ContactId;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global List<ContractLineItem> ContractLineItems;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Boolean Current_Users_Asset__c;
    global Boolean Current_Users_Companys_Asset__c;
    global Double DB_Days__c;
    global String Description;
    global String Email__c;
    global List<EmailMessage> Emails;
    global String Entitlement_Status__c;
    global List<Entitlement> Entitlements;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global String External_ID__c;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<AssetFeed> Feeds;
    global List<ContentVersion> FirstPublishLocation;
    global List<AssetHistory> Histories;
    global Id Id;
    global String Image__c;
    global Date InstallDate;
    global Boolean IsCompetitorProduct;
    global Boolean IsDeleted;
    global Boolean IsInternal;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Double Latitude__c;
    global Location Location;
    global Id LocationId;
    global Double Longitude__c;
    global List<MaintenanceAsset> MaintenanceAssets;
    global Boolean MayEdit;
    global String Name;
    global List<NetworkUserHistoryRecent> NetworkUserHistoryRecentToRecord;
    global List<Note> Notes;
    global List<NoteAndAttachment> NotesAndAttachments;
    global List<OpenActivity> OpenActivities;
    global User Owner;
    global Id OwnerId;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global Id ParentId;
    global String Performance_Status__c;
    global Decimal Price;
    global List<AssetRelationship> PrimaryAssets;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global Product2 Product2;
    global Id Product2Id;
    global String ProductCode;
    global String ProductDescription;
    global String ProductFamily;
    global Date PurchaseDate;
    global Double Quantity;
    global List<RecordActionHistory> RecordActionHistories;
    global List<RecordAction> RecordActions;
    global RecordType RecordType;
    global Id RecordTypeId;
    global List<AssetRelationship> RelatedAssets;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskRelationChangeEvent> Relation;
    global List<ReturnOrderLineItem> ReturnOrderLineItems;
    global List<AssetChangeEvent> RootAsset;
    global Id RootAssetId;
    global Boolean Scheduled_Servicing__c;
    global String SerialNumber;
    global List<ServiceAppointment> ServiceAppointments;
    global List<ServiceResource> ServiceResources;
    global Id Service_Contract__c;
    global ServiceContract Service_Contract__r;
    global String Service_Frequency_Weeks__c;
    global List<AssetShare> Shares;
    global String Status;
    global String StockKeepingUnit;
    global String Suggested_Products__c;
    global Datetime SystemModstamp;
    global List<AssetTag> Tags;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global String URLsrc__c;
    global Date UsageEndDate;
    global String Warranty_Indicator__c;
    global List<TaskChangeEvent> What;
    global List<WorkOrderLineItem> WorkOrderLineItems;
    global List<WorkOrder> WorkOrders;
    global Double db_days_InstallDate__c;
    global Double db_days_PurchaseDate__c;
    global Double db_days_UsageEndDate__c;

    global Asset () 
    {
    }
}