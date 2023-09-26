@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestL4LTimeSeries
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for L4LTimeSeries
 *
 */
private class TestL4LTimeSeries {
  /*******************************************************************************************************
   * @description Test loadCOTimeSeries method
   * @param void
   *
   *
   * @example
   * TestL4LTimeSeries.testLoadCOTimeSeries();
   */

  @isTest
  static void testLoadCOTimeSeries() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    Integer i = ts.loadCOTimeSeries();

    System.assert(i > 0, 'Expected at least one TS records loaded.');
  }
  /*******************************************************************************************************
   * @description Test tesGenerateD3COTimeSeriesJson method
   * @param void
   *
   *
   * @example
   * TestL4LTimeSeries.tesGenerateD3COTimeSeriesJson();
   */
  @isTest
  static void tesGenerateD3COTimeSeriesJson() {
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

  /*******************************************************************************************************
   * @description Test generateD3COTSJsonByProgramAndSD method
   * @param void
   *
   *
   * @example
   * TestL4LTimeSeries.testGenerateD3COTSJsonByProgramAndSD();
   */

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
      'All', //status
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

  /*******************************************************************************************************
   * @description Test generateD3CORetestTimeSeriesJson method
   * @param void
   *
   *
   * @example
   * TestL4LTimeSeries.TestGenerateD3CORetestTimeSeriesJson();
   */

  @isTest
  static void TestGenerateD3CORetestTimeSeriesJson() {
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

  /*******************************************************************************************************
   * @description Test generateD3COTimeSeriesByStatusJson method
   * @param void
   *
   *
   * @example
   * TestL4LTimeSeries.TestGenerateD3COTimeSeriesByStatusJson();
   */

  @isTest
  static void TestGenerateD3COTimeSeriesByStatusJson() {
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

  /*******************************************************************************************************
   * @description Test generateD3COTSThresholdJson method
   * @param void
   *
   *
   * @example
   * TestL4LTimeSeries.testGenerateD3COTSThresholdJson();
   */

  @isTest
  static void testGenerateD3COTSThresholdJson() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    L4LTimeSeries tstest = new L4LTimeSeries();
    Integer i = tstest.loadCOTimeSeries();

    Test.stopTest();

    L4LTimeSeries ts = new L4LTimeSeries();
    String str = L4LTimeSeries.generateD3COTSThresholdJson(clientId, 100, 200);
    System.assert(str.length() > 0, 'Expected a return string');
  }
}
