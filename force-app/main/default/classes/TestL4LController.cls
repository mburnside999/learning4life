@isTest
private class TestL4LController {
  @isTest
  static void testGetsessionObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();

    List<session_obj__c> so = L4LController.getSessionObjectives(sessionId);
    System.assert(
      so.size() > 0,
      'Expected at least one session_obj__c record retrieved.'
    );
  }

  @isTest
  static void testGetClientObjectivesForSession() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();
    List<Client_Objective__c> co = L4LController.getClientObjectivesForSession(
      sessionId
    );
    System.assert(
      co != null,
      'Expected at least one client_objective__c record retrieved'
    );
  }

  @isTest
  static void testGetClientObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Client_Objective__c> co = L4LController.getClientObjectives(clientId);
    System.assert(
      co.size() > 0,
      'Expected at least one client_objective__c record retrieved'
    );
  }

  @isTest
  static void testClientObjectivesFilteredOnActive() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Id objId = [SELECT id FROM objective__c LIMIT 1].id;
    client_objective__c co = new client_objective__c();
    co.client__c = clientId;
    co.active__c = true;
    co.objective__c = objId;
    insert co;

    Test.stopTest();

    List<Client_Objective__c> colist = L4LController.getClientObjectivesFilteredOnActive(
      clientId,
      true
    );

    System.assert(
      colist != null,
      'Expected at least one client_objective__c record retrieved'
    );
  }

  @isTest
  static void testDeactivateCO() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Id objId = [SELECT id FROM objective__c LIMIT 1].id;
    client_objective__c co = new client_objective__c();
    co.client__c = clientId;
    co.active__c = true;
    co.objective__c = objId;
    insert co;

    Test.stopTest();

    Client_Objective__c co1 = L4LController.deactivateClientObjective(co.Id);
    System.assertEquals(true, co.active__c, 'xxx');
  }

  @isTest
  static void testGetCOActivationSummary() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    String summary = L4LController.getCOActivationSummary(clientId);
    System.assert(summary != null, 'Expected a summary string');
  }

  @isTest
  static void testGetUnusedObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Objective__c> o = L4LController.getUnusedObjectives(clientId);
    System.assert(o.size() != 0, 'Expected non zero unused records.');
  }
  @isTest
  static void testGetUnusedObjectivesBySearch() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Objective__c> o = L4LController.getUnusedObjectivesBySearch(
      clientId,
      '%'
    );
    System.assert(o.size() != 0, 'Expected non zero unused records.');
  }
  @isTest
  static void testDeleteSessionObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();
    L4LController.deleteSessionObjectives(sessionId);
    Integer socount = [
      SELECT COUNT()
      FROM session_obj__c
      WHERE session__c = :sessionId
    ];
    System.assert(
      socount == 0,
      'Expected no session objectives for this session'
    );
  }

  @isTest
  static void testCreateSessionObjectivesByArrayWithOrderedResults() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();

    List<Client_Objective__c> col = [
      SELECT
        id,
        name,
        objective__c,
        objective_name__c,
        client__c,
        program_name__c,
        sd_name__c,
        re_test_Recommended__c,
        client_objective_notes__c
      FROM client_objective__c
      LIMIT 1
    ];
    String jsonstr = JSON.serialize(col);

    List<L4LController.SessionResult> lsr = new List<L4LController.SessionResult>();
    L4LController.SessionResult sr = new L4LController.SessionResult();
    sr.skill = 'C';
    lsr.add(sr);
    sr = new L4LController.SessionResult();
    sr.skill = 'I';
    lsr.add(sr);
    sr = new L4LController.SessionResult();
    sr.skill = 'P';
    lsr.add(sr);

    String skillstr = JSON.serialize(lsr);

    Integer noOfSOsCreated = L4LController.createSessionObjectivesByArrayWithOrderedResults(
      jsonstr,
      sessionId,
      skillstr
    );

    System.assert(
      noOfSOsCreated == 3,
      'Expected three session_obj records created'
    );
  }

  @isTest
  static void testCreateClientObjectivesByArray() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Objective__c> objs = [
      SELECT id, program__c, sd__c, sd_name__c
      FROM objective__c
      LIMIT 1
    ];

    String jsonstr = JSON.serialize(objs);
    Integer noOfCOsCreated = L4LController.createClientObjectivesByArray(
      jsonstr,
      clientId
    );
    System.assert(
      noOfCOsCreated == 1,
      'Expected one Client Objective to be created '
    );
  }

  @isTest
  static void testSetSessionObjectivesByArray() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();
    List<Session_Obj__c> sobjs = [
      SELECT
        id,
        SD__c,
        Session__c,
        program__c,
        objective__c,
        correct__c,
        incorrect__c,
        prompted__c,
        nonresponsive__c
      FROM session_obj__c
      LIMIT 1
    ];
    String jsonstr = JSON.serialize(sobjs);
    String val = 'C';
    Integer noOfSOsSet = L4LController.setSessionObjectivesByArray(
      jsonstr,
      val
    );
    System.assert(noOfSOsSet == 1, 'Expected one SO to be set');
  }
}
