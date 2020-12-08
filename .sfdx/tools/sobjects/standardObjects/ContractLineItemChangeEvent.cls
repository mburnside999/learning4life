// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ContractLineItemChangeEvent {
    global Asset Asset;
    global Id AssetId;
    global Object ChangeEventHeader;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Double DB_Days__c;
    global String Description;
    global Double Discount;
    global Date EndDate;
    global Id Id;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global String LineItemNumber;
    global ContractLineItem ParentContractLineItem;
    global Id ParentContractLineItemId;
    global PricebookEntry PricebookEntry;
    global Id PricebookEntryId;
    global Double Quantity;
    global String ReplayId;
    global ContractLineItem RootContractLineItem;
    global Id RootContractLineItemId;
    global ServiceContract ServiceContract;
    global Id ServiceContractId;
    global Date StartDate;
    global Decimal UnitPrice;

    global ContractLineItemChangeEvent () 
    {
    }
}