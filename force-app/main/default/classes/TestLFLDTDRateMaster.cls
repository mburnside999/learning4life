@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLDTDRateMaster
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLDTDRateMaster
 *
 */

private class TestLFLDTDRateMaster {
  /*******************************************************************************************************
   * @description Test getDTDRateArray method
   * @param void
   *
   *
   * @example
   * TestLFLDTDRateMaster.testGetDTDRateArray();
   */

  @isTest
  static void testGetDTDRateArray() {
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    String s = LFLDTDRateMaster.getDTDRateArray(clientId, 3);
    System.assert(s != null);
  }
}
