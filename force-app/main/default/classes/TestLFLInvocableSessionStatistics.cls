@isTest
private class TestLFLInvocableSessionStatistics {
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

    List<string> result = LFLInvocableSessionStatistics.computeSessionStats(
      reqlist
    );
    System.assertEquals('Completed', result[0]);
  }
}
