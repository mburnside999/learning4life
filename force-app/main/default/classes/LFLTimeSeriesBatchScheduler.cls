/**************************************************************
 * @name LFLTimeSeriesBatchScheduler
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description
 *
 */

global class LFLTimeSeriesBatchScheduler implements Schedulable {
  global void execute(SchedulableContext SC) {
    TimeSeries_Log__c log = new TimeSeries_Log__c();
    log.comments__c = 'Started client objective timeseries run';

    insert log;

    System.debug(
      'in loadCOTimeSeries(): successfully logged START to TimeSeries_Log__c(): ' +
      log
    );

    String runId = [SELECT name FROM TimeSeries_Log__c WHERE id = :log.Id].Name;

    LFLTimeSeriesBatch tsbatch = new LFLTimeSeriesBatch();

    tsbatch.query =
      'Select Id,Client__c,Client_Objective_Notes__c, Date_Absorbed__c,' +
      'Date_Acquired__c, Date_CIP__c, Date_Held__c, Date_Introduced__c,' +
      'Days_Since_Tested_Correct__c, Days_Since_Tested__c, Frequency__c,' +
      'Name, Objective__c, Program_Name__c, Area__c, Stage__c,' +
      'Re_Test_Recommended__c, Status__c, Active__c FROM Client_Objective__c ';

    tsbatch.email = 'mburnside@salesforce.com';
    tsbatch.runId = runId;
    ID batchprocessid = Database.executeBatch(tsbatch);
  }
}
