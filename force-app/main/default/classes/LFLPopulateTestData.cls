public with sharing class LFLPopulateTestData {
  public LFLPopulateTestData() {
  }
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

    Session__c session = new Session__c();
    session.Client__c = newAccount.Id;
    session.date__c = Date.today();
    session.session_length__c = 1;
    session.session_location__c = 'Other';
    insert session;

    Program__c p = new Program__c(Name = '2D Matching');
    insert p;

    SD__c sd1 = new SD__c(name = 'Identical');
    sd1.Program__c = p.id;
    insert sd1;
    Objective__c o = new Objective__c(Name = 'Car');
    o.SD__c = sd1.id;
    insert o;

    Client_Objective__c co = new Client_Objective__c(
      Client__c = newAccount.Id,
      Objective__c = o.Id,
      Client_Objective_Notes__c = 'client objective notes'
    );
    insert co;

    Session_Obj__c so = new Session_Obj__c();
    so.Session__c = session.Id;
    so.Objective__c = o.Id;
    so.correct__c = true;
    insert so;

    Session_Statistics__c sessStat = new Session_Statistics__c();
    sessStat.objective__c = o.Id;
    sessStat.session__c = session.Id;
    sessStat.previous_status__c = 'ACQ';
    sessStat.TotalAcquiredCorrect__c = 1;
    sessStat.TotalAcquiredIncorrect__c = 1;
    sessStat.TotalAcquiredPrompted__c = 1;
    sessStat.Program_Name__c = 'Color';

    insert sessStat;

    o = new Objective__c(Name = 'Dog');
    o.SD__c = sd1.id;
    insert o;

    co = new Client_Objective__c(
      Client__c = newAccount.Id,
      Objective__c = o.Id,
      Client_Objective_Notes__c = 'client objective notes',
      status__c = 'ACQ'
    );
    insert co;
    so = new Session_Obj__c();
    so.Session__c = session.Id;
    so.Objective__c = o.Id;
    so.correct__c = true;
    so.previous_status__c = 'ACQ';

    insert so;

    so = new Session_Obj__c();
    so.Session__c = session.Id;
    so.Objective__c = o.Id;
    so.incorrect__c = true;
    so.previous_status__c = 'OBJ';

    insert so;

    so = new Session_Obj__c();
    so.Session__c = session.Id;
    so.Objective__c = o.Id;
    so.prompted__c = true;
    so.previous_status__c = 'ACQ';

    insert so;

    SD__c sd2 = new SD__c(name = 'Non-identical');
    sd2.Program__c = p.id;
    insert sd2;
    o = new Objective__c(Name = 'Chair');
    o.SD__c = sd2.id;
    insert o;
    co = new Client_Objective__c(
      Client__c = newAccount.Id,
      Objective__c = o.Id,
      Client_Objective_Notes__c = 'client objective notes',
      status__c = 'OBJ'
    );
    insert co;
    so = new Session_Obj__c();
    so.Session__c = session.Id;
    so.Objective__c = o.Id;
    so.correct__c = false;
    so.previous_status__c = 'ACQ';
    insert so;

    o = new Objective__c(Name = 'Banana');
    o.SD__c = sd2.id;
    insert o;
    co = new Client_Objective__c(
      Client__c = newAccount.Id,
      Objective__c = o.Id,
      Client_Objective_Notes__c = 'client objective notes',
      status__c = 'ACQ'
    );
    insert co;
    so = new Session_Obj__c();
    so.Session__c = session.Id;
    so.Objective__c = o.Id;
    so.correct__c = true;
    so.previous_status__c = 'OBJ';
    insert so;

    //unassigned
    SD__c sd = new SD__c(name = 'Test');
    sd.Program__c = p.id;
    insert sd;
    Objective__c ob = new Objective__c(Name = 'Test');
    ob.SD__c = sd.id;
    insert ob;
  }
}
