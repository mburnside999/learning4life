@isTest
private class TestL4LSessionStatsController {
  @isTest
  static void testgenerateD3ProgramAreaSDJson() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    String json = L4LSessionStatsController.generateD3ProgramAreaSDJson(
      clientId,
      'All'
    );

    Boolean isValidJSON = LFLUtil.isValidJSON(json);

    System.assert(isValidJSON, 'Expected valid json');
  }

  @isTest
  static void testgenerateD3AreaSDJson() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    Test.stopTest();

    String json = L4LSessionStatsController.generateD3AreaSDJson(
      clientId,
      'All'
    );

    Boolean isValidJSON = LFLUtil.isValidJSON(json);

    System.assert(isValidJSON, 'Expected valid json');
  }

  @isTest
  static void testgenerateD3ProgramAreaSDJson2() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    String json = L4LSessionStatsController.generateD3ProgramAreaSDJson(
      clientId,
      'Stage One'
    );

    Boolean isValidJSON = LFLUtil.isValidJSON(json);

    System.assert(isValidJSON, 'Expected valid json');
  }

  @isTest
  static void testgetD3SessionStatsHistogramData() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();
    List<Session_Statistics__c> ss = new List<Session_Statistics__c>();
    ss = L4LSessionStatsController.getD3SessionStatsHistogramData(clientId);

    System.assert(ss.size() > 0, 'Expected stats histogram data to return');
  }

  @isTest
  static void testgetD3YAxisScale() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();
    Integer c = 0;
    c = L4LSessionStatsController.getD3YAxisScale(clientId);

    System.assert(c >= 0, 'Expected a valid count');
  }

  @isTest
  static void testgetD3RetestYAxisScale() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();
    Integer c = 0;
    c = L4LSessionStatsController.getD3RetestYAxisScale(clientId);

    System.assert(c >= 0, 'Expected a valid count');
  }

  @isTest
  static void testgetD3StatusYAxisScale() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();
    Integer c = 0;
    c = L4LSessionStatsController.getD3StatusYAxisScale(clientId);

    System.assert(c >= 0, 'Expected a valid count');
  }

  @isTest
  static void testGetHighAndLowBoundaries() {
    Test.startTest();
    // LFLPopulateTestData.load();
    // Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    // Test.stopTest();

    L4LSessionStatsController.getHighAndLowBoundaries();

    LFL_Stats_Boundary__mdt lflStatsBoundaries = LFL_Stats_Boundary__mdt.getInstance(
      'lfl_stats_boundary'
    );

    System.assert(
      lflStatsBoundaries != null,
      'Must have a LFL_Stats_Boundary__mdt'
    );
  }

  @isTest
  static void testGetsessionObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id sessionId = [SELECT id FROM session__c LIMIT 1].Id;
    Test.stopTest();

    List<session_statistics__c> so = L4LSessionStatsController.getSessionStats(
      sessionId
    );
    System.assert(
      so.size() > 0,
      'Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testGetClientObjectivesByProgram() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<AggregateResult> ar = L4LSessionStatsController.GetClientObjectivesByProgram(
      clientId
    );
    System.assert(ar.size() > 0, 'Expected at least one ag result.');
  }

  @isTest
  static void testGetD3Stats() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<session_statistics__c> so = L4LSessionStatsController.getD3Stats(
      clientId,
      true
    );
    System.assert(
      so.size() > 0,
      'Expected at least one session_statistics__c record retrieved.'
    );
    so = L4LSessionStatsController.getD3Stats(clientId, false);
    System.assert(
      so.size() > 0,
      'Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testGetD3StatsByProgram() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<session_statistics__c> so = L4LSessionStatsController.getD3StatsByProgram(
      clientId,
      'Color',
      true
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
    so = L4LSessionStatsController.getD3StatsByProgram(
      clientId,
      'Color',
      false
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testGetD3StatsByProgramAndSD() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<session_statistics__c> so = L4LSessionStatsController.getD3StatsByProgram(
      clientId,
      'Color',
      true
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
    so = L4LSessionStatsController.getD3StatsByProgramAndSD(
      clientId,
      'Color',
      'Identical',
      false,
      '180',
      'All'
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testgetProgramsAndSds() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Program__c> p = L4LSessionStatsController.getProgramsAndSds('All');
    System.assert(
      p.size() != 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }

  @isTest
  static void testgetClientObjectivesSDCount() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<AggregateResult> agg = L4LSessionStatsController.getClientObjectivesSDCount(
      clientId
    );
    System.assert(
      agg.size() > 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }
}
