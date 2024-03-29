/**************************************************************
 * @name L4LTimeSeries
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	Methods for creating and querying Client_Objective_TimeSeries__c records
 *
 */

public class L4LTimeSeries {
  /*******************************************************************************************************
   * @name loadCOTimeSeries
   * @description Creates a timeseries by copying all client_objectives__c at a point in time.
   * Timeseries table is client_objectives_timeseries__c
   * Logging for the run is recorded in TimeSeries_Log__c.
   *
   *
   * @return the number of records inserted into client_objectives_timeseries__c
   *
   * @example
   * Integer recs = L4LTimeSeries.loadCOTimeSeries();
   */

  public Integer loadCOTimeSeries() {
    System.debug('in loadCOTimeSeries()');
    System.debug('in loadCOTimeSeries(): logging START to TimeSeries_Log__c()');

    TimeSeries_Log__c log = new TimeSeries_Log__c();
    if (L4LTimeSeries.previousCOTSLoad(Date.today())) {
      log.comments__c = 'Error: duplicate run prevented. 0 Client_Objective_Timeseries__c records / 0 Client_Objective_Timeseries_Rollup__c records processed';
      insert log;
      return 0; //bail
    } else {
      log.comments__c = 'Started client objective timeseries run';
      insert log;
      String runId = [SELECT name FROM TimeSeries_Log__c WHERE id = :log.Id]
      .Name;

      String clientObjectiveSOQLStr =
        'Select Id,Client__c,Client_Objective_Notes__c, Date_Absorbed__c,' +
        'Date_Acquired__c, Date_CIP__c, Date_Held__c, Date_Introduced__c,' +
        'Days_Since_Tested_Correct__c, Days_Since_Tested__c, Frequency__c,' +
        'Name, Objective__c, Program_Name__c, Area__c, Stage__c,' +
        'Re_Test_Recommended__c, Status__c, Active__c FROM Client_Objective__c ';

      List<Client_Objective__c> results = new List<Client_Objective__c>();

      System.debug('clientObjectiveSOQLStr= ' + clientObjectiveSOQLStr);

      results = Database.query(clientObjectiveSOQLStr);

      List<Client_Objective_TimeSeries__c> tslist = new List<Client_Objective_TimeSeries__c>();

      for (client_objective__c co : results) {
        Client_Objective_TimeSeries__c tsrecord = new Client_Objective_TimeSeries__c();
        tsrecord.runId__c = runId;
        tsrecord.client_objective__c = co.Id;
        tsrecord.client__c = co.client__c;
        tsrecord.client_objective_notes__c = co.client_objective_notes__c;
        tsrecord.Date_Absorbed__c = co.Date_Absorbed__c;
        tsrecord.Date_Acquired__c = co.Date_Acquired__c;
        tsrecord.Date_CIP__c = co.Date_CIP__c;
        tsrecord.Date_Held__c = co.Date_Held__c;
        tsrecord.Date_Introduced__c = co.Date_Introduced__c;
        tsrecord.Days_Since_Tested_Correct__c = co.Days_Since_Tested_Correct__c;
        tsrecord.Days_Since_Tested__c = co.Days_Since_Tested__c;
        tsrecord.Frequency__c = co.Frequency__c;
        tsrecord.CO_Name__c = co.Name;
        tsrecord.Objective__c = co.Objective__c;
        tsrecord.Stage__c = co.Stage__c;
        tsrecord.Area__c = co.Area__c;
        tsrecord.status__c = co.status__c;
        tsrecord.active__c = co.active__c;

        tsrecord.Re_Test_Recommended__c = co.Re_Test_Recommended__c;
        tslist.add(tsrecord);
      }

      try {
        insert tslist;

        System.debug(
          'loadCOTimeSeries(): updating Client_Objective_Timeseries_Rollup__c : '
        );

        List<AggregateResult> aggl = new List<AggregateResult>();
        aggl = [
          SELECT Client__c, Status__c, count(id)
          FROM Client_Objective_TimeSeries__c
          WHERE runid__c = :runId
          GROUP BY client__c, Status__c
        ];
        List<Client_Objective_Timeseries_Rollup__c> cotsrulist = new List<Client_Objective_Timeseries_Rollup__c>();
        for (AggregateResult ar : aggl) {
          client_objective_timeseries_rollup__c cotsru = new client_objective_timeseries_rollup__c();

          Id clientId = (id) ar.get('Client__c');
          String status = (String) ar.get('Status__c');
          Integer statuscount = (Integer) ar.get('expr0');

          System.debug(clientId);
          cotsru.runId__c = runId;
          cotsru.client__c = clientId;
          cotsru.status__c = status;
          cotsru.statuscount__c = statuscount;
          cotsrulist.add(cotsru);
        }

        insert cotsrulist;

        // log end of run
        System.debug(
          'loadCOTimeSeries(): logging END to TimeSeries_Log__c(): ' + log
        );

        TimeSeries_Log__c endlog = new TimeSeries_Log__c();
        endlog.comments__c =
          'Successfully processed ' +
          tslist.size() +
          ' Client_Objective_Timeseries__c records / ' +
          cotsrulist.size() +
          ' Client_Objective_Timeseries_Rollup__c records';
        insert endlog;

        System.debug(
          'loadCOTimeSeries(): successfully logged END to TimeSeries_Log__c(): ' +
          log
        );
      } catch (DmlException e) {
        System.debug('error ' + e.getMessage());
      }
      System.debug(
        tslist.size() + ' Client Objective TimeSeries records processed '
      );
      return tslist.size();
    }
  }

