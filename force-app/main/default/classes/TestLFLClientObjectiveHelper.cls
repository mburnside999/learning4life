@isTest
private class TestLFLClientObjectiveHelper {
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
