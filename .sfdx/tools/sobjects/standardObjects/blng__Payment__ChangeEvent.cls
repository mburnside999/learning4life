// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class blng__Payment__ChangeEvent {
    global Object ChangeEventHeader;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Id Id;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global String Name;
    global String ReplayId;
    global Id blng__Account__c;
    global Decimal blng__AllocatedtoDebitNoteLines__c;
    global Decimal blng__AllocatedtoInvoiceLines__c;
    global Decimal blng__AllocatedtoInvoices__c;
    global String blng__AllocationStatus__c;
    global Decimal blng__Allocations__c;
    global Decimal blng__Amount__c;
    global Decimal blng__Balance__c;
    global String blng__BankAccountName__c;
    global String blng__BankAccountNumber__c;
    global String blng__BankAccountType__c;
    global String blng__BankName__c;
    global String blng__BankRoutingCode__c;
    global Decimal blng__BaseCurrencyAmount__c;
    global Date blng__BaseCurrencyFXDate__c;
    global Double blng__BaseCurrencyFXRate__c;
    global String blng__BaseCurrency__c;
    global Id blng__BillingFinanceBook__c;
    global Id blng__BillingFinancePeriod__c;
    global String blng__CardCodeResponse__c;
    global String blng__CardExpirationMonth__c;
    global String blng__CardExpirationYear__c;
    global String blng__CardType__c;
    global Date blng__CheckDate__c;
    global String blng__CheckNumber__c;
    global Id blng__FinancePeriod__c;
    global Id blng__GLRule__c;
    global Id blng__GLTreatment__c;
    global String blng__GatewayID__c;
    global Decimal blng__ImpactAmount__c;
    global Id blng__Invoice__c;
    global Id blng__LegalEntity__c;
    global String blng__Notes__c;
    global Id blng__PaidBy__c;
    global Date blng__PaymentDate__c;
    global String blng__PaymentDescription__c;
    global String blng__PaymentGatewayToken__c;
    global Id blng__PaymentGateway__c;
    global Id blng__PaymentMethod__c;
    global String blng__PaymentMode__c;
    global String blng__PaymentType__c;
    global Decimal blng__RefundsAllocations__c;
    global Decimal blng__RefundsUnallocations__c;
    global Decimal blng__Refunds__c;
    global String blng__RequestCreditCardNumber__c;
    global String blng__RequestTypeOfPayment__c;
    global String blng__Status__c;
    global Id blng__Transaction__c;
    global Decimal blng__UnallocatedfromDebitNoteLines__c;
    global Decimal blng__UnallocatedfromInvoiceLines__c;
    global Decimal blng__UnallocatedfromInvoices__c;
    global Decimal blng__Unallocations__c;

    global blng__Payment__ChangeEvent () 
    {
    }
}