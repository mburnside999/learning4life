@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestL4LStagesByArea
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for L4LStagesByArea
 *
 */

private class TestL4LStagesByArea {
  /*******************************************************************************************************
   * @description Test getSDUsage method
   * @param void
   *
   *
   * @example
   * TestL4LStagesByArea.testGetSDUsage();
   */

  @isTest
  static void testGetSDUsage() {
    Test.startTest();
    //populate data
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    String sdJSONList = L4LStagesByArea.getSDUsage(clientId);

    System.assert(sdJSONList != null, 'Expected valid list of SDs');
  }
}
