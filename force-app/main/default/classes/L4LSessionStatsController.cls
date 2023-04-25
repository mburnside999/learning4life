/**************************************************************
 * @author	Mike Burnside
 * @date	2022
 * @group Learning For Life
 *
 * @description	Main session stats generator.
 *
 */

public with sharing class L4LSessionStatsController {
  /*******************************************************************************************************
   * @name getHighAndLowBoundaries
   * @description Queries lfl_stats_boundary instance of LFL_Stats_Boundary__mdt metadata to obtain the High/Low parameters to 
   control Red/Yellow UI traffic light colours
   *
   * @param 
   * @return Custom metadata record, lfl_stats_boundary
   *
   * @example
   * LFL_Stats_Boundary__mdt highsandlows = L4LSessionStatsController.getHighAndLowBoundaries()
   */

  @AuraEnabled(cacheable=true)
  public static LFL_Stats_Boundary__mdt getHighAndLowBoundaries() {
    String SCENARIO = 'Session Statistics - get configured traffic light boundaries from mdt - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'L4LSessionStatsController.getHighAndLowBoundaries()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    LFL_Stats_Boundary__mdt lflStatsBoundaries = LFL_Stats_Boundary__mdt.getInstance(
      'lfl_stats_boundary'
    );

    L4LNebulaComponentController.logDebug(
      null,
      'L4LSessionStatsController.getHighAndLowBoundaries, returning lflStatsBoundaries=' +
      lflStatsBoundaries,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return lflStatsBoundaries;
  }

  /*******************************************************************************************************
   * @name getD3SessionStatsHistogramData
   * @description Returns the session statistics for a client
   *
   * @param clientId The client ID
   * @return A list of session statistics, List<session_statistics__c>
   *
   * @example
   * List<session_statistics__c> > ssList = L4LSessionStatsController.getD3SessionStatsHistogramData(clientId)
   */

  @AuraEnabled(cacheable=true)
  public static List<session_statistics__c> getD3SessionStatsHistogramData(
    String clientId
  ) {
    String SCENARIO = 'Session Statistics - get session stats for a client - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getD3SessionStatsHistogramData() clientId=' +
      clientId,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String querySessionStatsString = 'SELECT percent_correct__c FROM session_statistics__c where session__r.client__r.Id=:clientId';
    List<Session_Statistics__c> results = new List<Session_Statistics__c>();

    results = Database.query(querySessionStatsString);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3SessionStatsHistogramData() returning results=' +
      results,
      SCENARIO,
      'next-gen-nebula-apex'
    );
    System.debug(results);
    return results;
  }

  /*******************************************************************************************************
   * @name getSessionStats
   * @description Return a list of session stats
   *
   * @param searchKey The session ID
   *
   * @return A list of Session_Statistics__c
   *
   * @TODO fix the parameter naming
   * @example
   * List<session_statistics__c> > ssList = L4LSessionStatsController.getSessionStats(clientId)
   */

  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getSessionStats(String searchKey) {
    String SCENARIO = 'Session Statistics - search for session stats for a session - Apex';

    L4LNebulaComponentController.setupCache();

    L4LNebulaComponentController.logInfo(
      searchKey,
      'L4LSessionStatsController.getSessionStats() searchKey=' + searchKey,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Session_Statistics__c> results = new List<Session_Statistics__c>(
      [
        SELECT
          id,
          name,
          objective__r.name,
          session__r.name,
          previous_status__c,
          icon__c,
          iconstr__c,
          totalacquiredcorrect__c,
          totalacquiredincorrect__c,
          totalacquiredprompted__c,
          totalacquirednonresponsive__c,
          Percent_Correct__c,
          Program_Name__c,
          SD_Name__c,
          SD_And_Objective_Str__c
        FROM session_statistics__c
        WHERE session__c = :searchKey
        ORDER BY program_name__c
      ]
    );

    L4LNebulaComponentController.logDebug(
      searchKey,
      'L4LSessionStatsController.getSessionStats() results=' + results,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return results;
  }

  /*******************************************************************************************************
   * @name getD3Stats
   * @description Uses SOQL to return a session statistics for a client.
   *
   * @param clientId The client
   * @param showAcquired A Boolean, should we restrict to previous_status of ACQ
   * @return a list of session statistics
   * @example
   * List<session_statistics__c> > ssList = L4LSessionStatsController.getD3Stats(clientId,true|false)
   */

  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getD3Stats(
    String clientId,
    Boolean showAcquired
  ) {
    String SCENARIO = 'Session Statistics - return session stats (optionally only ACQ) for a client - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getD3Stats() clientId=' +
      clientId +
      ' showAcquired=' +
      showAcquired,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String querySessionStatsString =
      'SELECT session__r.name, session__r.client__c, session__r.client__r.name, program_name__c, ' +
      'objective__r.name  ,session__r.Date__c ,previous_status__c ,Percent_Correct__c, SD_Name__c, SD_And_Objective_Str__c ' +
      'FROM Session_Statistics__c ' +
      'WHERE session__r.client__c = :clientId ';

    if (showAcquired)
      querySessionStatsString += ' AND previous_status__c = \'ACQ\' ';

    querySessionStatsString += 'ORDER BY session__r.name, objective__r.name ';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3Stats() querySessionStatsString=' +
      querySessionStatsString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Session_Statistics__c> results = new List<Session_Statistics__c>();
    results = Database.query(querySessionStatsString);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3Stats() returning results=' + results,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return results;
  }

  /*******************************************************************************************************
   * @name getD3StatsByProgram
   * @description Uses SOQL to return a list of session statistics filtered on program name, and optionally previous status
   *
   * @param clientId Client ID
   * @param programStr The Program Name
   * @param showAcquired A Boolean, should we restrict to previous status of ACQ
   * @return a list of session statistics
   *
   * @example
   * List<session_statistics__c> > ssList = L4LSessionStatsController.getD3StatsByProgram(clientId,programStr,true|false)
   */

  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getD3StatsByProgram(
    String clientId,
    String programStr,
    Boolean showAcquired
  ) {
    String SCENARIO = 'Session Statistics - filter session statistics on program name, and optionally ACQ - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getD3StatsByProgram() clientId=' +
      clientId +
      ' programStr=' +
      programStr +
      ' showAcquired=' +
      showAcquired,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String querySessionStatsString =
      'SELECT session__r.name, session__r.client__c, session__r.client__r.name, program_name__c, ' +
      'objective__r.name  ,session__r.Date__c ,previous_status__c ,Percent_Correct__c, SD_Name__c, SD_And_Objective_Str__c ' +
      'FROM Session_Statistics__c ' +
      'WHERE session__r.client__c = :clientId AND program_name__c=:programStr ';

    if (showAcquired)
      querySessionStatsString += ' AND previous_status__c = \'ACQ\' ';

    querySessionStatsString += 'ORDER BY session__r.name, objective__r.name ';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3StatsByProgram() querySessionStatsString=' +
      querySessionStatsString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Session_Statistics__c> results = new List<Session_Statistics__c>();
    results = Database.query(querySessionStatsString);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3StatsByProgram() returning results=' +
      results,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return results;
  }

  /*******************************************************************************************************
   * @name getClientObjectivesByProgram
   * @description Uses SOQL to return a COUNT of objectives from Client_Objectives__c GROUPed BY the program name
   *
   * @param clientId The client Id
   * @return A list of aggregate results, List<AggregateResult>
   *
   * @example
   * List<AggregateResult>  arl = L4LSessionStatsController.getClientObjectivesByProgram(clientId)
   */

  @AuraEnabled(cacheable=true)
  public static List<AggregateResult> getClientObjectivesByProgram(
    String clientId
  ) {
    String SCENARIO = 'Session Statistics - return a count of Client_Objectives__c for a client GROUPed BY the program name - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getClientObjectivesByProgram() clientId=' +
      clientId,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String queryString =
      'SELECT  Objective__r.SD__r.Program__r.Name, ' +
      'count(Objective__c) objectiveCount FROM Client_Objective__c ' +
      'WHERE client__c = :clientId ' +
      'GROUP BY Objective__r.SD__r.Program__r.Name ' +
      'ORDER BY Objective__r.SD__r.Program__r.Name ';

    List<AggregateResult> results = new List<AggregateResult>();
    results = Database.query(queryString);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getClientObjectivesByProgram() returning results=' +
      results,
      SCENARIO,
      'next-gen-nebula-apex'
    );
    return results;
  }

  /*******************************************************************************************************
   * @name getD3YAxisScale
   * @description A helper for D3 charting to establish the scale required for the Y Axis.
   * Uses SOQL to count the # of ACTIVE client_objectives, and # of client_objective_timeseries records for a client
   *
   * @param clientId The Client ID
   *
   * @return an Integer, the higher of the two counts
   * @TODO look at the requirement for ACTIVE only
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static Integer getD3YAxisScale(String clientId) {
    String SCENARIO = 'Session Statistics - determine YAxis scale for D3 - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getD3YAxisScale() clientId=' + clientId,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Integer ts_max = 0;
    Integer curr_max = 0;
    Integer result = 0;

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3YAxisScale() get current CO count - soql= SELECT count(id) c FROM client_objective__c WHERE client__c = ' +
      clientId +
      ' and active__c=true',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    // this is the current maximum
    List<AggregateResult> curr_agg = [
      SELECT count(id) c
      FROM client_objective__c
      WHERE client__c = :clientId AND active__c = TRUE
    ];

    curr_max = (Integer) curr_agg[0].get('c');

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3YAxisScale() get max CO count from TS - soql= SELECT count(id) c FROM client_objective_timeseries__c ' +
      ' WHERE client__c = ' +
      clientId +
      ' and active__c=true ' +
      ' GROUP BY runId__c ' +
      ' ORDER BY count(id) DESC ' +
      ' LIMIT 1',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    // this is the current maximum of the timeseries set
    List<AggregateResult> ts_agg = [
      SELECT count(id) c
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND active__c = TRUE
      GROUP BY runId__c
      ORDER BY count(id) DESC
      LIMIT 1
    ];

    if (ts_agg.isEmpty()) {
      ts_max = 0;
    } else {
      ts_max = (integer) ts_agg[0].get('c');
    }

    if (curr_max >= ts_max)
      result = curr_max;
    else
      result = ts_max;

    System.debug(
      'curr_max=' +
      curr_max +
      ', ts_max=' +
      ts_max +
      ', result = ' +
      result
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'curr_max=' +
      curr_max +
      ', ts_max=' +
      ts_max +
      ', returning result = ' +
      result,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return result;
  }

  /*******************************************************************************************************
   * @name getD3RetestYAxisScale
   * @description A helper for D3 charting to establish the scale required for the Retest Y Axis.
   * Uses SOQL to count the # of ACTIVE and Re_Test_Recommended client_objectives and client_objective_timeseries records for a client
   *
   * @param clientId The Client ID
   *
   * @return an Integer, the higher of the two counts
   * @TODO look at the requirement for ACTIVE only
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static Integer getD3RetestYAxisScale(String clientId) {
    String SCENARIO = 'Session Statistics - determine Re-Test YAxis scale for D3 - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getD3RetestYAxisScale() clientId=' + clientId,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Integer ts_max = 0;
    Integer curr_max = 0;
    Integer result = 0;

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3RetestYAxisScale() get current CO count - soql= SELECT count(id) c FROM client_objective__c WHERE client__c = ' +
      clientId +
      ' and re_test_recommended__c=true',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    // this is the current maximum
    List<AggregateResult> curr_agg = [
      SELECT count(id) c
      FROM client_objective__c
      WHERE
        client__c = :clientId
        AND active__c = TRUE
        AND re_test_recommended__c = TRUE
    ];

    curr_max = (Integer) curr_agg[0].get('c');

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3YAxisScale() get max CO count from TS - soql= SELECT count(id) c FROM client_objective_timeseries__c ' +
      ' WHERE client__c = ' +
      clientId +
      ' AND active__c=true and re_test_recommended__c=true ' +
      ' GROUP BY runId__c ' +
      ' ORDER BY count(id) DESC ' +
      ' LIMIT 1',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    // this is the current maximum of the timeseries set
    List<AggregateResult> ts_agg = [
      SELECT count(id) c
      FROM client_objective_timeseries__c
      WHERE
        client__c = :clientId
        AND active__c = TRUE
        AND re_test_recommended__c = TRUE
      GROUP BY runId__c
      ORDER BY count(id) DESC
      LIMIT 1
    ];

    if (ts_agg.isEmpty()) {
      ts_max = 0;
    } else {
      ts_max = (integer) ts_agg[0].get('c');
    }

    if (curr_max >= ts_max)
      result = curr_max;
    else
      result = ts_max;

    System.debug(
      'curr_max=' +
      curr_max +
      ', ts_max=' +
      ts_max +
      ', result = ' +
      result
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'curr_max=' +
      curr_max +
      ', ts_max=' +
      ts_max +
      ', returning result = ' +
      result,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return result;
  }

  /*******************************************************************************************************
   * @name getD3StatusYAxisScale
   * @description A helper for D3 charting to establish the scale for the Y Axis.
   * Uses SOQL to return the maximum count for any status for all runs of client_objective_timeseries records for a client
   *
   * @param clientId The client ID
   *
   * @return an Integer - maximum status count for any run for the client
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static Integer getD3StatusYAxisScale(String clientId) {
    String SCENARIO = 'Session Statistics - determine YAxis scale for D3 - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getD3StatusYAxisScale() clientId=' + clientId,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Integer ts_max = 0;
    Integer result = 0;

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3YAxisScale() get max CO count from TS - soql= SELECT runid__c,status__c,count(id) c FROM client_objective_timeseries__c ' +
      ' WHERE client__c = ' +
      clientId +
      ' AND active__c = TRUE' +
      ' GROUP BY runid__c,Status__c ' +
      ' ORDER BY count(id) DESC ' +
      ' LIMIT 1',
      'L4LSessionStatsController.getD3YAxisScale() get max CO count from TS - soql= SELECT runid__c,status__c,count(id) c FROM client_objective_timeseries__c ' +
      ' WHERE client__c = ' +
      clientId +
      ' AND active__c = TRUE' +
      ' GROUP BY Status__c ' +
      ' ORDER BY count(id) DESC ' +
      ' LIMIT 1',
      'next-gen-nebula-apex'
    );

    // this is the current maximum of the timeseries set
    List<AggregateResult> ts_agg = [
      SELECT runid__c, status__c, count(id) c
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND active__c = TRUE
      GROUP BY runid__c, Status__c
      ORDER BY count(id) DESC
      LIMIT 1
    ];

    if (ts_agg.isEmpty()) {
      ts_max = 0;
    } else {
      ts_max = (integer) ts_agg[0].get('c');
    }

    result = ts_max;

    L4LNebulaComponentController.logDebug(
      clientId,
      'returning result = ' + result,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return result;
  }

  /*******************************************************************************************************
   * @name getD3StatsByProgramAndSD
   * @description Use SOQL to create a list of session_statistics__c for a client according to filter parameters
   *
   * @param clientId The client Id
   * @param programStr "All" | program_name__c
   * @param sdStr "All"  sd_name__c
   * @param showAcquired True | False, restrict to ACQ only or not
   * @param periodStr "All" | 30,60,90 days etc
   * @param stageStr "All" | objective__r.sd__r.Stage__c
   *
   * @return a list of session_Statistics__c
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getD3StatsByProgramAndSD(
    String clientId,
    String programStr,
    String sdStr,
    Boolean showAcquired,
    String periodStr,
    String stageStr
  ) {
    String SCENARIO = 'Session Statistics - filter for a client on multiple criteria - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getD3StatsByProgramAndSD() clientId=' +
      clientId +
      ' programStr=' +
      programStr +
      ' sdStr=' +
      sdStr +
      ' showAcquired=' +
      showAcquired +
      ' persiodStr=' +
      periodStr +
      'stageStr= ' +
      stageStr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String querySessionStatsString =
      'SELECT session__r.name, session__r.client__c, session__r.client__r.name, program_name__c, ' +
      'objective__r.name  ,session__r.Date__c ,previous_status__c ,Percent_Correct__c,TotalAcquiredCorrect__c,TotalAcquiredIncorrect__c,TotalAcquiredNonResponsive__c,TotalAcquiredPrompted__c, SD_Name__c, SD_And_Objective_Str__c ' +
      'FROM Session_Statistics__c ' +
      'WHERE session__r.client__c = :clientId ';

    if (programStr == 'All') {
    } else {
      querySessionStatsString += ' AND program_name__c=:programStr ';
    }

    if (sdStr == 'All') {
    } else {
      querySessionStatsString += ' AND SD_Name__c=:sdStr ';
    }

    if (stageStr == 'All') {
    } else {
      querySessionStatsString += ' AND objective__r.sd__r.Stage__c=:stageStr ';
    }
    if (showAcquired)
      querySessionStatsString += ' AND previous_status__c = \'ACQ\' ';

    if (periodStr == 'All') {
    } else {
      querySessionStatsString +=
        ' AND session__r.Date__c = LAST_N_DAYS' +
        ':' +
        periodStr +
        ' ';
    }

    querySessionStatsString += ' ORDER BY session__r.name, objective__r.name ';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3StatsByProgramAndSD() querySessionStatsString=' +
      querySessionStatsString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Session_Statistics__c> results = new List<Session_Statistics__c>();
    results = Database.query(querySessionStatsString);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.getD3StatsByProgramAndSD() results=' + results,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return results;
  }

  /*******************************************************************************************************
   * @name getProgramsAndSds
   * @description Use SOQL to create a list of Programs filtered by Stage
   *
   * @param stageStr
   *
   * @return a list of session_Statistics__c
   * @example
   */
  @AuraEnabled(Cacheable=true)
  public static List<Program__c> getProgramsAndSds(String stageStr) {
    String SCENARIO = 'Session Statistics - filter Programs by Stage - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'L4LSessionStatsController.getProgramsAndSds() stageStr=' + stageStr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String querySessionStatsString =
      'SELECT Id, Name,' +
      '(SELECT id, name, program__r.name, description__c FROM sds__r) ' +
      ' FROM Program__c WHERE status__c =  \'Active\'';

    if (stageStr == 'All') {
      querySessionStatsString += ' AND id IN (SELECT program__c FROM sd__c)';
    } else {
      querySessionStatsString += '  AND id IN (SELECT program__c FROM sd__c where stage__C=:stageStr) ';
    }
    System.debug(querySessionStatsString);

    L4LNebulaComponentController.logDebug(
      null,
      'L4LSessionStatsController.getProgramsAndSds() querySessionStatsString=' +
      querySessionStatsString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Program__c> results = new List<Program__c>();
    results = Database.query(querySessionStatsString);

    L4LNebulaComponentController.logDebug(
      null,
      'L4LSessionStatsController.getProgramsAndSds() results=' + results,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return results;
  }

  /*******************************************************************************************************
   * @name getClientObjectivesSDCount
   * @description Returns as a List<AggregateResult> the count of client_objectives__c for a client, grouped by program, sd
   * @param clientId The client ID
   *
   * @return An AggregateResult list
   * @example
   */

  @AuraEnabled(Cacheable=true)
  public static List<AggregateResult> getClientObjectivesSDCount(
    String clientId
  ) {
    String SCENARIO = 'Session Statistics - return a count of COs grouped by program,sdname - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.getClientObjectivesSDCount() clientId=' +
      clientId,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return [
      SELECT
        objective__r.sd__r.program__R.name progname,
        objective__r.sd__r.name sdname,
        count(id) sdcount
      FROM client_objective__c
      WHERE client__c = :clientId AND active__c = TRUE
      GROUP BY objective__r.sd__r.program__R.name, objective__r.sd__r.name
      ORDER BY count(id)
    ];
  }

  /*******************************************************************************************************
   * @name generateD3ProgramAreaSDJson
   * @description Generates a JSON string  for use by D3 charting
   * @param clientId The client Id
   * @param stageSt "All" | sd__c.stage__c
   *
   * @return a JSON string
   * @TODO work on the explanation and provide an example
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static String generateD3ProgramAreaSDJson(
    String clientId,
    String stageStr
  ) {
    String SCENARIO = 'Session Statistics - return a JSON string for D3 - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.generateD3ProgramAreaSDJson() clientId=' +
      clientId +
      ' stageStr=' +
      stageStr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<AggregateResult> countCoBySD = [
      SELECT objective__r.sd__c sdid, count(id) sdcount
      FROM client_objective__c
      WHERE client__c = :clientId AND active__c = TRUE
      GROUP BY objective__r.sd__c
      ORDER BY count(id)
    ];

    //SDID               SDCOUNT
    //  ────────────────── ───────
    //  a0A8t0000003HqYEAU 1
    //  a0A8t0000003HrmEAE 1
    //  a0A8t0000003HstEAE 1
    //  a0A8t0000003Ho7EAE 1
    //  a0A8t0000003HnjEAE 1
    //...

    Map<Id, Integer> sdCountMap = new Map<Id, Integer>();
    for (AggregateResult sdc : countCoBySD) {
      sdCountMap.put((id) sdc.get('sdid'), (Integer) sdc.get('sdcount'));
    }
    System.debug('countCoBySD=' + countCoBySD);

    String queryProgramString = 'SELECT id, name  ' + 'FROM program__c ';
    if (stageStr == 'All') {
      queryProgramString += ' WHERE id IN (SELECT program__c FROM sd__c WHERE area__c != NULL)';
    } else {
      queryProgramString += ' WHERE id IN (SELECT program__c FROM sd__c WHERE area__c != NULL and stage__c=:stageStr)  ';
    }

    // all programs that have SDs with an area
    //     ID                 NAME
    //  ────────────────── ────────────────────────────
    //  a098t000000JlWXAA0 2D Matching
    //  a098t000000JlWsAAK Categories
    //  a098t000000JlWyAAK Come Here
    //  a098t000000JlX0AAK Communication Temptation
    //  a098t000000JlXFAA0 Do That
    //  a098t000000JlXJAA0 Emotions
    //  a098t000000JlXOAA0 Fine motor imitation
    //  a098t000000JlXPAA0 Fine Motor Task Completion
    //...

    Map<id, program__c> pmap = new Map<id, program__c>(
      (List<Program__c>) Database.query(queryProgramString)
    );
    System.debug('pmap=' + pmap);

    //pmap=
    // {a098t000000JlWXAA0=Program__c:{Id=a098t000000JlWXAA0, Name=2D Matching},
    // a098t000000JlWYAA0=Program__c:{Id=a098t000000JlWYAA0, Name=3D Matching},
    // a098t000000JlWZAA0=Program__c:{Id=a098t000000JlWZAA0, Name=3D to 2D Matching},
    //...

    Map<id, Set<String>> areamap = new Map<id, Set<String>>();

    List<AggregateResult> xarlist = [
      SELECT program__c, area__c, count(id)
      FROM sd__c
      WHERE area__c != NULL
      GROUP BY program__c, area__c
    ];

    //     PROGRAM__C         AREA__C             COUNT(ID)
    //  ────────────────── ─────────────────── ─────────
    //  a098t000000JlXFAA0 Self-Care           1
    //  a098t000000JlZHAA0 Self-Care           1
    //  a098t000000JlWYAA0 Play-Skills         1
    //  a098t000000JlWgAAK Imitation           1
    //  a098t000000JlWXAA0 Matching            2
    //...

    System.debug('xarlist=' + xarlist);

    // (AggregateResult:{Program__c=a098t000000JlXFAA0, Area__c=Self-Care, expr0=1},
    // AggregateResult:{Program__c=a098t000000JlZHAA0, Area__c=Self-Care, expr0=1},
    // AggregateResult:{Program__c=a098t000000JlWYAA0, Area__c=Play-Skills, expr0=1},

    for (aggregateResult a : xarlist) {
      id i = (id) a.get('program__c');
      string area = (string) a.get('area__c');

      // if (areamap.get(i) == null) {
      //   Set<string> temp = new Set<string>();
      //   temp.add(area);
      //   areamap.put(i, temp);
      // } else {
      //   Set<string> temp2 = areamap.get(i);
      //   temp2.add(area);
      //   areamap.put(i, temp2);
      // }

      if (!areamap.containsKey(i)) {
        Set<string> temp = new Set<string>();
        temp.add(area);
        areamap.put(i, temp);
      } else {
        Set<string> temp2 = areamap.get(i);
        temp2.add(area);
        areamap.put(i, temp2);
      }
    }
    System.debug('areamaP=' + areamap);

    // areamaP=
    // maps  program__c ===> area__c
    // {a098t000000JlWXAA0={Matching},
    // a098t000000JlWYAA0={Abstract Concepts, Play-Skills},
    // a098t000000JlWZAA0={Expressive Language},
    // a098t000000JlWaAAK={Kinder Readiness, Learning to Learn, Receptive-Language},
    // a098t000000JlWcAAK={Expressive Language},

    //generate  the JSON
    String jsontmp = '{"children":[';
    jsontmp += '{"name": "flare",';
    jsontmp += '"children": [';
    System.debug(jsontmp);

    Set<id> idlist = pmap.keySet();
    for (Id i : idlist) {
      Program__c p = pmap.get(i);
      jsontmp += '{"name":"' + p.name + '",';
      jsontmp += '"children":[';
      Set<string> tempset = areamap.get(p.Id);
      for (String areaname : tempset) {
        jsontmp +=
          '{"name":"' +
          (String) areaname +
          '","program":"' +
          p.name +
          '",';

        jsontmp += '"children":[';
        for (sd__c sd : [
          SELECT Id, name, stage__c
          FROM sd__c
          WHERE program__c = :p.Id AND area__c = :areaname
        ]) {
          // looks like
          //  ID                 NAME          STAGE__C
          //  ────────────────── ───────────── ─────────
          //  a0A8t0000003HnNEAU Identical     Stage One
          //  a0A8t0000003HnOEAU Non-Identical Stage One

          Integer val = 0;
          Integer actualval = 0;

          // if ((Integer) sdCountMap.get(sd.Id) == null) {
          //   actualval = 0;
          // } else {
          //   actualval = (Integer) sdCountMap.get(sd.Id);
          // }

          if (!sdCountMap.containsKey(sd.Id)) {
            actualval = 0;
          } else {
            actualval = (Integer) sdCountMap.get(sd.Id);
          }

          val = actualval + 1;

          jsontmp +=
            '{"name":"' +
            sd.name +
            '","value":' +
            val +
            ',"actualval":' +
            actualval +
            ',"stage":"' +
            sd.stage__c +
            '","area":"' +
            areaname +
            '","program":"' +
            p.Name +
            '" },';
        }

        jsontmp += ']},';
      }
      jsontmp += ']},';
    }
    jsontmp += ']}';
    jsontmp += ']}';

    String target = ',]';
    String replacement = ']';
    String jsonstr = jsontmp.replace(target, replacement);
    System.debug(jsonstr);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.generateD3ProgramAreaSDJson() returning jsonstr=' +
      jsonstr,
      'LWC Apex D3 Charting',
      'next-gen-nebula-apex'
    );

    return jsonstr;
  }

  /*******************************************************************************************************
   * @name generateD3AreaSDJson
   * @description Generates a JSON string  for use by D3 charting.
   * Sorts lisdt of SDs by Name using a custom sorter comparison method in LFLSDWrapper
   *
   * @param clientId The client Id
   * @param stageStr "All" | sd__c.stage__c
   *
   * @return a JSON string
   * @see LFLSDWrapper
   * @TODO work on the explanation and provide an example
   * @example
   *
   */

  @AuraEnabled(cacheable=true)
  public static String generateD3AreaSDJson(String clientId, String stageStr) {
    String SCENARIO = 'Session Statistics - return a JSON string for D3 - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LSessionStatsController.generateD3AreaSDJson() clientId=' +
      clientId +
      ' stageStr=' +
      stageStr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Map<String, List<LFLSDWrapper>> sdAllAreaMap = new Map<String, List<LFLSDWrapper>>();

    String queryAreaString = 'SELECT id, name, stage__c, objective_count__c,area__c, program__r.name FROM sd__c WHERE area__c != NULL ';
    if (stageStr == 'All') {
    } else {
      queryAreaString += ' and stage__c = :stageStr ';
    }
    queryAreaString += ' order by area__c,objective_count__c desc';

    List<sd__c> sdAllAreaList = Database.query(queryAreaString);

    for (sd__c sd : sdAllAreaList) {
      if (!sdAllAreaMap.containsKey(sd.area__c)) {
        //List<sd__c> temp = new List<sd__c>();
        List<LFLSDWrapper> temp = new List<LFLSDWrapper>();
        temp.add(new LFLSDWrapper(sd));
        sdAllAreaMap.put(sd.area__c, temp);
      } else {
        //List<sd__c> temp2 = sdAllAreaMap.get(sd.area__c);
        List<LFLSDWrapper> temp2 = sdAllAreaMap.get(sd.area__c);
        temp2.add(new LFLSDWrapper(sd));
        sdAllAreaMap.put(sd.area__c, temp2);
      }

      System.debug('sdAllAreaMap= ' + sdAllAreaMap);
    }

    List<AggregateResult> countCoBySD = [
      SELECT objective__r.sd__c sdid, count(id) sdcount
      FROM client_objective__c
      WHERE client__c = :clientId AND active__c = TRUE
      GROUP BY objective__r.sd__c
      ORDER BY count(id)
    ];
    System.debug('countCoBySD=' + countCoBySD);

    //SDID               SDCOUNT
    //  ────────────────── ───────
    //  a0A8t0000003HqYEAU 1
    //  a0A8t0000003HrmEAE 1
    //  a0A8t0000003HstEAE 1
    //  a0A8t0000003Ho7EAE 1
    //  a0A8t0000003HnjEAE 1
    //...

    Map<Id, Integer> sdCountMap = new Map<Id, Integer>();
    for (AggregateResult sdc : countCoBySD) {
      sdCountMap.put((id) sdc.get('sdid'), (Integer) sdc.get('sdcount'));
    }

    //generate  the JSON
    String jsontmp = '{"children":[';
    jsontmp += '{"name": "flare",';
    jsontmp += '"children": [';
    System.debug(jsontmp);

    Set<String> sdAllAreaSet = sdAllAreaMap.keySet();
    List<String> sdSortedAllAreaSetList = new List<String>(sdAllAreaSet);
    sdSortedAllAreaSetList.sort();

    for (String areaname : sdSortedAllAreaSetList) {
      jsontmp += '{"name":"' + (String) areaname + '",';
      jsontmp += '"children":[';
      List<LFLSDWrapper> sdList = sdAllAreaMap.get(areaname);
      sdList.sort();

      for (LFLSDWRapper sdw : sdList) {
        Integer val = 0;
        Integer actualval = 0;
        sd__c sd = sdw.sd;

        // if ((Integer) sdCountMap.get(sd.Id) == null) {
        //   actualval = 0;
        // } else {
        //   actualval = (Integer) sdCountMap.get(sd.Id);
        // }

        if (!sdCountMap.containsKey(sd.Id)) {
          actualval = 0;
        } else {
          actualval = (Integer) sdCountMap.get(sd.Id);
        }

        val = actualval + 1;
        String name = (String) sd.get('name');
        String stage = (String) sd.get('stage__c');
        jsontmp +=
          '{"name":"' +
          name +
          '","value":' +
          val +
          ',"actualval":' +
          actualval +
          ',"stage":"' +
          stage +
          '","area":"' +
          areaname +
          '" },';
      }

      jsontmp += ']},';
    }
    jsontmp += ']}]}';

    //trim the extraneous characters
    String target = ',]';
    String replacement = ']';
    String jsonstr = jsontmp.replace(target, replacement);

    Boolean isValidJSON = false;
    String message = jsonstr;
    try {
      Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(
        message
      );
      isValidJSON = true;
    } catch (JSONException e) {
      System.debug(e.getMessage());
    }
    System.debug('isValidJSON=' + isValidJSON);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LSessionStatsController.generateD3AreaSDJson() returning jsonstr=' +
      jsonstr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return jsonstr;
  }

  /*******************************************************************************************************
   * @name getProgramSetFromCO
   * @description Generates a set (well actually a Set coerced into a List because LWC can't accept Sets) of Programs currently used in this client's client objectives.
  Used in pull down filters on D3 charts
   *
   * @param clientId The client Id
   *
   * @return A set of Program names as List<String>
   * @TODO logging
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static List<String> getProgramSetFromCO(String clientId) {
    Set<String> pTmpSet = new Set<String>();
    for (client_objective__c l : [
      SELECT program_name__c
      FROM client_objective__c
      WHERE client__c = :clientId
      ORDER BY program_name__c
    ]) {
      pTmpSet.add(l.program_name__c);
    }
    List<String> pSet = new List<String>(pTmpSet);
    System.debug(pSet);
    return pSet;
  }

  /*******************************************************************************************************
   * @name getSDSetFromCO
   * @description Generates a set (well actually a Set coerced into a List because LWC can't accept Sets) of SDs currently used in this client's client objectives.
  Used in pull down filters on D3 charts
   *
   * @param clientId the client Id
   *
   * @return a set of SD names as  List<String>
   * @TODO logging
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static List<String> getSDSetFromCO(String clientId) {
    Set<String> sdTmpSet = new Set<String>();
    List<client_objective__c> coList = [
      SELECT sd_name__c
      FROM client_objective__c
      WHERE client__c = :clientId
      ORDER BY sd_name__c
    ];

    for (client_objective__c co : coList) {
      sdTmpSet.add(co.sd_name__c);
    }
    List<String> sdSet = new List<String>(sdTmpSet);
    System.debug(sdSet);
    return sdSet;
  }
}
