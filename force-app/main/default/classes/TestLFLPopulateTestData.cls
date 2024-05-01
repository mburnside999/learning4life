@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLPopulateTestData
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLPopulateTestData
 *
 */

private class TestLFLPopulateTestData {
  /*******************************************************************************************************
   * @description Test load method
   * @param void
   *
   *
   * @example
   * TestLFLPopulateTestData.testLoad();
   */

  @isTest
  static void testLoad() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    Integer a = [SELECT COUNT() FROM client_objective__c];
    Integer sd = [SELECT COUNT() FROM SD__c];
    Integer o = [SELECT COUNT() FROM Objective__c];
    Integer p = [SELECT COUNT() FROM program__c];
    Integer so = [SELECT COUNT() FROM session_obj__c];
    Integer s = [SELECT COUNT() FROM session__c];
    Integer t = [SELECT COUNT() FROM client_objective_timeseries__c];
    Integer l = [SELECT COUNT() FROM timeseries_log__c];

    System.assert(a > 0, 'Expected records were created.');
    System.assert(sd > 0, 'Expected records were created.');
    System.assert(o > 0, 'Expected records were created.');
    System.assert(p > 0, 'Expected records were created.');
    System.assert(so > 0, 'Expected records were created.');
    System.assert(s > 0, 'Expected records were created.');
    System.assert(t > 0, 'Expected records were created.');
    System.assert(l > 0, 'Expected records were created.');
  }
}
