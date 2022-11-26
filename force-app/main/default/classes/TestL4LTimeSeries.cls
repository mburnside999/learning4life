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
}
