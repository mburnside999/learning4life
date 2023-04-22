@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLInvocableSessionStatistics
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLInvocableSessionStatistics
 *
 */

private class TestLFLInvocableSessionStatistics {
  /*******************************************************************************************************
   * @description Test computeSessionStats method
   * @param void
   *
   *
   * @example
   * TestLFLInvocableSessionStatistics.testComputeSessionStats();
   */

  @isTest
  static void testComputeSessionStats() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    Id req = [
      SELECT id
      FROM session__c
      WHERE session_location__c = 'Other'
      LIMIT 1
    ]
    .id;
    List<id> reqList = new List<Id>();
    reqList.add(req);

    List<LFLInvocableSessionStatistics.Response> result = LFLInvocableSessionStatistics.computeSessionStats(
      reqlist
    );
    System.assert(result[0].outputString.contains('Success'));
  }
}