  /*******************************************************************************************************
   * @name previousCOTSLoad
   * @description check for previous COTS load
   * @param d the date to check
   *
   * @return true - Yes, there was another load today
   *
   * @example
   * Boolean anotherloadToday = L4LTimeSeries.previousSameDayCOTSLoad(Date);
   */

  public static Boolean previousCOTSLoad(Date d) {
    Set<Date> dateset = new Set<Date>();
    for (Timeseries_log__c tsl : [
      SELECT ts_log_datetime__c
      FROM timeseries_log__c
    ]) {
      Date datevar = tsl.ts_log_datetime__c.date();
      dateset.add(datevar);
    }

    return (dateset.contains(d));
  }

  /*******************************************************************************************************
   * @name generateD3COTimeSeriesJson
   * @description Generate a JSON string for use by D3
   * @deprecated No longer used
   *
   * @param clientId
   * @param status All (actually ACQ & CIP) | status__c

   * @return the number of records inserted into client_objectives_timeseries__c
   * @TODO example of format returned
   * @example
   * String jsonstr  = L4LTimeSeries.generateD3COTimeSeriesJson(clientId, 'All');
   *     
   * [{"rundate":"2022-11-27","val":2},{"rundate":"2022-12-4","val":2}]
   */

  @AuraEnabled(cacheable=true)
  public static String generateD3COTimeSeriesJson(
    String clientId,
    String status
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesJson',
      'CO TimeSeries - generate a JSON string for D3',
      'next-gen-nebula-apex'
    );

    String queryCOTSString = 'SELECT calendar_Year(TS_Load_DateTime__c) year,calendar_Month(TS_Load_DateTime__c) month,day_in_Month(TS_Load_DateTime__c) day,count(id) val  FROM client_objective_timeseries__c ';

    queryCOTSString += ' where active__c=true and client__c=:clientId ';
    if (status == 'All') {
      queryCOTSString += ' and status__c in (\'ACQ\',\'CIP\') ';
    } else if (status == 'Null') {
      queryCOTSString += ' and status__c = null ';
    } else {
      queryCOTSString += ' and status__c = :status ';
    }

