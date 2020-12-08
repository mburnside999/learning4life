// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ccrz__E_Cart__ChangeEvent {
    global Boolean Budget_Approval_Requested__c;
    global Boolean Budget_Approved_for_Checkout__c;
    global Decimal Budget_Override__c;
    global Object ChangeEventHeader;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Boolean Credit_Override_Approved_for_Checkout__c;
    global Boolean Credit_Override_Requested__c;
    global Decimal Credit_Override__c;
    global String Custom_Message_Text__c;
    global String Custom_Message_Type__c;
    global Id Id;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global String Name;
    global Id Opportunity__c;
    global SObject Owner;
    global Id OwnerId;
    global String ReplayId;
    global Double Reward_Points_Applied__c;
    global Id ccrz__Account__c;
    global Boolean ccrz__ActiveCart__c;
    global Decimal ccrz__AdjustmentAmount__c;
    global String ccrz__AdjustmentReason__c;
    global Boolean ccrz__AnonymousId__c;
    global Id ccrz__BillTo__c;
    global String ccrz__BuyerCompanyName__c;
    global String ccrz__BuyerEmail__c;
    global String ccrz__BuyerFirstName__c;
    global String ccrz__BuyerLastName__c;
    global String ccrz__BuyerMobilePhone__c;
    global String ccrz__BuyerPhone__c;
    global String ccrz__CCEmailAddress__c;
    global String ccrz__CartId__c;
    global String ccrz__CartStatus__c;
    global String ccrz__CartType__c;
    global Id ccrz__Contact__c;
    global String ccrz__ContractId__c;
    global String ccrz__CurrencyISOCode__c;
    global String ccrz__EffectiveAccountID__c;
    global String ccrz__EncryptedId__c;
    global String ccrz__Name__c;
    global String ccrz__Note__c;
    global String ccrz__PONumber__c;
    global String ccrz__PaymentMethod__c;
    global Datetime ccrz__RepricedDate__c;
    global Date ccrz__RequestDate__c;
    global String ccrz__SessionId__c;
    global Decimal ccrz__ShipAmount__c;
    global Boolean ccrz__ShipComplete__c;
    global Decimal ccrz__ShipDiscountAmount__c;
    global String ccrz__ShipMethod__c;
    global String ccrz__ShipStructure__c;
    global Id ccrz__ShipTo__c;
    global String ccrz__Storefront__c;
    global Decimal ccrz__SubtotalAmount__c;
    global Decimal ccrz__TaxAmount__c;
    global Boolean ccrz__TaxExemptFlag__c;
    global Decimal ccrz__TaxSubTotalAmount__c;
    global Decimal ccrz__TotalAmount__c;
    global Decimal ccrz__TotalDiscount__c;
    global Double ccrz__TotalQuantity__c;
    global Decimal ccrz__TotalSurcharge__c;
    global Id ccrz__User__c;
    global String ccrz__ValidationStatus__c;

    global ccrz__E_Cart__ChangeEvent () 
    {
    }
}