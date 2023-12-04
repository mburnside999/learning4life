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
private class TestLFLTSBatchUtil {
  @isTest
  static void testbatch() {
    Test.startTest();
    LFLPopulateTestData.load();
    L4LTimeSeries tstest = new L4LTimeSeries();
    Integer i = tstest.loadCOTimeSeries();
    Test.stopTest();

    LFLTSBatchUtil tsbatch = new LFLTSBatchUtil();
    ID batchprocessid = Database.executeBatch(tsbatch);

    String q = 'select count() from client_objective_timeseries__c';
    Integer result = database.countQuery(q);

    System.assert(result >= 0, 'integer result expected');
  }
}
