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

    String s = LFLDTDRateMaster.getDTDRateArray(clientId, 12);
    System.assert(s != null);
  }

  @isTest
  static void testInternalClass() {
    LFLDTDRateMaster.RateStats r = new LFLDTDRateMaster.RateStats();
    r.rate = 2.0;
    r.startd = Date.Today();
    r.elapsed = 3.0;
    r.startAcquiredCount = 1;
    r.numberAcquiredInPeriod = 2;
    r.sessionCount = 2;
    r.weeks = 2.0;
    r.acquiredPerSession = 1.0;
    r.totalSessionDurationHrs = 12.0;
    System.assert(r != null);
  }
}
