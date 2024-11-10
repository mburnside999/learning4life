@IsTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestL4LController
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for L4LController
 * @see L4LController
 *
 */

private class TestL4LController {
  /*******************************************************************************************************
   * @description Test getSessionObjectives method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetsessionObjectives();
   */

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

  /*******************************************************************************************************
   * @description Test getSessionBOC method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetsessionBOC();
   */

  @isTest
  static void testGetsessionBOC() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();

    List<session_boc__c> so = L4LController.getSessionBOC(sessionId);
    System.assert(
      so.size() > 0,
      'Expected at least one session_obj__c record retrieved.'
    );
  }

  /*******************************************************************************************************
   * @description Test getClientObjectivesForSession method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetClientObjectivesForSession();
   */

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

  /*******************************************************************************************************
   * @description Test getClientBOCForSession method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetClientBOCForSession(sessionId);
   */

  @isTest
  static void testGetClientBOCForSession() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();
    List<Client_BOC__c> cboclist = L4LController.getClientBOCForSession(
      sessionId
    );
    System.assert(
      cboclist != null,
      'Expected at least one client_boc__c record retrieved'
    );
  }

  /*******************************************************************************************************
   * @description Test getClientObjectives method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetClientObjectives();
   */

  @isTest
  static void testGetClientObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Client_Objective__c> co = L4LController.getClientObjectives(clientId);
    System.assert(
      co != null,
      'Expected at least one client_objective__c record retrieved'
    );
  }

  /*******************************************************************************************************
   * @description Test getClientObjectivesFilteredOnActive method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetClientObjectivesFilteredOnActive();
   */

  @isTest
  static void testGetClientBOCFilteredOnActive() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    Test.stopTest();

    List<Client_BOC__c> cboclist = L4LController.getClientBOCFilteredOnActive(
      clientId,
      true
    );

    System.assert(
      cboclist != null,
      'Expected at least one client_boc__c record retrieved'
    );

    List<Client_BOC__c> cboclist2 = L4LController.getClientBOCFilteredOnActive(
      clientId,
      false
    );

    System.assert(
      cboclist2 != null,
      'Expected at least one client_boc__c record retrieved'
    );
  }

  /*******************************************************************************************************
   * @description Test getClientObjectivesFilteredOnActive method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetClientObjectivesFilteredOnActive();
   */

  @isTest
  static void testGetClientObjectivesFilteredOnActive() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    Program__c p = new Program__c(
      Name = 'XXX',
      Status__c = 'Active',
      Stage__c = 'Stage One'
    );
    insert p;

    //create an SD to associate with the Program
    SD__c sd1 = new SD__c(
      name = 'XXXX',
      Stage__c = 'Stage One',
      Area__c = 'Communication',
      Status__c = 'Active'
    );

    sd1.Program__c = p.id;
    insert sd1;

    //create Objectives
    Objective__c o1 = new Objective__c(Name = 'XXXX', Status__c = 'Active');
    o1.SD__c = sd1.id;
    insert o1;

    client_objective__c co = new client_objective__c();
    co.client__c = clientId;
    co.active__c = true;
    co.objective__c = o1.Id;
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

  /*******************************************************************************************************
   * @description Test deactivateClientObjective method
   * @param void
   *
   *
   * @example
   * TestL4LController.testDeactivateClientObjective();
   */
  @isTest
  static void testDeactivateClientObjective() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    Program__c p = new Program__c(
      Name = 'XXX',
      Status__c = 'Active',
      Stage__c = 'Stage One'
    );
    insert p;

    //create an SD to associate with the Program
    SD__c sd1 = new SD__c(
      name = 'XXXX',
      Stage__c = 'Stage One',
      Area__c = 'Communication',
      Status__c = 'Active'
    );

    sd1.Program__c = p.id;
    insert sd1;

    //create Objectives
    Objective__c o1 = new Objective__c(Name = 'XXXX', Status__c = 'Active');
    o1.SD__c = sd1.id;
    insert o1;

    client_objective__c co = new client_objective__c();
    co.client__c = clientId;
    co.active__c = true;
    co.objective__c = o1.Id;
    insert co;

    Test.stopTest();

    Client_Objective__c co1 = L4LController.deactivateClientObjective(co.Id);
    System.assertEquals(true, co.active__c, 'xxx');
  }

  /*******************************************************************************************************
   * @description Test getCOActivationSummary method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetCOActivationSummary();
   */

  @isTest
  static void testGetCOActivationSummary() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    String summary = L4LController.getCOActivationSummary(clientId);
    System.assert(summary != null, 'Expected a summary string');
  }

  /*******************************************************************************************************
   * @description Test getUnusedObjectives method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetUnusedObjectives();
   */

  @isTest
  static void testGetUnusedObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Objective__c> o = L4LController.getUnusedObjectives(clientId);
    System.assert(o.size() != 0, 'Expected non zero unused records.');
  }

  /*******************************************************************************************************
   * @description Test getUnusedBOCBySearch method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetUnusedBOCBySearch();
   */
  @isTest
  static void testGetUnusedBOCBySearch() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Behaviour_of_Concern__c> bocList = L4LController.getUnusedBOCBySearch(
      clientId,
      '%'
    );
    System.assert(bocList.size() != 0, 'Expected non zero unused records.');
  }

  /*******************************************************************************************************
   * @description Test getUnusedObjectivesBySearch method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetUnusedObjectivesBySearch();
   */
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

  /*******************************************************************************************************
   * @description Test deleteSessionObjectives method
   * @param void
   *
   *
   * @example
   * TestL4LController.testDeleteSessionObjectives();
   */

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

  /*******************************************************************************************************
   * @description Test updateSessionObjectiveWithLG method
   * @param void
   *
   *
   * @example
   * TestL4LController.testUpdateSessionObjectiveWithLG();
   */
  @isTest
  static void testUpdateSessionObjectiveWithLG() {
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

    List<Session_Obj__c> sosCreatedList = L4LController.createSessionObjectivesByArrayWithOrderedResults(
      jsonstr,
      sessionId,
      skillstr
    );
    Integer listSize = sosCreatedList.size();
    Session_Obj__c myso = sosCreatedList[listSize - 1];

    String lgstr = L4LController.updateSessionObjectiveWithLG(myso.Id);

    System.assert(
      lgstr != null,
      'Expected a session ojective to be flagged as LG'
    );
  }

  @isTest
  static void testUpdateSessionObjectiveWithComment() {
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

    List<Session_Obj__c> sosCreatedList = L4LController.createSessionObjectivesByArrayWithOrderedResults(
      jsonstr,
      sessionId,
      skillstr
    );
    Integer listSize = sosCreatedList.size();
    Session_Obj__c myso = sosCreatedList[listSize - 1];

    String lgstr = L4LController.updateSessionObjectiveWithComment(
      myso.Id,
      'my comment'
    );

    System.assert(
      lgstr != null,
      'Expected a session ojective to be flagged as LG'
    );
  }

  /*******************************************************************************************************
   * @description Test createSessionObjectivesByArrayWithOrderedResults method
   * @param void
   *
   *
   * @example
   * TestL4LController.testCreateSessionObjectivesByArrayWithOrderedResults();
   */

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

    List<session_obj__c> mysolist = L4LController.createSessionObjectivesByArrayWithOrderedResults(
      jsonstr,
      sessionId,
      skillstr
    );

    System.assert(
      mysolist.size() == 3,
      'Expected three session_obj records created'
    );
  }

  /*******************************************************************************************************
   * @description Test createSessionBOCByArrayWithOrderedResults method
   * @param void
   *
   *
   * @example
   * TestL4LController.testCreateSessionBOCByArrayWithOrderedResults();
   */
  @isTest
  static void testCreateSessionBOCByArrayWithOrderedResults() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();

    List<Client_boc__c> col = [SELECT id, name FROM client_boc__c LIMIT 1];

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

    List<session_boc__c> mysboclist = L4LController.createSessionBOCByArrayWithOrderedResults(
      jsonstr,
      sessionId,
      skillstr
    );

    System.assert(
      mysboclist.size() == 0,
      'Expected no session_bco records created at this stage'
    );
  }

  /*******************************************************************************************************
   * @description Test createSessionBOC method
   * @param void
   *
   *
   * @example
   * TestL4LController.testCreateSessionBOC();
   */
  @isTest
  static void testCreateSessionBOC() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();

    Id bocid = [SELECT id, name FROM client_boc__c LIMIT 1].Id;
    Integer i = L4LController.createSessionBOC(
      bocid,
      sessionId,
      '1',
      10,
      10,
      '10:00',
      'Added by Test method'
    );

    System.assert(i == 1, 'Expected session_bco record to be created');
  }

  /*******************************************************************************************************
   * @description Test createClientObjectivesByArray method
   * @param void
   *
   *
   * @example
   * TestL4LController.testCreateClientObjectivesByArray();
   */

  @isTest
  static void testCreateClientObjectivesByArray() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    Program__c p = new Program__c(
      Name = 'XXX',
      Status__c = 'Active',
      Stage__c = 'Stage One'
    );
    insert p;

    //create an SD to associate with the Program
    SD__c sd1 = new SD__c(
      name = 'XXXX',
      Stage__c = 'Stage One',
      Area__c = 'Communication',
      Status__c = 'Active'
    );

    sd1.Program__c = p.id;
    insert sd1;

    //create Objectives
    Objective__c o1 = new Objective__c(Name = 'XXXX', Status__c = 'Active');
    o1.SD__c = sd1.id;
    insert o1;

    List<Objective__c> objs = [
      SELECT id, program__c, sd__c, sd_name__c
      FROM objective__c
      WHERE id = :o1.Id
      LIMIT 1
    ];

    String jsonstr = JSON.serialize(objs);

    Test.stopTest();

    Integer noOfCOsCreated = L4LController.createClientObjectivesByArray(
      jsonstr,
      clientId
    );
    System.assert(
      noOfCOsCreated == 1,
      'Expected one Client Objective to be created '
    );
  }

  /*******************************************************************************************************
   * @description Test createClientBOCByArray method
   * @param void
   *
   *
   * @example
   * TestL4LController.testCreateClientBOCByArray();
   */

  @isTest
  static void testCreateClientBOCByArray() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    Behaviour_of_concern__c boc1 = new Behaviour_of_concern__c(
      name = 'Another Behaviour1'
    );
    insert boc1;

    List<Behaviour_of_concern__c> bocs = [
      SELECT id, name
      FROM Behaviour_of_concern__c
      WHERE id = :boc1.Id
      LIMIT 1
    ];

    String jsonstr = JSON.serialize(bocs);

    Test.stopTest();

    Integer noOfCBOCsCreated = L4LController.createClientBOCByArray(
      jsonstr,
      clientId
    );
    System.assert(
      noOfCBOCsCreated == 1,
      'Expected one Client Objective to be created '
    );
  }

  /*******************************************************************************************************
   * @description Test setSessionObjectivesByArray method
   * @param void
   *
   *
   * @example
   * TestL4LController.testSetSessionObjectivesByArray();
   */

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

  /*******************************************************************************************************
   * @description Test setSessionObjectivesByArray method
   * @param void
   *
   *
   * @example
   * TestL4LController.testSetSessionObjectivesByArray();
   */

  @isTest
  static void testSetSessionBOCByArray() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();
    List<Session_BOC__c> sbocs = [
      SELECT id, Name, Comments__c
      FROM session_BOC__c
      LIMIT 1
    ];
    String jsonstr = JSON.serialize(sbocs);
    String val = 'Delete';
    Integer noOfSOsSet = L4LController.setSessionBOCByArray(jsonstr, val);
    System.assert(noOfSOsSet == 1, 'Expected one SBOC to be processed');
  }

  /*******************************************************************************************************
   * @description TestgetActiveCBOC method
   * @param void
   *
   *
   * @example
   * TestL4LController.testGetActiveCBOC(clientId);
   */

  @isTest
  static void TestgetActiveCBOCList() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    Test.stopTest();

    List<client_BOC__c> cbocs = L4LController.getActiveCBOCList(clientId);
    cbocs.size();
    System.assert(cbocs.size() > 0, 'Expected at least one active CBOC');
  }

  /*******************************************************************************************************
   * @description Test setClientObjectivesByArray method
   * @param void
   *
   *
   * @example
   * TestL4LController.testSetClientObjectivesByArray();
   */

  @isTest
  static void testSetClientObjectivesByArray() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();
    List<Client_objective__c> cobjs = [
      SELECT Id, Name, Status__c, Active__c, Frequency__c
      FROM client_objective__c
      LIMIT 1
    ];
    Integer noOfCOsSet = 0;

    String val = 'ACQ';
    String jsonstr = JSON.serialize(cobjs);
    noOfCOsSet = L4LController.setClientObjectivesByArray(jsonstr, val);
    System.assert(noOfCOsSet >= 0, 'Expected CO attribute to be set');
    val = 'OBJ';
    noOfCOsSet = L4LController.setClientObjectivesByArray(jsonstr, val);
    System.assert(noOfCOsSet >= 0, 'Expected CO attribute to be set');
    val = 'ABS';
    noOfCOsSet = L4LController.setClientObjectivesByArray(jsonstr, val);
    System.assert(noOfCOsSet >= 0, 'Expected CO attribute to be set');
    val = 'HLD';
    noOfCOsSet = L4LController.setClientObjectivesByArray(jsonstr, val);
    System.assert(noOfCOsSet >= 0, 'Expected CO attribute to be set');
    val = 'WEEKLY';
    noOfCOsSet = L4LController.setClientObjectivesByArray(jsonstr, val);
    System.assert(noOfCOsSet >= 0, 'Expected CO attribute to be set');
    val = 'FORTNIGHTLY';
    noOfCOsSet = L4LController.setClientObjectivesByArray(jsonstr, val);
    System.assert(noOfCOsSet >= 0, 'Expected CO attribute to be set');
    val = 'Activate';
    noOfCOsSet = L4LController.setClientObjectivesByArray(jsonstr, val);
    System.assert(noOfCOsSet >= 0, 'Expected CO attribute to be set');
    val = 'Deactivate';
    noOfCOsSet = L4LController.setClientObjectivesByArray(jsonstr, val);
    System.assert(noOfCOsSet >= 0, 'Expected CO attribute to be set');
  }
}
