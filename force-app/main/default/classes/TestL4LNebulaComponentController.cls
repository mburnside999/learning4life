@isTest
private class TestL4LNebulaComponentController {
  @isTest
  static void testnebula() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logWarning(
      sessionId,
      'message',
      'scenario',
      'tag'
    );
    L4LNebulaComponentController.logFine(
      sessionId,
      'message',
      'scenario',
      'tag'
    );
    L4LNebulaComponentController.logInfo(
      sessionId,
      'message',
      'scenario',
      'tag'
    );
    L4LNebulaComponentController.logDebug(
      sessionId,
      'message',
      'context',
      'tag'
    );
    L4LNebulaComponentController.logError(
      sessionId,
      'message',
      'context',
      'tag'
    );
  }
}
