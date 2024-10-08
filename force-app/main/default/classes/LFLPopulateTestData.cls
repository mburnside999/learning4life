/**************************************************************
 * @name LFLPopulateTestData
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	Main class for populating test data, used in almost all tests
 *
 */

public with sharing class LFLPopulateTestData {
  /*******************************************************************************************************
   * @name load
   * @description Loads representative test data
   *
   * @example
   * LFLPopulateTestData.load();
   */

  public static void load() {
    delete [SELECT id FROM Session_BOC__c];
    delete [SELECT id FROM Client_BOC__c];
    delete [SELECT id FROM Account WHERE FirstName = 'Test FName'];
    delete [SELECT id FROM Account WHERE FirstName = 'TestFN'];
    delete [SELECT id FROM client_objective__c];
    delete [SELECT id FROM SD__c];
    delete [SELECT id FROM Objective__c];
    delete [SELECT id FROM program__c];
    delete [SELECT id FROM session_obj__c];
    delete [SELECT id FROM session__c];
    delete [SELECT id FROM NDIS_Report__c];
    delete [SELECT id FROM Session_Statistics__c];
    delete [SELECT id FROM Timeseries_log__c];
    delete [SELECT id FROM client_objective_timeseries__c];

    //create a test client
    String recTypeId = [
      SELECT Id
      FROM RecordType
      WHERE Name = 'LFL Client' AND SobjectType = 'Account'
    ]
    .Id;
    Account newAccount = new Account(
      RecordTypeID = recTypeId,
      FirstName = 'Test FName',
      LastName = 'Peterson',
      PersonHomePhone = '1234567',
      PersonMobilePhone = '12345678',
      Current__c = true
    );

    insert newAccount;

    // behaviour of concern
    Behaviour_of_concern__c boc1 = new Behaviour_of_concern__c(
      name = 'Behaviour1'
    );
    insert boc1;
    Behaviour_of_concern__c boc2 = new Behaviour_of_concern__c(
      name = 'Behaviour2'
    );
    insert boc2;
    Behaviour_of_concern__c boc3 = new Behaviour_of_concern__c(
      name = 'Unused Behaviour'
    );
    insert boc3;

    // client behaviour of concern
    Client_BOC__c cboc1 = new Client_BOC__c(
      client__c = newAccount.Id,
      behaviour_of_concern__c = boc1.Id,
      clinical_notes__c = 'clinical notes',
      start_date__c = Date.Today(),
      status__c = 'Active'
    );
    insert cboc1;
    Client_BOC__c cboc2 = new Client_BOC__c(
      client__c = newAccount.Id,
      behaviour_of_concern__c = boc2.Id,
      start_date__c = Date.Today(),
      status__c = 'Inactive'
    );
    insert cboc2;

    //create a Program
    Program__c p = new Program__c(
      Name = '2D Matching',
      Status__c = 'Active',
      Stage__c = 'Stage One'
    );
    insert p;

    //create an SD to associate with the Program
    SD__c sd1 = new SD__c(
      name = 'Identical',
      Stage__c = 'Stage One',
      Area__c = 'Communication',
      Status__c = 'Active'
    );
    sd1.Program__c = p.id;
    insert sd1;

    //create Objectives
    Objective__c o1 = new Objective__c(Name = 'Obj-1', Status__c = 'Active');
    o1.SD__c = sd1.id;
    insert o1;
    Objective__c o2 = new Objective__c(Name = 'Obj-2', Status__c = 'Active');
    o2.SD__c = sd1.id;
    insert o2;
    Objective__c o3 = new Objective__c(Name = 'Obj-3', Status__c = 'Active');
    o3.SD__c = sd1.id;
    insert o3;
    Objective__c o4 = new Objective__c(Name = 'Obj-4', Status__c = 'Active');
    o4.SD__c = sd1.id;
    insert o4;
    // an active, unassigned objective
    Objective__c o5 = new Objective__c(
      Name = 'Unassigned-Obj-5',
      Status__c = 'Active'
    );
    o5.SD__c = sd1.id;
    insert o5;

    //create Client objectives with a variety of Statuses
    Client_Objective__c co1 = new Client_Objective__c(
      Client__c = newAccount.Id,
      Status__c = 'HLD',
      Active__c = true,
      last_tested__c = Date.today(),
      last_tested_correct__c = Date.today(),
      last_tested_correct_session_name__c = 'AAA',
      last_tested_session_name__c = 'AAAA',
      last_tested_session__c = null,
      last_tested_correct_session__c = null,
      Objective__c = o1.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co1;

    Client_Objective__c co2 = new Client_Objective__c(
      Client__c = newAccount.Id,
      Status__c = 'OBJ',
      last_tested__c = Date.today(),
      last_tested_correct__c = Date.today(),
      last_tested_correct_session_name__c = 'AAA',
      last_tested_session_name__c = 'AAAA',
      last_tested_session__c = null,
      last_tested_correct_session__c = null,
      Active__c = true,
      Objective__c = o2.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co2;

    Client_Objective__c co3 = new Client_Objective__c(
      Client__c = newAccount.Id,
      Status__c = 'ACQ',
      last_tested__c = Date.today(),
      last_tested_correct__c = Date.today(),
      last_tested_correct_session_name__c = 'AAA',
      last_tested_session_name__c = 'AAAA',
      last_tested_session__c = null,
      last_tested_correct_session__c = null,
      Active__c = true,
      Objective__c = o3.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co3;

    Client_Objective__c co4 = new Client_Objective__c(
      Client__c = newAccount.Id,
      Status__c = 'CIP',
      last_tested__c = Date.today(),
      last_tested_correct__c = Date.today(),
      last_tested_correct_session_name__c = 'AAA',
      last_tested_session_name__c = 'AAAA',
      last_tested_session__c = null,
      last_tested_correct_session__c = null,
      Active__c = true,
      Objective__c = o4.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co4;

    //TS

    TimeSeries_Log__c tsl1 = new TimeSeries_Log__c(
      Comments__c = 'xxx',
      TS_Log_DateTime__c = Date.today().addDays(-14)
    );
    insert tsl1;

    Id tsl1id = tsl1.Id;

    String tsl1name = [
      SELECT name
      FROM timeseries_log__c
      WHERE id = :tsl1id
      LIMIT 1
    ]
    .Name;

    Client_Objective_Timeseries__c cots1 = new Client_Objective_Timeseries__c(
      Client__c = newAccount.Id,
      client_objective__c = co3.id,
      RunID__c = tsl1name,
      Status__c = 'ACQ',
      last_tested__c = Date.today(),
      Active__c = true,
      Objective__c = o3.Id,
      Client_Objective_Notes__c = 'client objective notes',
      TS_Load_DateTime__c = Date.today().addDays(-14)
    );
    insert cots1;

    TimeSeries_Log__c tsl2 = new TimeSeries_Log__c(
      Comments__c = 'xxx',
      TS_Log_DateTime__c = Date.today().addDays(-7)
    );
    insert tsl2;

    Id tsl2id = tsl2.Id;

    String tsl2name = [
      SELECT name
      FROM timeseries_log__c
      WHERE id = :tsl2id
      LIMIT 1
    ]
    .Name;

    Client_Objective_Timeseries__c cots2 = new Client_Objective_Timeseries__c(
      Client__c = newAccount.Id,
      client_objective__c = co3.id,
      RunID__c = tsl2name,
      Status__c = 'ACQ',
      last_tested__c = Date.today(),
      Active__c = true,
      Objective__c = o3.Id,
      Client_Objective_Notes__c = 'client objective notes',
      TS_Load_DateTime__c = Date.today().addDays(-7)
    );
    insert cots2;

    Client_Objective_Timeseries__c cots3 = new Client_Objective_Timeseries__c(
      Client__c = newAccount.Id,
      client_objective__c = co4.id,
      RunID__c = tsl2name,
      Status__c = 'ACQ',
      last_tested__c = Date.today(),
      Active__c = true,
      Objective__c = o4.Id,
      Client_Objective_Notes__c = 'client objective notes',
      TS_Load_DateTime__c = Date.today().addDays(-7)
    );
    insert cots3;

    //

    //create a session for our client
    Session__c session = new Session__c();
    session.Client__c = newAccount.Id;
    Date d = Date.today();
    session.date__c = d.addDays(-3);
    session.session_length__c = 1;
    session.status__c = 'Closed';
    session.session_location__c = 'Other';
    insert session;

    //create a session for our client
    Session__c session2 = new Session__c();
    session2.Client__c = newAccount.Id;
    Date d2 = Date.today();
    session2.date__c = d2.addDays(-7);
    session2.session_length__c = 1;
    session2.status__c = 'Closed';
    session2.session_location__c = 'Other';
    insert session2;

    //create session objectives with C,I,P and N scores

    Session_Obj__c so1 = new Session_Obj__c();
    so1.Session__c = session.Id;
    so1.Objective__c = o1.Id;
    so1.correct__c = true;
    insert so1;
    // add a session boc
    Session_boc__c sboc1 = new Session_boc__c(
      client_boc__c = cboc1.Id,
      session__c = session.Id,
      intensity__c = '1',
      occurrences__c = 1,
      duration_mins__c = 10,
      time__c = '10:00',
      comments__c = 'Comments'
    );
    insert sboc1;

    Session_Obj__c so2 = new Session_Obj__c();
    so2.Session__c = session.Id;
    so2.Objective__c = o2.Id;
    so2.incorrect__c = true;
    insert so2;

    // add a session boc
    Session_boc__c sboc2 = new Session_boc__c(
      client_boc__c = cboc1.Id,
      session__c = session.Id,
      intensity__c = '1',
      occurrences__c = 1,
      duration_mins__c = 10,
      time__c = '10:00',
      comments__c = 'Comments'
    );
    insert sboc2;

    Session_Obj__c so3 = new Session_Obj__c();
    so3.Session__c = session.Id;
    so3.Objective__c = o3.Id;
    so3.prompted__c = true;
    insert so3;

    Session_Obj__c so4 = new Session_Obj__c();
    so4.Session__c = session.Id;
    so4.Objective__c = o4.Id;
    so4.nonresponsive__c = true;
    insert so4;

    Session_Obj__c so5 = new Session_Obj__c();
    so5.Session__c = session.Id;
    so5.Objective__c = o4.Id;
    so5.correct__c = true;
    insert so5;

    //fake up some session stats

    Session_Statistics__c sessStat1 = new Session_Statistics__c();
    sessStat1.objective__c = o1.Id;
    sessStat1.session__c = session.Id;
    sessStat1.previous_status__c = 'ACQ';
    sessStat1.TotalAcquiredCorrect__c = 1;
    sessStat1.TotalAcquiredIncorrect__c = 0;
    sessStat1.TotalAcquiredPrompted__c = 0;
    sessStat1.TotalAcquiredNonResponsive__c = 0;
    insert sessStat1;

    Session_Statistics__c sessStat2 = new Session_Statistics__c();
    sessStat2.objective__c = o2.Id;
    sessStat2.session__c = session.Id;
    sessStat2.previous_status__c = 'HLD';
    sessStat2.TotalAcquiredCorrect__c = 0;
    sessStat2.TotalAcquiredIncorrect__c = 1;
    sessStat2.TotalAcquiredPrompted__c = 0;
    sessStat2.TotalAcquiredNonResponsive__c = 0;
    insert sessStat2;

    Session_Statistics__c sessStat3 = new Session_Statistics__c();
    sessStat3.objective__c = o1.Id;
    sessStat3.session__c = session.Id;
    sessStat3.previous_status__c = 'CIP';
    sessStat3.TotalAcquiredCorrect__c = 0;
    sessStat3.TotalAcquiredIncorrect__c = 0;
    sessStat3.TotalAcquiredPrompted__c = 1;
    sessStat3.TotalAcquiredNonResponsive__c = 0;
    insert sessStat3;

    Session_Statistics__c sessStat4 = new Session_Statistics__c();
    sessStat4.objective__c = o1.Id;
    sessStat4.session__c = session.Id;
    sessStat4.previous_status__c = 'ACQ';
    sessStat4.TotalAcquiredCorrect__c = 0;
    sessStat4.TotalAcquiredIncorrect__c = 0;
    sessStat4.TotalAcquiredPrompted__c = 0;
    sessStat4.TotalAcquiredNonResponsive__c = 1;
    insert sessStat4;

    // this section sets up to test the last_correct_date trigger logic

    // a new active SD, associated with the program
    SD__c sd2 = new SD__c(
      name = 'Non-identical',
      stage__c = 'Stage One',
      status__c = 'Active',
      area__c = 'Communication'
    );
    sd2.Program__c = p.id;
    insert sd2;

    // a new objective for the SD
    Objective__c o = new Objective__c(Name = 'Chair');
    o.SD__c = sd2.id;
    insert o;

    // a client objective that is active
    Client_Objective__c co5 = new Client_Objective__c(
      Client__c = newAccount.Id,
      active__c = true,
      Objective__c = o.Id,
      Client_Objective_Notes__c = 'client objective notes',
      status__c = 'OBJ'
    );
    insert co5;

    // create a session objective with correct=false -- the test classs will update this as correct
    Session_Obj__c so = new Session_Obj__c();
    so.Session__c = session.Id;
    so.Objective__c = o.Id;
    so.correct__c = false;
    so.previous_status__c = 'ACQ';
    insert so;
  }
}
