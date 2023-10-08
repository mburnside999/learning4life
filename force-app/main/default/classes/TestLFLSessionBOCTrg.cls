@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLSessionBOCTrg
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLSessionStatsTrg
 *
 */
private class TestLFLSessionBOCTrg {
  /*******************************************************************************************************
   * @description Test trigger
   * @param void
   *
   *
   * @example
   * TestLFLSessionBOCTrg.testTrg();
   */
  @isTest
  static void testTrg() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();
    List<session_boc__c> sbocList = [SELECT id FROM session_boc__c];
    System.assert(sboclist.size() > 0, 'expected sboc to be created');
  }
}
