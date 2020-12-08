// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class DuplicateJob {
    global List<DuplicateRecordSet> AllDuplicateRecordSets;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global DuplicateJobDefinition DuplicateJobDefinition;
    global Id DuplicateJobDefinitionId;
    global List<DuplicateJobMatchingRule> DuplicateJobMatchingRules;
    global String DuplicateJobStatus;
    global Datetime EndDateTime;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastReferencedDate;
    global Datetime LastViewedDate;
    global Boolean MayEdit;
    global String Name;
    global Integer NumDuplicateRecordItems;
    global Integer NumDuplicateRecordSets;
    global Integer NumRecordsScanned;
    global List<FlowRecordRelation> RelatedRecord;
    global ListView ResultListView;
    global Id ResultListViewId;
    global Datetime StartDateTime;
    global Datetime SystemModstamp;

    global DuplicateJob () 
    {
    }
}