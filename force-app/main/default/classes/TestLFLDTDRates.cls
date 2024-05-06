@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLDTDRates
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLDTDRates
 *
 */

private class TestLFLDTDRates {
  /*******************************************************************************************************
   * @description Test getAcquisitionRate method
   * @param void
   *
   *
   * @example
   * TestLFLDTDRates.testGetAcquisitionRate();
   */

  @isTest
  static void testGetAcquisitionRate() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    List<Client_Objective_TimeSeries__c> tslist = new List<Client_Objective_TimeSeries__c>();
    Client_Objective_Timeseries__c tsrecord1 = new Client_Objective_Timeseries__c();
    tsrecord1.runId__c = 'AAAAA';
    //tsrecord.client_objective__c = co.Id;
    tsrecord1.client__c = clientId;
    tsrecord1.status__c = 'ACQ';
    tsrecord1.active__c = true;
    tslist.add(tsrecord1);

    Client_Objective_Timeseries__c tsrecord2 = new Client_Objective_Timeseries__c();
    tsrecord2.runId__c = 'BBB';
    //tsrecord.client_objective__c = co.Id;
    tsrecord2.client__c = clientId;
    tsrecord2.status__c = 'ACQ';
    tsrecord2.active__c = true;
    tslist.add(tsrecord2);

    Client_Objective_Timeseries__c tsrecord3 = new Client_Objective_Timeseries__c();
    tsrecord3.runId__c = 'BBB';
    //tsrecord.client_objective__c = co.Id;
    tsrecord3.client__c = clientId;
    tsrecord3.status__c = 'ACQ';
    tsrecord3.active__c = true;
    tslist.add(tsrecord3);

    insert tslist;
    String RecTypeId = [
      SELECT Id
      FROM RecordType
      WHERE Name = 'LFL Client' AND SobjectType = 'Account'
    ]
    .Id;

    Account newAccount1 = new Account(
      RecordTypeID = RecTypeId,
      FirstName = 'XX',
      LastName = 'YY',
      PersonHomePhone = '1234567',
      PersonMobilePhone = '12345678'
    );
    insert newAccount1;

    Test.stopTest();

    String s = LFLDTDRates.getAcquisitionRate(clientId, 0);
    String t = LFLDTDRates.getAcquisitionRate(newAccount1.Id, 0);

