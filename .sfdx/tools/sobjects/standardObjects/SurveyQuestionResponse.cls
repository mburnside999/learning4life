// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class SurveyQuestionResponse {
    global String ChoiceValue;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String Datatype;
    global Datetime DateTimeValue;
    global Date DateValue;
    global Id Id;
    global SurveyInvitation Invitation;
    global Id InvitationId;
    global Boolean IsDeleted;
    global Boolean IsLocked;
    global Boolean IsTrueOrFalse;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Boolean MayEdit;
    global Integer NumberValue;
    global List<ProcessInstance> ProcessInstances;
    global List<ProcessInstanceHistory> ProcessSteps;
    global SurveyQuestion Question;
    global SurveyQuestionChoice QuestionChoice;
    global Id QuestionChoiceId;
    global Id QuestionId;
    global Integer Rank;
    global List<FlowRecordRelation> RelatedRecord;
    global SurveyResponse Response;
    global Id ResponseId;
    global String ResponseShortText;
    global String ResponseValue;
    global SurveyVersion SurveyVersion;
    global Id SurveyVersionId;
    global Datetime SystemModstamp;
    global List<TopicAssignment> TopicAssignments;

    global SurveyQuestionResponse () 
    {
    }
}