@isTest
private class TestLFLInvocableReportWizard {
  @isTest
  static void test1() {
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
