// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class orders__x {
    global List<AttachedContentDocument> AttachedContentDocuments;
    global List<AttachedContentNote> AttachedContentNotes;
    global List<CombinedAttachment> CombinedAttachments;
    global List<ContentDocumentLink> ContentDocumentLinks;
    global String DisplayUrl;
    global String ExternalId;
    global List<EntitySubscription> FeedSubscriptionsForEntity;
    global List<ContentVersion> FirstPublishLocation;
    global Id Id;
    global Boolean MayEdit;
    global List<FeedItem> Parent;
    global List<NetworkActivityAudit> ParentEntities;
    global Id accountId__c;
    global Account accountId__r;
    global Id caseId__c;
    global Case caseId__r;
    global String id__c;
    global String name__c;
    global Datetime orderDate__c;
    global String sourceSystem__c;
    global String status__c;
    global Double totalPrice__c;
    global String trackingNumber__c;

    global orders__x () 
    {
    }
}