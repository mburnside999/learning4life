/**************************************************************
 * @name LFLPopulateTestData
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	main class for populating test data
 *
 */

public with sharing class LFLPopulateTestData {
 
  public LFLPopulateTestData() {
  }

  /*******************************************************************************************************
   * @name load
   * @description loads test data
   *
   * @param void
   * @return 
   * @example
   * LFLPopulateTestData.load();
   */


  public static void load() {
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

    String x;

    //create a test client
    String RecTypeId = [
      SELECT Id
      FROM RecordType
      WHERE Name = 'LFL Client' AND SobjectType = 'Account'
    ]
    .Id;
    Account newAccount = new Account(
      RecordTypeID = RecTypeId,
      FirstName = 'Test FName',
      LastName = 'Peterson',
      PersonHomePhone = '1234567',
      PersonMobilePhone = '12345678'
    );
    insert newAccount;

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
      Objective__c = o1.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co1;

    Client_Objective__c co2 = new Client_Objective__c(
      Client__c = newAccount.Id,
      Status__c = 'OBJ',
      last_tested__c = Date.today(),
      Active__c = true,
      Objective__c = o2.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co2;

    Client_Objective__c co3 = new Client_Objective__c(
      Client__c = newAccount.Id,
      Status__c = 'ACQ',
      last_tested__c = Date.today(),
      Active__c = true,
      Objective__c = o3.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co3;

    Client_Objective__c co4 = new Client_Objective__c(
      Client__c = newAccount.Id,
      Status__c = 'CIP',
      last_tested__c = Date.today(),
      Active__c = true,
      Objective__c = o4.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co4;

    //create a session for our client
    Session__c session = new Session__c();
    session.Client__c = newAccount.Id;
    Date d = Date.today();

    session.date__c = d.addDays(-3);
    session.session_length__c = 1;
    session.session_location__c = 'Other';
    insert session;

    //create session objectives with C,I,P and N scores

    Session_Obj__c so1 = new Session_Obj__c();
    so1.Session__c = session.Id;
    so1.Objective__c = o1.Id;
    so1.correct__c = true;
    insert so1;

    Session_Obj__c so2 = new Session_Obj__c();
    so2.Session__c = session.Id;
    so2.Objective__c = o2.Id;
    so2.incorrect__c = true;
    insert so2;

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
