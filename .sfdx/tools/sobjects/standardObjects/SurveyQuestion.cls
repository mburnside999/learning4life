// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class SurveyQuestion {
    global List<ActivityHistory> ActivityHistories;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global String DeveloperName;
    global List<EmailMessage> Emails;
    global List<EventRelation> EventRelations;
    global List<Event> Events;
    global Id Id;
    global Boolean IsDeleted;
    global Boolean IsDeprecated;
    global Boolean IsLocked;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Boolean MayEdit;
    global String Name;
    global List<OpenActivity> OpenActivities;
    global List<SurveyQuestionChoice> QuestionChoices;
    global String QuestionName;
    global String QuestionType;
    global List<FlowRecordRelation> RelatedRecord;
    global List<OutgoingEmail> RelatedTo;
    global List<TaskRelationChangeEvent> Relation;
    global SurveyPage SurveyPage;
    global Id SurveyPageId;
    global List<SurveyQuestionResponse> SurveyQuestionResponses;
    global List<SurveyQuestionScore> SurveyQuestionScores;
    global SurveyVersion SurveyVersion;
    global Id SurveyVersionId;
    global Datetime SystemModstamp;
    global List<TaskRelation> TaskRelations;
    global List<Task> Tasks;
    global List<TopicAssignment> TopicAssignments;
    global List<TaskChangeEvent> What;

    global SurveyQuestion () 
    {
    }
}