public class L4LTimeSeries {
  public Integer loadCOTimeSeries() {
    Logger.setScenario('L4LTimeSeries');
    Logger.debug('Apex:loadCOTimeSeries() - entering')
      .addTag('L4LTimeSeries.loadCOTimeSeries()')
      .addTag('TimeSeries');
    Logger.saveLog();

    TimeSeries_Log__c log = new TimeSeries_Log__c();
    log.comments__c = 'Started client objective timeseries run';
    insert log;
    system.debug('log inserted ' + log);

    String runId = [SELECT name FROM TimeSeries_Log__c WHERE id = :log.Id].Name;

    String clientObjectiveSOQLStr =
      'Select Id,Client__c,Client_Objective_Notes__c, Date_Absorbed__c,' +
      'Date_Acquired__c, Date_CIP__c, Date_Held__c, Date_Introduced__c,' +
      'Days_Since_Tested_Correct__c, Days_Since_Tested__c, Frequency__c,' +
      'Name, Objective__c, Program_Name__c,' +
      'Re_Test_Recommended__c, Status__c FROM Client_Objective__c ';

    List<Client_Objective__c> results = new List<Client_Objective__c>();
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
      tsrecord.status__c = co.status__c;
      tsrecord.Re_Test_Recommended__c = co.Re_Test_Recommended__c;
      tslist.add(tsrecord);
    }

    try {
      insert tslist;
      TimeSeries_Log__c endlog = new TimeSeries_Log__c();
      endlog.comments__c =
        'Successfully processed ' +
        tslist.size() +
        ' client objective timeseries records';
      insert endlog;
      Logger.debug(
          'Apex:loadCOTimeSeries() succesfully inserted ' +
          tslist.size() +
          'timeseries log records'
        )
        .addTag('L4LTimeSeries.loadCOTimeSeries()')
        .addTag('TimeSeries');
      Logger.saveLog();
    } catch (DmlException e) {
      Logger.error(
          'Apex:loadCOTimeSeries() an error was encountered inserting to timeseries log -  ' +
          e.getMessage()
        )
        .addTag('L4LTimeSeries.loadCOTimeSeries()')
        .addTag('TimeSeries');
      Logger.saveLog();
    }

    return tslist.size();
  }

  @AuraEnabled(cacheable=true)
  public static String generateD3COTimeSeriesJson(
    String clientId,
    String status
  ) {
    String queryCOTSString = 'SELECT calendar_Year(TS_Load_DateTime__c) year,calendar_Month(TS_Load_DateTime__c) month,day_in_Month(TS_Load_DateTime__c) day,count(id) val  FROM client_objective_timeseries__c ';

    queryCOTSString += ' where client__c=:clientId ';
    if (status == 'All') {
    } else if (status == 'Null') {
      queryCOTSString += ' and status__c = null ';
    } else {
      queryCOTSString += ' and status__c = :status ';
    }

    queryCOTSString += ' group by calendar_Year(TS_Load_DateTime__c),calendar_Month(TS_Load_DateTime__c),day_in_Month(TS_Load_DateTime__c) order by calendar_Year(TS_Load_DateTime__c),calendar_month(TS_Load_DateTime__c),day_in_month(TS_Load_DateTime__c)';
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

    return jsonstr;
  }

  @AuraEnabled(cacheable=true)
  public static String generateD3COTimeSeriesByStatusJson(String clientId) {
    String queryCOTSString = 'SELECT calendar_Year(TS_Load_DateTime__c) year,calendar_Month(TS_Load_DateTime__c) month,day_in_Month(TS_Load_DateTime__c) day, status__c, count(id) val  FROM client_objective_timeseries__c ';

    queryCOTSString += ' where client__c=:clientId ';

    queryCOTSString += ' group by calendar_Year(TS_Load_DateTime__c),calendar_Month(TS_Load_DateTime__c),day_in_Month(TS_Load_DateTime__c),status__c order by calendar_Year(TS_Load_DateTime__c),calendar_month(TS_Load_DateTime__c),day_in_month(TS_Load_DateTime__c),status__c';
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

    return jsonstr;
  }
}
