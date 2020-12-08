// This file is generated as an Apex representation of the
//     corresponding sObject and its fields.
// This read-only file is used by the Apex Language Server to
//     provide code smartness, and is deleted each time you
//     refresh your sObject definitions.
// To edit your sObjects and their fields, edit the corresponding
//     .object-meta.xml and .field-meta.xml files.

global class Milestone1_Project__ChangeEvent {
    global Id Account__c;
    global Object ChangeEventHeader;
    global User CreatedBy;
    global Id CreatedById;
    global Datetime CreatedDate;
    global Double DB_Days_Start__c;
    global Double DB_Days__c;
    global Date Deadline__c;
    global String Description__c;
    global Double Duration__c;
    global String External_ID__c;
    global String GoogleGanntUrl__c;
    global Id Id;
    global String ImportID__c;
    global Date Kickoff__c;
    global User LastModifiedBy;
    global Id LastModifiedById;
    global Datetime LastModifiedDate;
    global String Name;
    global Date Next_Project_Milestone_Due_Date__c;
    global Date Next_Project_Top_Milestone_Due_Date__c;
    global Double Number_of_Incomplete_Milestones__c;
    global Double Number_of_Incomplete_Top_Milestones__c;
    global SObject Owner;
    global Id OwnerId;
    global String Project_Status_Indicator__c;
    global String Project_Status__c;
    global String Project_stage__c;
    global String ReplayId;
    global String Status_BudgetExpenseSummary__c;
    global String Status_BudgetMiletoneEstimate__c;
    global String Status_Image_HoursSummary__c;
    global String Status_Image_OpenVComplete__c;
    global String Status_Img_OpenLateBlocked__c;
    global String Status_TasksOpenBlockedLate__c;
    global String Status_TasksOpenComplete__c;
    global String Status__c;
    global Boolean Template__c;
    global Double Total_Blocked_Task_Count__c;
    global Double Total_Complete_Task_Count__c;
    global Decimal Total_Expense_Budget__c;
    global Decimal Total_Expense_Budget_from_Milestones__c;
    global Decimal Total_Expense_Estimate__c;
    global Decimal Total_Expense_Incurred__c;
    global Double Total_Hours_Budget__c;
    global Double Total_Hours_Budget_from_Milestones__c;
    global Double Total_Hours_Estimate__c;
    global Double Total_Hours_Incurred__c;
    global Double Total_Late_Task_Count__c;
    global Double Total_Open_Task_Count__c;
    global Double db_days_Deadline__c;
    global Double db_days_Kickoff__c;

    global Milestone1_Project__ChangeEvent () 
    {
    }
}