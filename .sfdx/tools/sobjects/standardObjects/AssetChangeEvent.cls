// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class AssetChangeEvent {
    global Account Account;
    global Id AccountId;
    global Account AssetProvidedBy;
    global Id AssetProvidedById;
    global Account AssetServicedBy;
    global Id AssetServicedById;
    global String Asset_Combo__c;
    global Id CC_Order_Item__c;
    global Id CC_Order__c;
    global Object ChangeEventHeader;
    global Contact Contact;
    global Id ContactId;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Boolean Current_Users_Asset__c;
    global Boolean Current_Users_Companys_Asset__c;
    global Double DB_Days__c;
    global String Description;
    global String Email__c;
    global String Entitlement_Status__c;
    global String External_ID__c;
    global Id Id;
    global String Image__c;
    global Date InstallDate;
    global Boolean IsCompetitorProduct;
    global Boolean IsInternal;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Double Latitude__c;
    global Location Location;
    global Id LocationId;
    global Double Longitude__c;
    global String Name;
    global User Owner;
    global Id OwnerId;
    global Asset Parent;
    global Id ParentId;
    global String Performance_Status__c;
    global Decimal Price;
    global Product2 Product2;
    global Id Product2Id;
    global Date PurchaseDate;
    global Double Quantity;
    global RecordType RecordType;
    global Id RecordTypeId;
    global String ReplayId;
    global Asset RootAsset;
    global Id RootAssetId;
    global Boolean Scheduled_Servicing__c;
    global String SerialNumber;
    global Id Service_Contract__c;
    global String Service_Frequency_Weeks__c;
    global String Status;
    global String Suggested_Products__c;
    global String URLsrc__c;
    global Date UsageEndDate;
    global String Warranty_Indicator__c;
    global Double db_days_InstallDate__c;
    global Double db_days_PurchaseDate__c;
    global Double db_days_UsageEndDate__c;

    global AssetChangeEvent () 
    {
    }
}