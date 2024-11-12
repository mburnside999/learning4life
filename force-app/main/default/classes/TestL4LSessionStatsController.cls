@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestL4LSessionStatsController
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for L4LSessionStatsController
 *
 */

private class TestL4LSessionStatsController {
  /*******************************************************************************************************
   * @description Test generateD3ProgramAreaSDJson method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgenerateD3ProgramAreaSDJson();
   */
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

  /*******************************************************************************************************
   * @description Test generateD3BOCJson method
   *
   * @example
   * TestL4LSessionStatsController.testgenerateD3BOCJson();
   */
  @isTest
  static void testgenerateD3BOCJson() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    String json = L4LSessionStatsController.generateD3BOCJson(clientId, '30');

    System.assert(json != null, 'Expected a string');
  }

  /*******************************************************************************************************
   * @description Test generateD3AreaSDJson method
   *
   *
   * @example
   * TestL4LSessionStatsController.testgenerateD3AreaSDJson();
   */

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

  /*******************************************************************************************************
   * @description Test generateD3ProgramAreaSDJson method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.test2generateD3ProgramAreaSDJson();
   */

  @isTest
  static void test2generateD3ProgramAreaSDJson() {
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

  /*******************************************************************************************************
   * @description Test getD3SessionStatsHistogramData method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetD3SessionStatsHistogramData();
   */

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

  /*******************************************************************************************************
   * @description Test getD3YAxisScale method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetD3YAxisScale();
   */

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

  /*******************************************************************************************************
   * @description Test getD3RetestYAxisScale method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetD3RetestYAxisScale();
   */

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

  /*******************************************************************************************************
   * @description Test getD3StatusYAxisScale method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetD3StatusYAxisScale();
   */

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

  /*******************************************************************************************************
   * @description Test getHighAndLowBoundaries method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetD3StatusYAxisScale();
   */

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

  /*******************************************************************************************************
   * @description Test getsessionObjectives method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testGetsessionObjectives();
   */

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

  /*******************************************************************************************************
   * @description Test getClientObjectivesByProgram method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testGetClientObjectivesByProgram();
   */

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

  /*******************************************************************************************************
   * @description Test getD3Stats method
   * @param void
   * @deprecated COMMENTED OUT 7/5/24
   *
   * @example
   * TestL4LSessionStatsController.testGetD3Stats();
   */

  // @isTest
  // static void testGetD3Stats() {
  //   Test.startTest();
  //   LFLPopulateTestData.load();
  //   Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
  //   Test.stopTest();

  //   List<session_statistics__c> so = L4LSessionStatsController.getD3Stats(
  //     clientId,
  //     true
  //   );
  //   System.assert(
  //     so.size() > 0,
  //     'Expected at least one session_statistics__c record retrieved.'
  //   );
  //   so = L4LSessionStatsController.getD3Stats(clientId, false);
  //   System.assert(
  //     so.size() > 0,
  //     'Expected at least one session_statistics__c record retrieved.'
  //   );
  // }

  /*******************************************************************************************************
   * @description Test getD3StatsByProgram method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testGetD3StatsByProgram();
   */

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

  /*******************************************************************************************************
   * @description Test getD3StatsByProgramAndSD method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testGetD3StatsByProgramAndSD();
   */

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
      'All',
      '500',
      'All',
      'All'
    );
    System.assert(
      so.size() == 0,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }

  /*******************************************************************************************************
   * @description Test getProgramsAndSds method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetProgramsAndSds();
   */

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

  /*******************************************************************************************************
   * @description Test getClientObjectivesSDCount method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetClientObjectivesSDCount();
   */

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
      agg != null,
      '??Expected at least one session_statistics__c record retrieved.'
    );
  }

  /*******************************************************************************************************
   * @description Test getSDSetFromCO method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetSDSetFromCO();
   */

  @isTest
  static void testgetSDSetFromCO() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<String> s = L4LSessionStatsController.getSDSetFromCO(clientId);
    System.assert(s.size() > 0, 'expected a set of SD names');
  }

  /*******************************************************************************************************
   * @description Test getProgramSetFromCO method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetProgramSetFromCO();
   */

  @isTest
  static void testgetProgramSetFromCO() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<String> s = L4LSessionStatsController.getProgramSetFromCO(clientId);
    System.assert(s.size() > 0, 'expected a set of Program names');
  }
}
