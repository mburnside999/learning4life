// the class that is being tested - LFLInvocableMasteryStatistics - was deprecated on 30/1/2023 - its  intention was to roll up stats to the Program level -- this is no longer needed

@isTest
private class TestLFLInvocableMasteryStatistics {
  @isTest
  static void testComputeMasteryStats() {
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
