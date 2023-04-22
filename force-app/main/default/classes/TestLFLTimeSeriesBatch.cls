@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLTimeSeriesBatch
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLTimeSeriesBatch
 *
 */

private class TestLFLTimeSeriesBatch {
  /*******************************************************************************************************
   * @description Test executeBatch
   * @param void
   *
   *
   * @example
   * TestLFLTimeSeriesBatch.testbatch();
   */

  @isTest
  static void testbatch() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    LFLTimeSeriesBatch tsbatch = new LFLTimeSeriesBatch();

    tsbatch.query =
      'Select Id,Client__c,Client_Objective_Notes__c, Date_Absorbed__c,' +
      'Date_Acquired__c, Date_CIP__c, Date_Held__c, Date_Introduced__c,' +
      'Days_Since_Tested_Correct__c, Days_Since_Tested__c, Frequency__c,' +
      'Name, Objective__c, Program_Name__c, Area__c, Stage__c,' +
      'Re_Test_Recommended__c, Status__c, Active__c FROM Client_Objective__c limit 10';

    tsbatch.email = 'mburnside@salesforce.com';
    tsbatch.runId = 'test';

    ID batchprocessid = Database.executeBatch(tsbatch);

    String q = 'select count() from client_objective_timeseries__c';
    Integer i = database.countQuery(q);

    System.assert(i >= 0, 'integer result expected');
  }
}
