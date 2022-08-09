@isTest
private class TestLFLInvocableMasteryStatistics {
  @isTest
  static void test1() {
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

    List<LFLInvocableMasteryStatistics.Response> result = LFLInvocableMasteryStatistics.computeMasteryStats(
      reqlist
    );
    System.assert(result[0].outputString.contains('Success'));
  }
}
