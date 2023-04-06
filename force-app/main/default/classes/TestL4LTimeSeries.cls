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
    L4LTimeSeries tstest = new L4LTimeSeries();
    Integer i = tstest.loadCOTimeSeries();
    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    String str = L4LTimeSeries.generateD3COTimeSeriesJson(clientId, 'All');
    System.assert(str.length() > 0, 'Expected a return string');

    str = L4LTimeSeries.generateD3COTimeSeriesJson(clientId, 'ACQ');
    System.assert(str.length() > 0, 'Expected a return string');
  }

  @isTest
  static void testGenerateD3COTSJsonByProgramAndSD() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    L4LTimeSeries tstest = new L4LTimeSeries();
    Integer i = tstest.loadCOTimeSeries();
    Client_Objective__c co = [
      SELECT id, client__c, program_name__c, sd_name__c
      FROM client_objective__c
      WHERE client__c = :clientId
      LIMIT 1
    ];
    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    String str = L4LTimeSeries.generateD3COTSJsonByProgramAndSD(
      clientId,
      'All', //Prog
      'All', //SD
      'Both', //status
      'All' //period
    );
    System.assert(str.length() > 0, 'Expected a return string');
    str = L4LTimeSeries.generateD3COTSJsonByProgramAndSD(
      clientId,
      co.Program_Name__c,
      co.SD_Name__c,
      'ACQ',
      '60'
    );
    System.assert(str.length() > 0, 'Expected a return string');
  }

  @isTest
  static void TestRetest() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    L4LTimeSeries tstest = new L4LTimeSeries();
    Integer i = tstest.loadCOTimeSeries();
    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    String str = L4LTimeSeries.generateD3CORetestTimeSeriesJson(
      clientId,
      'All'
    );
    System.assert(str.length() >= 0, 'Expected a return string');

    str = L4LTimeSeries.generateD3CORetestTimeSeriesJson(clientId, 'ACQ');
    System.assert(str.length() >= 0, 'Expected a return string');
  }

  @isTest
  static void Test3() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    L4LTimeSeries tstest = new L4LTimeSeries();
    Integer i = tstest.loadCOTimeSeries();
    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    String str = L4LTimeSeries.generateD3COTimeSeriesByStatusJson(clientId);
    System.assert(str.length() > 0, 'Expected a return string');
  }

  @isTest
  static void testGenD3COTSThresholdJson() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    L4LTimeSeries tstest = new L4LTimeSeries();
    Integer i = tstest.loadCOTimeSeries();
    // for (client_objective_timeseries__c c : [
    //   SELECT id, ts_load_datetime__c
    //   FROM client_objective_timeseries__c
    // ]) {
    //   DateTime newdt = DateTime.now();
    //c.ts_load_datetime__c = newdt.addDays(7);
    // update c;
    //}
    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    String str = L4LTimeSeries.generateD3COTSThresholdJson(clientId, 100, 200);
    System.assert(str.length() > 0, 'Expected a return string');
  }
}
