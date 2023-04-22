@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestL4LNebulaComponentController
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for L4LNebulaComponentController
 *
 */
private class TestL4LNebulaComponentController {
  /*******************************************************************************************************
   * @description Test L4LNebulaComponentController
   * @param void
   *
   *
   * @example
   * TestL4LNebulaComponentController.testnebula();
   */

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
