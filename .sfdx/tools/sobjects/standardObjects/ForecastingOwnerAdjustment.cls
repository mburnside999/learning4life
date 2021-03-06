// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class ForecastingOwnerAdjustment {
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String ForecastCategoryName;
    global User ForecastOwner;
    global Id ForecastOwnerId;
    global ForecastingItem ForecastingItem;
    global String ForecastingItemCategory;
    global Id ForecastingItemId;
    global ForecastingType ForecastingType;
    global Id ForecastingTypeId;
    global Id Id;
    global Boolean IsAmount;
    global Boolean IsDeleted;
    global Boolean IsQuantity;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Decimal OwnerAdjustedAmount;
    global Double OwnerAdjustedQuantity;
    global String OwnerAdjustmentNote;
    global Period Period;
    global Id PeriodId;
    global String ProductFamily;
    global List<FlowRecordRelation> RelatedRecord;
    global Date StartDate;
    global Datetime SystemModstamp;
    global Territory2 Territory2;
    global Id Territory2Id;

    global ForecastingOwnerAdjustment () 
    {
    }
}