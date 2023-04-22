@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLSessionStatsTrg
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLSessionStatsTrg
 *
 */

private class TestLFLSessionStatsTrg {
  /*******************************************************************************************************
   * @description Test trigger
   * @param void
   *
   *
   * @example
   * TestLFLSessionStatsTrg.testTrg();
   */

  @isTest
  static void testTrg() {
    Test.startTest();
    //the test load contains a single session_objective where correct__c=false and previous_status='ACQ'
    LFLPopulateTestData.load();
    Test.stopTest();

    Session_Statistics__c ss = [
      SELECT id, program_name__c
      FROM session_statistics__c
      LIMIT 1
    ];

    System.assert(
      ss.program_name__c != null,
      'expected program name to be present'
    );
  }
}
