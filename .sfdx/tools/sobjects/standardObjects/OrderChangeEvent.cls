// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class OrderChangeEvent {
    global Account Account;
    global Id AccountId;
    global User ActivatedBy;
    global Id ActivatedById;
    global Datetime ActivatedDate;
    global Contact BillToContact;
    global Id BillToContactId;
    global Address BillingAddress;
    global String BillingCity;
    global String BillingCountry;
    global String BillingGeocodeAccuracy;
    global Double BillingLatitude;
    global Double BillingLongitude;
    global String BillingPostalCode;
    global String BillingState;
    global String BillingStreet;
    global Object ChangeEventHeader;
    global User CompanyAuthorizedBy;
    global Id CompanyAuthorizedById;
    global Date CompanyAuthorizedDate;
    global Contract Contract;
    global Id ContractId;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Credit_Card_Expiration_Date__c;
    global String Credit_Card_Name__c;
    global String Credit_Card_Number__c;
    global Contact CustomerAuthorizedBy;
    global Id CustomerAuthorizedById;
    global Date CustomerAuthorizedDate;
    global Double DB_Days__c;
    global String Description;
    global Date EffectiveDate;
    global Date EndDate;
    global String External_ID__c;
    global Id Id;
    global String Indicator__c;
    global Boolean IsReductionOrder;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global String Name;
    global Opportunity Opportunity;
    global Id OpportunityId;
    global String OrderNumber;
    global String OrderReferenceNumber;
    global Order OriginalOrder;
    global Id OriginalOrderId;
    global User Owner;
    global Id OwnerId;
    global Date PoDate;
    global String PoNumber;
    global Pricebook2 Pricebook2;
    global Id Pricebook2Id;
    global Quote Quote;
    global Id QuoteId;
    global RecordType RecordType;
    global Id RecordTypeId;
    global String ReplayId;
    global Contact ShipToContact;
    global Id ShipToContactId;
    global Address ShippingAddress;
    global String ShippingCity;
    global String ShippingCountry;
    global String ShippingGeocodeAccuracy;
    global Double ShippingLatitude;
    global Double ShippingLongitude;
    global String ShippingPostalCode;
    global String ShippingState;
    global String ShippingStreet;
    global String Shipping_Method__c;
    global String Status;
    global String StatusCode;
    global Decimal TotalAmount;
    global String Track_It__c;
    global String Tracking_ID__c;
    global String Type;
    global String URLsrc__c;
    global Boolean blng__BillNow__c;
    global Decimal blng__BilledAmountwithouttax__c;
    global Decimal blng__BilledTax__c;
    global Id blng__BillingAccount__c;
    global String blng__BillingDayOfMonth__c;
    global Decimal blng__CanceledBillings__c;
    global String blng__InvoiceBatch__c;
    global Decimal blng__PendingBillings__c;
    global Decimal blng__TotalBilling__c;
    global Double db_days_EffectiveDate__c;

    global OrderChangeEvent () 
    {
    }
}