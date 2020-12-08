// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class EventChangeEvent {
    global Account Account;
    global Id AccountId;
    global Date ActivityDate;
    global Datetime ActivityDateTime;
    global Object ChangeEventHeader;
    global Double CheckOutAccuracy__c;
    global Datetime CheckOutDate__c;
    global Double CheckOutDistanceFromRecordMi__c;
    global Double CheckOutLatitude__c;
    global Double CheckOutLongitude__c;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Datetime CreatedDate__c;
    global Double CreatedLatitude__c;
    global Double CreatedLocationAccuracy__c;
    global Boolean CreatedLocationVerified__c;
    global Double CreatedLongitude__c;
    global Double DB_Days__c;
    global String Description;
    global Double DistanceFromRecordMi__c;
    global Integer DurationInMinutes;
    global String External_ID__c;
    global Double FSL__Count_of_Events__c;
    global Double FSL__Count_of_Tasks__c;
    global String FSL__Event_Type__c;
    global String GroupEventType;
    global Id Id;
    global Boolean IsAllDayEvent;
    global Boolean IsChild;
    global Boolean IsGroupEvent;
    global Boolean IsPrivate;
    global Boolean IsRecurrence;
    global Boolean IsRecurrence2Exclusion;
    global Boolean IsReminderSet;
    global Boolean IsVisibleInSelfService;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global Datetime LastModifiedDate__c;
    global String Location;
    global User Owner;
    global Id OwnerId;
    global RecordType RecordType;
    global Id RecordTypeId;
    global String Recurrence2PatternText;
    global String Recurrence2PatternVersion;
    global Event RecurrenceActivity;
    global Id RecurrenceActivityId;
    global Integer RecurrenceDayOfMonth;
    global Integer RecurrenceDayOfWeekMask;
    global Date RecurrenceEndDateOnly;
    global String RecurrenceInstance;
    global Integer RecurrenceInterval;
    global String RecurrenceMonthOfYear;
    global Datetime RecurrenceStartDateTime;
    global String RecurrenceTimeZoneSidKey;
    global String RecurrenceType;
    global Datetime ReminderDateTime;
    global String ReplayId;
    global String ShowAs;
    global String Subject;
    global String Type;
    global String Type__c;
    global SObject What;
    global Integer WhatCount;
    global Id WhatId;
    global SObject Who;
    global Integer WhoCount;
    global Id WhoId;
    global String analyticsdemo_batch_id__c;
    global Double db_days_ActivityDate__c;
    global Double db_hours_ActivityDateTime__c;
    global Double db_hours_CheckOutDate__c;
    global Double db_hours_EndDateTime__c;
    global Double db_hours_RecurrenceStartDateTime__c;
    global Double db_hours_StartDateTime__c;
    global String pi__pardot_source_id__c;

    global EventChangeEvent () 
    {
    }
}