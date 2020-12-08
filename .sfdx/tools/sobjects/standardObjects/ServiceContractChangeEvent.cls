// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ServiceContractChangeEvent {
    global Account Account;
    global Id AccountId;
    global Datetime ActivationDate;
    global String ApprovalStatus;
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
    global Contact Contact;
    global Id ContactId;
    global String ContractNumber;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Description;
    global Date EndDate;
    global String External_ID__c;
    global Id Id;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Integer LineItemCount;
    global String Name;
    global User Owner;
    global Id OwnerId;
    global ServiceContract ParentServiceContract;
    global Id ParentServiceContractId;
    global Pricebook2 Pricebook2;
    global Id Pricebook2Id;
    global String ReplayId;
    global ServiceContract RootServiceContract;
    global Id RootServiceContractId;
    global Address ShippingAddress;
    global String ShippingCity;
    global String ShippingCountry;
    global String ShippingGeocodeAccuracy;
    global Decimal ShippingHandling;
    global Double ShippingLatitude;
    global Double ShippingLongitude;
    global String ShippingPostalCode;
    global String ShippingState;
    global String ShippingStreet;
    global String SpecialTerms;
    global Date StartDate;
    global Decimal Subtotal;
    global Decimal Tax;
    global Integer Term;
    global Decimal TotalPrice;

    global ServiceContractChangeEvent () 
    {
    }
}