    System.assert((s != null) && (t != null));
  }

  /*******************************************************************************************************
   * @description Test  getAcquisitionRateByDates method
   * @param void
   *
   *
   * @example
   * TestLFLDTDRates.testGetAcquisitionRateByDates();
   */

  @isTest
  static void testGetAcquisitionRateByDates() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    List<Client_Objective_TimeSeries__c> tslist = new List<Client_Objective_TimeSeries__c>();
    Client_Objective_Timeseries__c tsrecord1 = new Client_Objective_Timeseries__c();
    tsrecord1.runId__c = 'AAAAA';
    //tsrecord.client_objective__c = co.Id;
    tsrecord1.client__c = clientId;
    tsrecord1.status__c = 'ACQ';
    tsrecord1.active__c = true;
    tslist.add(tsrecord1);

    Client_Objective_Timeseries__c tsrecord2 = new Client_Objective_Timeseries__c();
    tsrecord2.runId__c = 'BBB';
    //tsrecord.client_objective__c = co.Id;
    tsrecord2.client__c = clientId;
    tsrecord2.status__c = 'ACQ';
    tsrecord2.active__c = true;
    tslist.add(tsrecord2);

    Client_Objective_Timeseries__c tsrecord3 = new Client_Objective_Timeseries__c();
    tsrecord3.runId__c = 'BBB';
    //tsrecord.client_objective__c = co.Id;
    tsrecord3.client__c = clientId;
    tsrecord3.status__c = 'ACQ';
    tsrecord3.active__c = true;
    tslist.add(tsrecord3);

    insert tslist;
    String RecTypeId = [
      SELECT Id
      FROM RecordType
      WHERE Name = 'LFL Client' AND SobjectType = 'Account'
    ]
    .Id;

    Account newAccount1 = new Account(
      RecordTypeID = RecTypeId,
      FirstName = 'XX',
      LastName = 'YY',
      PersonHomePhone = '1234567',
      PersonMobilePhone = '12345678'
    );
    insert newAccount1;

    Test.stopTest();

    DateTime ed = DateTime.now();
    DateTime sd = ed.addMonths(-12);

    String s = LFLDTDRates.getAcquisitionRateByDates(clientId, sd, ed);
    String t = LFLDTDRates.getAcquisitionRateByDates(newAccount1.Id, sd, ed);

    System.assert((s != null) && (t != null));

    Boolean caughtTheDateError = false;
    try {
      String result = LFLDTDRates.getAcquisitionRateByDates(clientId, ed, sd);
    } catch (L4LRateCalculationException e) {
      caughtTheDateError = true;
      System.assert(caughtTheDateError == true);
    }
  }

  /*******************************************************************************************************
   * @description Test  testGetAcquisitionRateForClientTurbo method
   * @param void
   *
   *
   * @example
   * TestLFLDTDRates.testGetAcquisitionRateForClientTurbo();
   */

  @isTest
  static void testGetAcquisitionRateForClientTurbo() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    List<Client_Objective_TimeSeries__c> tslist = new List<Client_Objective_TimeSeries__c>();
    Client_Objective_Timeseries__c tsrecord1 = new Client_Objective_Timeseries__c();
    tsrecord1.runId__c = 'BBB';
    //tsrecord.client_objective__c = co.Id;
    tsrecord1.client__c = clientId;
    tsrecord1.status__c = 'ACQ';
    tsrecord1.active__c = true;
    tsrecord1.TS_Load_DateTime__c = DateTime.now().addDays(-7);
    tslist.add(tsrecord1);

    Client_Objective_Timeseries__c tsrecord2 = new Client_Objective_Timeseries__c();
    tsrecord2.runId__c = 'CCC';
    //tsrecord.client_objective__c = co.Id;
    tsrecord2.client__c = clientId;
    tsrecord2.status__c = 'ACQ';
    tsrecord2.active__c = true;
    tsrecord2.TS_Load_DateTime__c = DateTime.now().addDays(-14);

    tslist.add(tsrecord2);

    Client_Objective_Timeseries__c tsrecord3 = new Client_Objective_Timeseries__c();
    tsrecord3.runId__c = 'DDD';
    //tsrecord.client_objective__c = co.Id;
    tsrecord3.client__c = clientId;
    tsrecord3.status__c = 'ACQ';
    tsrecord3.active__c = true;
    tsrecord3.TS_Load_DateTime__c = DateTime.now().addDays(-14);
    tslist.add(tsrecord3);

    String RecTypeId = [
      SELECT Id
      FROM RecordType
      WHERE Name = 'LFL Client' AND SobjectType = 'Account'
    ]
    .Id;

    Account newAccount1 = new Account(
      RecordTypeID = RecTypeId,
      FirstName = 'XX',
      LastName = 'YY',
      PersonHomePhone = '1234567',
      PersonMobilePhone = '12345678'
    );
    insert newAccount1;

    Client_Objective_Timeseries__c tsrecord4 = new Client_Objective_Timeseries__c();
    tsrecord4.runId__c = 'AAAAA';
    //tsrecord.client_objective__c = co.Id;
    tsrecord4.client__c = newAccount1.Id;
    tsrecord4.status__c = 'ACQ';
    tsrecord4.active__c = true;
    tsrecord4.TS_Load_DateTime__c = DateTime.now().addDays(-100);

    tslist.add(tsrecord4);

    insert tslist;

    Test.stopTest();
    String s = LFLDTDRates.getAcquisitionRateforClientTurbo(clientId);
    // String t = LFLDTDRates.getAcquisitionRateforClientTurbo(newAccount1.Id);

    System.assert(s != null, 'expected a result');
  }
}
