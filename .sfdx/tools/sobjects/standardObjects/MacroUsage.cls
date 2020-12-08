// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class MacroUsage {
    global String AppContext;
    global Integer ConditionCount;
    global String ContextRecord;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Integer DurationInMs;
    global Integer ExecutedInstructionCount;
    global Datetime ExecutionEndTime;
    global String ExecutionState;
    global String FailureReason;
    global Id Id;
    global Integer InstructionCount;
    global Boolean IsDeleted;
    global Boolean IsFromBulk;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Macro Macro;
    global Id MacroId;
    global Boolean MayEdit;
    global String Name;
    global SObject Owner;
    global Id OwnerId;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global List<FlowRecordRelation> RelatedRecord;
    global Datetime SystemModstamp;
    global User User;
    global Id UserId;

    global MacroUsage () 
    {
    }
}