    queryCOTSString += ' group by calendar_Year(TS_Load_DateTime__c),calendar_Month(TS_Load_DateTime__c),day_in_Month(TS_Load_DateTime__c) order by calendar_Year(TS_Load_DateTime__c),calendar_month(TS_Load_DateTime__c),day_in_month(TS_Load_DateTime__c)';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesJson, queryCOTSString=' +
      queryCOTSString,
      'CO TimeSeries - generate a JSON string for D3',
      'next-gen-nebula-apex'
    );

    List<AggregateResult> cotslist = Database.query(queryCOTSString);

    System.debug('queryCOTSString=' + queryCOTSString);

    //generate  the JSON
    String jsontmp = '[';

    for (AggregateResult agg : cotslist) {
      jsontmp += '{';
      jsontmp +=
        '"rundate":"' +
        agg.get('year') +
        '-' +
        agg.get('month') +
        '-' +
        agg.get('day') +
        '",';
      jsontmp += '"val":' + agg.get('val') + '}';
      jsontmp += ',';
    }

    jsontmp += ']';
    String target = ',]';
    String replacement = ']';
    String jsonstr = jsontmp.replace(target, replacement);

    System.debug('json str=' + jsonstr);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesJson, returning jsonstr=' + jsonstr,
      'CO TimeSeries - generate a JSON string for D3',
      'next-gen-nebula-apex'
    );

    return jsonstr;
  }

  /*******************************************************************************************************
   * @name generateD3COTSJsonByProgramAndSD
   * @description Generate a JSON string for use by D3
   * Used by LWC d3COTSCombinedLineChart- the combined Client Objective line chart
   *
   *
   * @param clientId the client Id
   * @param program "All" | program_name__c
   * @param sd "All" | sd_name__c
   * @param status "Both" (ACQ|CIP) | client_objective_timeseries__c.status__c
   * @param periodStr "All" | 30,60,90 days etc -- LAST N Days

   * @return a JSON string
   * @TODO example of format returned
   * @example
   * String jsonstr  = L4LTimeSeries.generateD3COTSJsonByProgramAndSD(clientId, programName,sdName,'Both','60');
   * 
   * jsonStr example: [{"rundate":"2023-2-12","val":8},{"rundate":"2023-2-19","val":9},...]
*/
  @AuraEnabled(cacheable=true)
  public static String generateD3COTSJsonByProgramAndSD(
    String clientId,
    String program,
    String sd,
    String status,
    String periodStr
  ) {
    final String SCENARIO = 'D3 TimeSeries Chart - Combined Client Objectives - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LTimeSeries.generateD3COTSJsonByProgramAndSD',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String queryCOTSString = 'SELECT calendar_Year(TS_Load_DateTime__c) year,calendar_Month(TS_Load_DateTime__c) month,day_in_Month(TS_Load_DateTime__c) day,count(id) val  FROM client_objective_timeseries__c ';
    queryCOTSString += ' where client__c=:clientId ';

    if (program == 'All') {
    } else {
      queryCOTSString += ' and program_name__c=:program ';
    }

    if (sd == 'All') {
    } else {
      queryCOTSString += ' and sd_name__c=:sd ';
    }

    if (status == 'All (ABS/ACQ/CIP)') {
      queryCOTSString += ' and status__c in (\'ACQ\',\'ABS\',\'CIP\') ';
    } else if (status == 'Mastered (ABS/ACQ)') {
      queryCOTSString += ' and status__c in (\'ACQ\',\'ABS\') ';
    } else {
      queryCOTSString += ' and status__c = :status ';
    }

    if (periodStr == 'All') {
    } else {
      queryCOTSString +=
        ' AND TS_Load_DateTime__c = LAST_N_DAYS' +
        ':' +
        periodStr +
        ' ';
    }

    queryCOTSString += ' group by calendar_Year(TS_Load_DateTime__c),calendar_Month(TS_Load_DateTime__c),day_in_Month(TS_Load_DateTime__c) order by calendar_Year(TS_Load_DateTime__c),calendar_month(TS_Load_DateTime__c),day_in_month(TS_Load_DateTime__c)';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTSJsonByProgramAndSD, queryCOTSString=' +
      queryCOTSString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<AggregateResult> cotslist = Database.query(queryCOTSString);

    System.debug('queryCOTSString=' + queryCOTSString);

    //generate  the JSON
    String jsontmp = '[';

    for (AggregateResult agg : cotslist) {
      jsontmp += '{';
      jsontmp +=
        '"rundate":"' +
        agg.get('year') +
        '-' +
        agg.get('month') +
        '-' +
        agg.get('day') +
        '",';
      jsontmp += '"val":' + agg.get('val') + '}';
      jsontmp += ',';
    }

    jsontmp += ']';
    String target = ',]';
    String replacement = ']';
    String jsonstr = jsontmp.replace(target, replacement);

    System.debug('json str=' + jsonstr);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesJson, returning jsonstr=' + jsonstr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return jsonstr;
  }

  /*******************************************************************************************************
   * @name generateD3COTimeSeriesByStatusJson
   * @description Generate a JSON string for use by D3
   * Used by LWC d3MiniBars to plot Client Objectives TS as separate status charts

   *
   *
   * @param clientId the client Id
   * @return a JSON string
   * @TODO example of format returned
   * @example
   * String jsonstr  = L4LTimeSeries.generateD3COTimeSeriesByStatusJson(clientId);
   *
   * jsonStr example: [{"rundate":"2022-12-25","val":3,"status":"CIP"},
   * {"rundate":"2023-1-1","val":3,"status":"CIP"},{"rundate":"2023-1-8","val":3,"status":"CIP"},
   * {"rundate":"2023-1-15","val":6,"status":"ACQ"},{"rundate":"2023-1-22","val":4,"status":"ACQ"}
   * ...]
   */

  @AuraEnabled(cacheable=true)
  public static String generateD3COTimeSeriesByStatusJson(String clientId) {
    final String SCENARIO = 'D3 TimeSeries Chart - MiniBars - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String queryCOTSString = 'SELECT calendar_Year(TS_Load_DateTime__c) year,calendar_Month(TS_Load_DateTime__c) month,day_in_Month(TS_Load_DateTime__c) day, status__c, count(id) val  FROM client_objective_timeseries__c ';
    queryCOTSString += ' where client__c=:clientId and status__c in (\'ACQ\',\'ABS\',\'CIP\')';
    queryCOTSString += ' group by calendar_Year(TS_Load_DateTime__c),calendar_Month(TS_Load_DateTime__c),day_in_Month(TS_Load_DateTime__c),status__c order by calendar_Year(TS_Load_DateTime__c),calendar_month(TS_Load_DateTime__c),day_in_month(TS_Load_DateTime__c),status__c';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson, queryCOTSString=' +
      queryCOTSString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<AggregateResult> cotslist = Database.query(queryCOTSString);
    System.debug('queryCOTSString=' + queryCOTSString);

    //generate  the JSON
    String jsontmp = '[';

    for (AggregateResult agg : cotslist) {
      jsontmp += '{';
      jsontmp +=
        '"rundate":"' +
        agg.get('year') +
        '-' +
        agg.get('month') +
        '-' +
        agg.get('day') +
        '",';
      jsontmp += '"val":' + agg.get('val') + ',';
      jsontmp += '"status":"' + agg.get('status__c') + '"}';
      jsontmp += ',';
    }

    jsontmp += ']';
    String target = ',]';
    String replacement = ']';
    String jsonstr = jsontmp.replace(target, replacement);

    System.debug('json str=' + jsonstr);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson, returning jsonstr=' +
      jsonstr,
      SCENARIO,
      'next-gen-nebula-apex'
    );
    return jsonstr;
  }

  /*******************************************************************************************************
   * @name generateD3CORetestTimeSeriesJson
   * @description Generate a JSON string for use by D3 chart in d3COTSRetestChart
   *
   *
   * @param clientId the client Id
   * @param status "All" | client_objective_timeseries__c.status__c
   * @return a JSON string
   * @TODO example of format returned
   * @example
   * String jsonstr  = L4LTimeSeries.generateD3CORetestTimeSeriesJson(clientId,'ACQ');
   *
   * jsonStr example: [{"rundate":"2023-1-15","val":2},{"rundate":"2023-1-29","val":1},{"rundate":"2023-2-12","val":2},
   * {"rundate":"2023-2-19","val":1},{"rundate":"2023-2-26","val":3},{"rundate":"2023-3-5","val":4},
   * ...]
   *
   *
   */

  @AuraEnabled(cacheable=true)
  public static String generateD3CORetestTimeSeriesJson(
    String clientId,
    String status
  ) {
    final String SCENARIO = 'D3 TimeSeries Chart - Restest Summary - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LTimeSeries.generateD3CORetestTimeSeriesJson',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String queryCOTSString = 'SELECT calendar_Year(TS_Load_DateTime__c) year,calendar_Month(TS_Load_DateTime__c) month,day_in_Month(TS_Load_DateTime__c) day,count(id) val  FROM client_objective_timeseries__c ';
    queryCOTSString += ' where active__c=true and client__c=:clientId and re_test_recommended__c= true ';
    if (status == 'All') {
    } else if (status == 'Null') {
      queryCOTSString += ' and status__c = null ';
    } else {
      queryCOTSString += ' and status__c = :status ';
    }

    queryCOTSString += ' group by calendar_Year(TS_Load_DateTime__c),calendar_Month(TS_Load_DateTime__c),day_in_Month(TS_Load_DateTime__c) order by calendar_Year(TS_Load_DateTime__c),calendar_month(TS_Load_DateTime__c),day_in_month(TS_Load_DateTime__c)';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3CORetestTimeSeriesJson, queryCOTSString=' +
      queryCOTSString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<AggregateResult> cotslist = Database.query(queryCOTSString);

    System.debug('queryCOTSString=' + queryCOTSString);

    //generate  the JSON
    String jsontmp = '[';

    for (AggregateResult agg : cotslist) {
      jsontmp += '{';
      jsontmp +=
        '"rundate":"' +
        agg.get('year') +
        '-' +
        agg.get('month') +
        '-' +
        agg.get('day') +
        '",';
      jsontmp += '"val":' + agg.get('val') + '}';
      jsontmp += ',';
    }

    jsontmp += ']';
    String target = ',]';
    String replacement = ']';
    String jsonstr = jsontmp.replace(target, replacement);

    System.debug('json str=' + jsonstr);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3CORetestTimeSeriesJson, returning jsonstr=' +
      jsonstr,
      SCENARIO,
      'next-gen-nebula-apex'
    );
    return jsonstr;
  }

  /*******************************************************************************************************
   * @name generateD3COTSThresholdJson
   * @description Generate a JSON string for use by D3
   * Used by LWC l4lACQThresholdSummary
   *
   * @param clientId the client Id
   * @param threshold1 Integer hours of therapy -the first threshold
   * @param threshold2 Integer hours of therapy -the second threshold

   * @return a JSON string
   * @TODO logging
   * @example
   * String jsonstr  = L4LTimeSeries.generateD3COTSThresholdJson(clientId,100,200);
   *
   * {"reserved1":1,"reserved2":2,
   * "sessiondata":[
   * {"thresholdHrs":100,"thresholdReached":false,"actualHrsAtThreshold":69.5,"runId":"TSL-2023-04-000042","runDate":"2023-04-23","dateAtThreshold":"2023-04-21 00:00:00",
   * "data":[
   * {"key":0,"programName":"Arts and Crafts","acquiredCount":1},
   * {"key":1,"programName":"Behaviour Vocabulary","acquiredCount":1},
   * ...
   * {"key":6,"programName":"Conversation","acquiredCount":2},
   * ...
   * {"key":16,"programName":"Why/because","acquiredCount":4}],
   * "acquiredTotal":55}
   * ]}
   */

  @AuraEnabled(cacheable=true)
  public static String generateD3COTSThresholdJson(
    String clientId,
    Integer threshold1,
    Integer threshold2
  ) {
    final String SCENARIO = 'D3 TimeSeries Chart - Threshold and Filters - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LTimeSeries.generateD3COTSThresholdJson',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Decimal valueAtThreshold1, valueAtThreshold2, totalSessionLength = 0;
    Date d1 = Date.today();
    Date d2 = Date.today();
    String runId1, runId2;
    Integer key = 0;
    Boolean reachedThreshold1 = false;
    Boolean reachedThreshold2 = false;
    String jsonStr = '{"reserved1":1,"reserved2":2';

    String maxRunId = [
      SELECT runid__c
      FROM client_objective_timeseries__c
      ORDER BY runid__c DESC
      LIMIT 1
    ]
    .runid__c;

    for (Session__c s : [
      SELECT date__c, session_length__C
      FROM session__c
      WHERE client__c = :clientId
      ORDER BY date__c
    ]) {
      totalSessionLength += s.session_length__c;
      System.debug(
        'date=' +
          s.date__c +
          ' length=' +
          s.session_length__c +
          ' ,totalSessionLength=' +
          totalSessionLength
      );

      if (totalSessionLength >= threshold1 && !reachedThreshold1) {
        System.debug('reached ' + threshold1);
        reachedThreshold1 = true;
        valueAtThreshold1 = totalSessionLength;
        d1 = s.date__c;
        System.debug('date reached threshold1=' + d1);
        System.debug('valueAtThreshold1=' + valueAtThreshold1);
      }

      if (!reachedThreshold1) {
        valueAtThreshold1 = totalSessionLength;
        d1 = s.date__c;
      }

      if (totalSessionLength >= threshold2 && !reachedThreshold2) {
        System.debug('reached ' + threshold2);
        reachedThreshold2 = true;
        valueAtThreshold2 = totalSessionLength;
        d2 = s.date__c;
        System.debug('date reached threshold2=' + d2);
        System.debug('valueAtThreshold2=' + valueAtThreshold2);
      }

      if (!reachedThreshold2) {
        valueAtThreshold2 = totalSessionLength;
        d2 = s.date__c;
      }
    }
    System.debug('d1' + d1 + ' ' + 'd2' + d2);
    System.debug(
      'reachedThreshold1' +
        reachedThreshold1 +
        ' ' +
        'reachedThreshold2' +
        reachedThreshold2
    );
    System.debug(
      'valueAtThreshold1' +
        valueAtThreshold1 +
        ' ' +
        'valueAtThreshold2' +
        valueAtThreshold2
    );

    jsonStr += ',"sessiondata":[';
    List<AggregateResult> lar1 = [
      SELECT client__c, min(runid__c)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND ts_load_datetime__c >= :d1
      GROUP BY client__c
    ];

    if (lar1.size() == 0) {
      System.debug('Not in TS yet, using latest maxRunId');
      runId1 = maxRunId;
    } else {
      runId1 = (String) lar1[0].get('expr0');
    }

    DateTime run1DT = [
      SELECT ts_load_datetime__c
      FROM client_objective_timeseries__c
      WHERE runid__c = :runId1
      LIMIT 1
    ]
    .ts_load_datetime__c;

    String formattedRun1DT = run1DT.formatGMT('yyyy-MM-dd');

    jsonStr +=
      '{"thresholdHrs":' +
      threshold1 +
      ',"thresholdReached":' +
      reachedThreshold1 +
      ',"actualHrsAtThreshold":' +
      valueAtThreshold1 +
      ',"runId":"' +
      runId1 +
      '","runDate":"' +
      formattedRun1DT +
      '","dateAtThreshold":"' +
      d1 +
      '"';

    System.debug(jsonStr);

    List<AggregateResult> lar2 = [
      SELECT client__c, min(runid__c)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND ts_load_datetime__c >= :d2
      GROUP BY client__c
    ];

    if (lar2.size() == 0) {
      System.debug('Not in TS yet, using latest maxRunId');
      runId2 = maxRunId;
    } else {
      runId2 = (String) lar2[0].get('expr0');
    }

    System.debug('totalSessionLength=' + totalSessionLength);

    Integer acqAtT1 = 0;
    jsonStr += ',"data":[';
    for (AggregateResult ar : [
      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND runid__c = :runId1 AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ]) {
      acqAtT1 += (Integer) ar.get('expr0');
      jsonStr += '{"key":' + key + ',';
      jsonStr += '"programName":"' + ar.get('Name') + '",';
      jsonStr += '"acquiredCount":' + ar.get('expr0') + '},';

      System.debug('Threshold1====>' + ar.get('Name') + ' ' + ar.get('expr0'));
      key++;
    }

    jsonStr += '],"acquiredTotal":' + acqAtT1 + '},';
    jsonStr +=
      '{"thresholdHrs":' +
      threshold2 +
      ',"thresholdReached":' +
      reachedThreshold2 +
      ',"actualHrsAtThreshold":' +
      valueAtThreshold2 +
      ',"runId":"' +
      runId2 +
      '","dateAtThreshold":"' +
      d2 +
      '"';

    System.debug('Total Acq at T1=' + acqAtT1);
    Integer acqAtT2 = 0;
    jsonStr += ',"data":[';

    for (AggregateResult ar : [
      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND runid__c = :runId2 AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ]) {
      acqAtT2 += (Integer) ar.get('expr0');
      jsonStr += '{"key":' + key + ',';
      jsonStr += '"programName":"' + ar.get('Name') + '",';
      jsonStr += '"acquiredCount":' + ar.get('expr0') + '},';
      System.debug('Threshold2====>' + ar.get('Name') + ' ' + ar.get('expr0'));
      key++;
    }
    jsonStr += '],"acquiredTotal":' + acqAtT2 + '},';

    jsonStr += ']}';
    System.debug(jsonStr);
    String jsontmp = jsonStr;

    String target = ',]';
    String replacement = ']';
    jsonstr = jsontmp.replace(target, replacement);
    System.debug(jsonstr);

    System.debug(jsonStr);

    System.debug('Total Acq at T2=' + acqAtT2);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTSThresholdJson, jsonStr=' + jsonStr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return jsonstr;
  }
}
