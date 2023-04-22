@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLInvocableReportWizard
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLInvocableReportWizard
 *
 */

private class TestLFLInvocableReportWizard {
  /*******************************************************************************************************
   * @description Test getStatusCountsBetweenDates method
   * @param void
   *
   *
   * @example
   * TestLFLInvocableReportWizard.testGetStatusCountsBetweenDates();
   */

  @isTest
  static void testGetStatusCountsBetweenDates() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    DateTime endtime = DateTime.now();
    DateTime starttime = endtime.addDays(-100);

    List<L4LInvocableReportWizard.Requests> reqlist = new List<L4LInvocableReportWizard.Requests>();

    L4LInvocableReportWizard.Requests req = new L4LInvocableReportWizard.Requests();
    req.clientId = clientId;
    req.starttime = starttime;
    req.endtime = endtime;
    reqlist.add(req);

    List<string> result = L4LInvocableReportWizard.getStatusCountsBetweenDates(
      reqlist
    );
  }
}
