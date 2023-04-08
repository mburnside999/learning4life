public class L4LTimeSeries {
  public Integer loadCOTimeSeries() {
    System.debug('in loadCOTimeSeries()');

    System.debug('in loadCOTimeSeries(): logging START to TimeSeries_Log__c()');

    TimeSeries_Log__c log = new TimeSeries_Log__c();
    log.comments__c = 'Started client objective timeseries run';
    insert log;

    System.debug(
      'in loadCOTimeSeries(): successfully logged START to TimeSeries_Log__c(): ' +
      log
    );

    String runId = [SELECT name FROM TimeSeries_Log__c WHERE id = :log.Id].Name;

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
        'loadCOTimeSeries(): logging END to TimeSeries_Log__c(): ' + log
      );

      TimeSeries_Log__c endlog = new TimeSeries_Log__c();
      endlog.comments__c =
        'Successfully processed ' +
        tslist.size() +
        ' client objective timeseries records';
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

  @AuraEnabled(cacheable=true)
  public static String generateD3COTimeSeriesJson(
    String clientId,
    String status
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesJson',
      'L4LTimeSeries.generateD3COTimeSeriesJson',
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
      'L4LTimeSeries.generateD3COTimeSeriesJson, queryCOTSString=' +
      queryCOTSString,
      'next-gen-nebula-apex'
    );

    List<AggregateResult> COTSList = Database.query(queryCOTSString);

    System.debug('queryCOTSString=' + queryCOTSString);

    //generate  the JSON
    String jsontmp = '[';

    for (AggregateResult agg : COTSList) {
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

    // //trim the extraneous characters
    // String target = ',]';
    // String replacement = ']';
    // String jsonstr = jsontmp.replace(target, replacement);

    // System.debug('Final json=' + jsonstr);
    // Logger.debug('Apex:generateD3ProgramAreaSDJson jsonstr=' + jsonstr)
    //   .addTag('L4LSessionStatsController.generateD3ProgramAreaSDJson()')
    //   .addTag('logit()');
    // Logger.saveLog();

    // Boolean isValidJSON = false;
    // String message = jsonstr;
    // try {
    //   Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(
    //     message
    //   );
    //   isValidJSON = true;
    // } catch (JSONException e) {
    //   System.debug(e.getMessage());
    // }
    // System.debug('isValidJSON=' + isValidJSON);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesJson, returning jsonstr=' + jsonstr,
      'L4LTimeSeries.generateD3COTimeSeriesJson, returning jsonstr=' + jsonstr,
      'next-gen-nebula-apex'
    );

    return jsonstr;
  }

  @AuraEnabled(cacheable=true)
  public static String generateD3COTSJsonByProgramAndSD(
    String clientId,
    String program,
    String sd,
    String status,
    String periodStr
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTSJsonByProgramAndSD',
      'L4LTimeSeries.generateD3COTSJsonByProgramAndSD',
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

    if (status == 'Both') {
      queryCOTSString += ' and status__c in (\'ACQ\',\'CIP\') ';
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
      'L4LTimeSeries.generateD3COTSJsonByProgramAndSD, queryCOTSString=' +
      queryCOTSString,
      'next-gen-nebula-apex'
    );

    List<AggregateResult> COTSList = Database.query(queryCOTSString);

    System.debug('queryCOTSString=' + queryCOTSString);

    //generate  the JSON
    String jsontmp = '[';

    for (AggregateResult agg : COTSList) {
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

    // //trim the extraneous characters
    // String target = ',]';
    // String replacement = ']';
    // String jsonstr = jsontmp.replace(target, replacement);

    // System.debug('Final json=' + jsonstr);
    // Logger.debug('Apex:generateD3ProgramAreaSDJson jsonstr=' + jsonstr)
    //   .addTag('L4LSessionStatsController.generateD3ProgramAreaSDJson()')
    //   .addTag('logit()');
    // Logger.saveLog();

    // Boolean isValidJSON = false;
    // String message = jsonstr;
    // try {
    //   Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(
    //     message
    //   );
    //   isValidJSON = true;
    // } catch (JSONException e) {
    //   System.debug(e.getMessage());
    // }
    // System.debug('isValidJSON=' + isValidJSON);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesJson, returning jsonstr=' + jsonstr,
      'L4LTimeSeries.generateD3COTimeSeriesJson, returning jsonstr=' + jsonstr,
      'next-gen-nebula-apex'
    );

    return jsonstr;
  }

  @AuraEnabled(cacheable=true)
  public static String generateD3COTimeSeriesByStatusJson(String clientId) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson',
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson',
      'next-gen-nebula-apex'
    );

    String queryCOTSString = 'SELECT calendar_Year(TS_Load_DateTime__c) year,calendar_Month(TS_Load_DateTime__c) month,day_in_Month(TS_Load_DateTime__c) day, status__c, count(id) val  FROM client_objective_timeseries__c ';
    queryCOTSString += ' where active__c=true and client__c=:clientId and status__c in (\'ACQ\',\'CIP\')';
    queryCOTSString += ' group by calendar_Year(TS_Load_DateTime__c),calendar_Month(TS_Load_DateTime__c),day_in_Month(TS_Load_DateTime__c),status__c order by calendar_Year(TS_Load_DateTime__c),calendar_month(TS_Load_DateTime__c),day_in_month(TS_Load_DateTime__c),status__c';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson, queryCOTSString=' +
      queryCOTSString,
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson, queryCOTSString=' +
      queryCOTSString,
      'next-gen-nebula-apex'
    );

    List<AggregateResult> COTSList = Database.query(queryCOTSString);
    System.debug('queryCOTSString=' + queryCOTSString);

    //generate  the JSON
    String jsontmp = '[';

    for (AggregateResult agg : COTSList) {
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

    // //trim the extraneous characters
    // String target = ',]';
    // String replacement = ']';
    // String jsonstr = jsontmp.replace(target, replacement);

    // System.debug('Final json=' + jsonstr);
    // Logger.debug('Apex:generateD3ProgramAreaSDJson jsonstr=' + jsonstr)
    //   .addTag('L4LSessionStatsController.generateD3ProgramAreaSDJson()')
    //   .addTag('logit()');
    // Logger.saveLog();

    // Boolean isValidJSON = false;
    // String message = jsonstr;
    // try {
    //   Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(
    //     message
    //   );
    //   isValidJSON = true;
    // } catch (JSONException e) {
    //   System.debug(e.getMessage());
    // }
    // System.debug('isValidJSON=' + isValidJSON);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson, returning jsonstr=' +
      jsonstr,
      'L4LTimeSeries.generateD3COTimeSeriesByStatusJson, returning jsonstr=' +
      jsonstr,
      'next-gen-nebula-apex'
    );
    return jsonstr;
  }

  @AuraEnabled(cacheable=true)
  public static String generateD3CORetestTimeSeriesJson(
    String clientId,
    String status
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3CORetestTimeSeriesJson',
      'L4LTimeSeries.generateD3CORetestTimeSeriesJson',
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
      'L4LTimeSeries.generateD3CORetestTimeSeriesJson, queryCOTSString=' +
      queryCOTSString,
      'next-gen-nebula-apex'
    );

    List<AggregateResult> COTSList = Database.query(queryCOTSString);

    System.debug('queryCOTSString=' + queryCOTSString);

    //generate  the JSON
    String jsontmp = '[';

    for (AggregateResult agg : COTSList) {
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

    // //trim the extraneous characters
    // String target = ',]';
    // String replacement = ']';
    // String jsonstr = jsontmp.replace(target, replacement);

    // System.debug('Final json=' + jsonstr);
    // Logger.debug('Apex:generateD3ProgramAreaSDJson jsonstr=' + jsonstr)
    //   .addTag('L4LSessionStatsController.generateD3ProgramAreaSDJson()')
    //   .addTag('logit()');
    // Logger.saveLog();

    // Boolean isValidJSON = false;
    // String message = jsonstr;
    // try {
    //   Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(
    //     message
    //   );
    //   isValidJSON = true;
    // } catch (JSONException e) {
    //   System.debug(e.getMessage());
    // }
    // System.debug('isValidJSON=' + isValidJSON);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LTimeSeries.generateD3CORetestTimeSeriesJson, returning jsonstr=' +
      jsonstr,
      'L4LTimeSeries.generateD3CORetestTimeSeriesJson, returning jsonstr=' +
      jsonstr,
      'next-gen-nebula-apex'
    );
    return jsonstr;
  }

  @AuraEnabled(cacheable=true)
  public static String generateD3COTSThresholdJson(
    String clientId,
    Integer threshold1,
    Integer threshold2
  ) {
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
    return jsonstr;
  }
}
