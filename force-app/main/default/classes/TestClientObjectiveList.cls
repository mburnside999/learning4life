@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestClientObjectiveList
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for clientObjectiveList
 *
 */

private class TestClientObjectiveList {
  /*******************************************************************************************************
   * @description Test getClientObjectives method
   * @param void
   *
   *
   * @example
   * TestClientObjectiveList.testGetClientObjectives();
   */

  @isTest
  static void testGetClientObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Client_Objective__c> colist = clientObjectiveList.getClientObjectives(
      clientId
    );

    System.debug('clientId=' + clientId + 'colist ===> ' + colist);

    System.assert(
      colist.size() > 0,
      'Expected at least one client objective record retrieved.'
    );
  }
}
