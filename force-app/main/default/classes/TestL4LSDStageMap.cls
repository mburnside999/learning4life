@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestL4LSDStageMap
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for L4LSDStageMap
 *
 */

private class TestL4LSDStageMap {
  /*******************************************************************************************************
   * @description Test removeDuplicates method
   * @param void
   *
   *
   * @example
   * TestL4LSDStageMap.testRemoveDuplicates();
   */

  @isTest
  static void testRemoveDuplicates() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<SD__c> sdList = L4LSDStageMap.removeDuplicates(clientId);

    System.assert(sdList.size() > 0, 'Expected valid list of SDs');
  }
}
