@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLClientObjectiveHelper
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLClientObjectiveHelper
 *
 */

private class TestLFLClientObjectiveHelper {
  /*******************************************************************************************************
   * @description Test getStatusCountsBetweenDates method
   * @param void
   *
   *
   * @example
   * TestLFLClientObjectiveHelper.testGetStatusCountsBetweenDates();
   */

  @isTest
  static void testGetStatusCountsBetweenDates() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    DateTime enddatetime = DateTime.now();
    DateTime startdatetime = enddatetime.addDays(-100);
    String result = LFLClientObjectiveHelper.getStatusCountsBetweenDates(
      startdatetime,
      enddatetime,
      clientId
    );
  }
}
