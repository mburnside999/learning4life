@isTest
class TestL4LTimeSeries {
  @isTest
  static void Test() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    Integer i = ts.loadCOTimeSeries();

    System.assert(i > 0, 'Expected at least one TS records loaded.');
  }

  @isTest
  static void Test2() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    String str = L4LTimeSeries.generateD3COTimeSeriesJson(clientId, 'All');
    System.assert(str.length() > 0, 'Expected a return string');

    str = L4LTimeSeries.generateD3COTimeSeriesJson(clientId, 'ACQ');
    System.assert(str.length() > 0, 'Expected a return string');
  }
}
