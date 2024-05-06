/**************************************************************
 * @name LFLDTDRates
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 * @see LFLDTDRateMaster
 * @description	The main skill acquisition Rate calcs
 *
 */

public with sharing class LFLDTDRates {
  /*******************************************************************************************************
   * @name getAcquisitionRate
   * @description Sets up a retrospective set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a
   * combined JSON string
   *
   *
   * @param clientId the clientId
   * @param retro
   * @return JSON string
   * @TODO is this deprecated?
   * @example
   * String jsonStr = LFLDTDRateMaster.getDTDRateArray(clientId, 4);
   */

  @AuraEnabled(cacheable=true)
  public static String getAcquisitionRate(String clientId, Integer retro) {
    //get date and runid limits

    String jsonStr;
    Integer retroStartMonths;

    if (retro == 0) {
      retroStartMonths = -999;
    } else {
      retroStartMonths = -1 * retro;
    }

    DateTime endpoint = Datetime.now().addMonths(retroStartMonths);
    list<aggregateresult> limitDatesList = [
      SELECT
        min(TS_load_DateTime__c),
        max(TS_load_DateTime__c),
        min(runid__c),
        max(runid__c)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND TS_load_DateTime__c >= :endpoint
    ];

    jsonStr = buildJson(clientId, limitDatesList);
    return jsonStr;
  }

  /*******************************************************************************************************
   * @name getAcquisitionRateByDates
   * @description Sets up a retrospecitve set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a
   * combined JSON string
   * Used by LWC lflDTDAcquisitionRate
   *
   *
   * @param clientId the clientId
   * @param dt1 the starting datetime
   * @param dt2 the ending datetime
   * @return JSON string
   * @example
   * String jsonStr = LFLDTDRates.getAcquisitionRateByDates(clientId,s,e);
   */

  /* get rates between starting and ending dates*/
  @AuraEnabled(cacheable=true)
  public static String getAcquisitionRateByDates(
    String clientId,
    DateTime dt1,
    DateTime dt2
  ) {
    final String SCENARIO = 'COTS TimeSeries - Acq Rate by Dates - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'LFLDTDRates.getAcquisitionRateByDates()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    //get date and runid limits

    String jsonStr;

    System.debug('received dt1=' + dt1 + ' dt2=' + dt2);
    if (dt2 <= dt1) {
      throw new L4LRateCalculationException(
        'end date must be after start date'
      );
    }

    list<aggregateresult> limitDatesList = [
      SELECT
        min(TS_load_DateTime__c),
        max(TS_load_DateTime__c),
        min(runid__c),
        max(runid__c)
      FROM client_objective_timeseries__c
      WHERE
        client__c = :clientId
        AND TS_load_DateTime__c > :dt1
        AND TS_load_DateTime__c <= :dt2
    ];

    jsonStr = buildJson(clientId, limitDatesList);
    return jsonStr;
  }

  /*******************************************************************************************************
   * @name buildJson
   * @description Helper to do the grunt work of building JSON
   *
   *
   * @param clientId the clientId
   * @param limitDatesList List<AggregateResult>
   * @return JSON string
   * @example
   * String jsonStr = LFLDTDRates.getAcquisitionRateByDates(clientId,s,e);
   */
  private static String buildJson(
    String clientId,
    list<aggregateresult> limitDatesList
  ) {
    String jsonStr;

    AggregateResult limitDates = limitDatesList[0];
    if (limitDates.get('expr0') == null) {
      jsonStr = '{';
      jsonStr += '"rate":' + 0;
      jsonStr += ',"startd":"2022-10-30"';
      jsonStr += ',"endd":"2022-10-30"';
      jsonStr += ',"elapsed":' + 0;
      jsonStr += ',"startAcquiredCount":' + 0;
      jsonStr += ',"endAcquiredCount":' + 0;
      jsonStr += ',"numberAcquiredInPeriod":' + 0;
      jsonStr += ',"sessionCount":' + 0;
      jsonStr += ',"weeks":' + 0;
      jsonStr += ',"acquiredPerSession":' + 0;
      jsonStr += ',"totalSessionDurationHrs":' + 0;
      jsonStr += '}';
      return jsonStr;
    }

    DateTime startdt = (DateTime) limitDates.get('expr0');
    DateTime enddt = (DateTime) limitDates.get('expr1');
    String startRunId = (String) limitDates.get('expr2');
    String endRunId = (String) limitDates.get('expr3');
    System.debug('startRunId=' + startRunId + ' , endRunId=' + endRunid);

    //coerce DateTimes to Dates for elapsed calcs
    Date startd = startdt.date();
    Date endd = enddt.date();

    // work out the number of acquired skills at the start
    list<aggregateresult> startingACQCountList = [
      SELECT count(id)
      FROM client_objective_timeseries__c
      WHERE
        client__c = :clientId
        AND status__c = 'ACQ'
        AND runId__c = :startRunId
    ];

    Integer startAcquiredCount = (Integer) startingACQCountList[0].get('expr0');

    //work out the number of acquired skills at the end
    list<aggregateresult> endingACQCountList = [
      SELECT count(id)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND status__c = 'ACQ' AND runid__c = :endRunId
    ];

    Integer endAcquiredCount = (Integer) endingACQCountList[0].get('expr0');

    System.debug(
      'startAcquiredCount = ' +
        startAcquiredCount +
        ' endAcquiredCount=' +
        endAcquiredCount
    );

    // work out the elapsed days
    Integer elapsed = startd.daysBetween(endd);

    Decimal weeks = (Decimal) elapsed / 7;

    Integer numberAcquiredInPeriod = endAcquiredCount - startAcquiredCount;

    // calculate the weekly rate of acquisition
    Decimal rate;
    if (elapsed != 0) {
      rate = (decimal) (numberAcquiredInPeriod) / (weeks);
    } else {
      rate = 0;
    }

    // work out the number of sessions
    list<aggregateresult> sessionCountList = [
      SELECT count(id), sum(session_length__c)
      FROM session__c
      WHERE client__c = :clientId AND Date__c > :startd AND date__c <= :endd
    ];

    Integer sessionCount = (Integer) sessionCountList[0].get('expr0');

    Decimal totalSessionDurationHrs = (Decimal) sessionCountList[0]
      .get('expr1');

    if (totalSessionDurationHrs == null) {
      totalSessionDurationHrs = 1.0;
    }

    Decimal acquiredPerSession;
    if (sessionCount != 0) {
      acquiredPerSession = (Decimal) numberAcquiredInPeriod / sessionCount;
    } else {
      acquiredPerSession = 0;
    }

    //create JSON return
    jsonStr = '{';
    jsonStr += '"rate":' + rate.setScale(2);
    jsonStr +=
      ',"startd":"' +
      startdt.year() +
      '-' +
      startdt.month() +
      '-' +
      startdt.day() +
      '"';
    jsonStr +=
      ',"endd":"' +
      enddt.year() +
      '-' +
      enddt.month() +
      '-' +
      enddt.day() +
      '"';
    jsonStr += ',"elapsed":' + elapsed;
    jsonStr += ',"startAcquiredCount":' + startAcquiredCount;
    jsonStr += ',"endAcquiredCount":' + endAcquiredCount;
    jsonStr += ',"numberAcquiredInPeriod":' + numberAcquiredInPeriod;
    jsonStr += ',"sessionCount":' + sessionCount;
    jsonStr += ',"weeks":' + weeks.setScale(2);
    jsonStr += ',"acquiredPerSession":' + acquiredPerSession.setScale(2);
    jsonStr +=
      ',"totalSessionDurationHrs":' + totalSessionDurationHrs.setScale(2);

    jsonStr += '}';

    return jsonStr;
  }

  /*******************************************************************************************************
   * @name getAcquisitionRateforClientTurbo
   * @description Turbo rate calculator -- hardly any SOQL
   *
   *
   * @param clientId the clientId
   *
   * @return JSON string
   * @example
   * String jsonStr = LFLDTDRates.getAcquisitionRateforClientTurbo(clientId);
   */
  @AuraEnabled(cacheable=true)
  public static String getAcquisitionRateforClientTurbo(String clientId) {
    String jsonStr;

    //a list of session dates and durations for this client
    list<Session__c> sessionList = [
      SELECT date__c, session_length__c
      FROM Session__c
      WHERE client__c = :clientId
      ORDER BY date__c
    ];

    // the minimum COTS run that included an ACQ for this client
    Map<string, date> rundatemap = new Map<string, date>();
    list<aggregateresult> runDatesList = [
      SELECT RunId__c, min(TS_load_DateTime__c)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId
      GROUP BY runid__c
      ORDER BY runid__c
    ];

    //leave now if there are no runs
    if (runDatesList.size() == 0) {
      jsonStr = '{"data":';
      jsonStr += '[{';
      jsonStr += '"rate":' + 0;
      jsonStr += ',"startd":"2022-10-30"';
      jsonStr += ',"endd":"2022-10-30"';
      jsonStr += ',"elapsed":' + 0;
      jsonStr += ',"startAcquiredCount":' + 0;
      jsonStr += ',"endAcquiredCount":' + 0;
      jsonStr += ',"numberAcquiredInPeriod":' + 0;
      jsonStr += ',"sessionCount":' + 0;
      jsonStr += ',"weeks":' + 0;
      jsonStr += ',"acquiredPerSession":' + 0;
      jsonStr += ',"totalSessionDurationHrs":' + 0;
      jsonStr += '}]';
      jsonStr += ',"duration":' + 0 + '}';
      return jsonStr;
    }

    // extract earliest run details
    String minRunId = (String) runDatesList[0].get('RunId__c');
    DateTime minRunDateTime = (DateTime) runDatesList[0].get('expr0');
    Date minRunDate = minRunDateTime.date();

    // work out the most recent previous run
    client_objective_timeseries__c priorcots = new Client_Objective_Timeseries__c();
    priorcots = [
      SELECT runid__c, ts_load_datetime__c
      FROM client_objective_timeseries__c
      WHERE runid__c < :minRunId
      ORDER BY runid__c DESC
      LIMIT 1
    ];

    // extract the details of the prior run
    String priorRunId;
    DateTime prior_ts_load_datetime;
    Date prior_ts_load_date;
    if (priorcots != null) {
      priorRunId = priorcots.runId__c;
      prior_ts_load_datetime = priorcots.ts_load_datetime__c;
      prior_ts_load_date = prior_ts_load_datetime.date();
      // add this single run as first entry in rundatemap (because sessions happened in the week prior to the the COTS runs)
      rundatemap.put(priorRunId, prior_ts_load_date);
    }

    // now add the COTS runs that containeed ACQ for this client
    for (AggregateResult res : runDatesList) {
      Datetime dt = (DateTime) res.get('expr0');
      String runid = (String) res.get('RunId__c');
      Date d = dt.date();
      rundatemap.put(runid, d);
    }

    //process the COTS to aggregate ACQ for this client
    list<aggregateresult> limitDatesList = [
      SELECT runid__c, status__c, count(id)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId
      GROUP BY runid__c, status__c
      HAVING status__c = 'ACQ'
      ORDER BY runid__c
    ];

    // exit if not found
    if (limitDatesList.size() == 0) {
      jsonStr = '{"data":';
      jsonStr += '[{';
      jsonStr += '"rate":' + 0;
      jsonStr += ',"startd":"2022-10-30"';
      jsonStr += ',"endd":"2022-10-30"';
      jsonStr += ',"elapsed":' + 0;
      jsonStr += ',"startAcquiredCount":' + 0;
      jsonStr += ',"endAcquiredCount":' + 0;
      jsonStr += ',"numberAcquiredInPeriod":' + 0;
      jsonStr += ',"sessionCount":' + 0;
      jsonStr += ',"weeks":' + 0;
      jsonStr += ',"acquiredPerSession":' + 0;
      jsonStr += ',"totalSessionDurationHrs":' + 0;
      jsonStr += '}]';
      jsonStr += ',"duration":' + 0 + '}';
      return jsonStr;
    }
    //get ready to make some JSON
    Integer startAcquiredCount;
    Integer endAcquiredCount;
    Date startdt;
    Date enddt;
    Decimal totalHours = 0;
    Decimal totalWeeks = 0;
    Integer totalSessions = 0;
    Date dayzero = minRunDate.addDays(7);

    jsonStr = '['; // opening bracket

    // before we build the real COTS based payload we need to build a single entry to seed the payload with the session info occurring before COTS run

    list<AggregateResult> priorSessionList = [
      SELECT client__c, sum(session_length__c), count(id)
      FROM Session__c
      WHERE client__c = :clientId AND date__c < :dayzero
      GROUP BY client__c
    ];

    for (AggregateResult priorsession : priorSessionList) {
      jsonStr += '{';
      jsonStr += '"rate":' + (Integer) limitDatesList[0].get('expr0');
      jsonStr +=
        ',"startd":"' +
        minRunDate.year() +
        '-' +
        minRunDate.month() +
        '-' +
        minRunDate.day() +
        '"';
      jsonStr +=
        ',"endd":"' +
        dayzero.year() +
        '-' +
        dayzero.month() +
        '-' +
        dayzero.day() +
        '"';
      jsonStr += ',"elapsed":' + 7;
      jsonStr += ',"startAcquiredCount":' + 0;
      jsonStr +=
        ',"endAcquiredCount":' + (Integer) limitDatesList[0].get('expr0');
      Integer numberAcquiredSeed = (Integer) limitDatesList[0].get('expr0');
      Integer sessionCountSeed = (Integer) priorsession.get('expr1');
      jsonStr += ',"numberAcquiredInPeriod":' + numberAcquiredSeed;
      jsonStr += ',"sessionCount":' + sessionCountSeed;
      jsonStr += ',"weeks":' + 1.0;

      Decimal acquiredPerSessionSeed =
        Decimal.valueOf(numberAcquiredSeed) / Decimal.valueOf(sessionCountSeed);

      jsonStr += ',"acquiredPerSession":' + acquiredPerSessionSeed.setScale(2);

      jsonStr +=
        ',"totalSessionDurationHrs":' + (Decimal) priorsession.get('expr0');
      jsonStr += '},';

      //bump the globals
      totalHours += (Decimal) priorsession.get('expr0');
      totalSessions += (Integer) priorsession.get('expr1');
      totalWeeks += 1;
    }

    // Now we have a seeded initial record the main game is to loop through the limitDatesList and sessionList to build JSON

    for (AggregateResult res : limitDatesList) {
      endAcquiredCount = (Integer) res.get('expr0');
      String runid = (String) res.get('RunId__c');
      Date rundate = (Date) rundatemap.get(runid);
      enddt = rundate;
      if (startAcquiredCount != null) {
        Integer numberAcquiredInPeriod = endAcquiredCount - startAcquiredCount;
        Integer elapsed = startdt.daysBetween(enddt);

        Decimal weeks = (Decimal) elapsed / 7;
        totalweeks += weeks;
        Decimal rate;
        if (elapsed != 0) {
          rate = (decimal) (numberAcquiredInPeriod) / (weeks);
        } else {
          rate = 0;
        }

        Integer sessionCount = 0;
        Decimal totalSessionDurationHrs = 0;

        for (Session__c s : sessionList) {
          if (s.Date__c > startdt && s.date__c <= enddt) {
            sessionCount += 1;
            totalSessions += 1;
            if (s.Session_Length__C != null) {
              totalSessionDurationHrs += s.Session_Length__c;
            }
            totalHours += totalSessionDurationHrs;
          }
        }
        Decimal acquiredPerSession;
        if (sessionCount != 0) {
          acquiredPerSession = (Decimal) numberAcquiredInPeriod / sessionCount;
        } else {
          acquiredPerSession = 0;
        }

        jsonStr += '{';
        jsonStr += '"rate":' + rate.setScale(2);
        jsonStr +=
          ',"startd":"' +
          startdt.year() +
          '-' +
          startdt.month() +
          '-' +
          startdt.day() +
          '"';
        jsonStr +=
          ',"endd":"' +
          enddt.year() +
          '-' +
          enddt.month() +
          '-' +
          enddt.day() +
          '"';
        jsonStr += ',"elapsed":' + elapsed;
        jsonStr += ',"startAcquiredCount":' + startAcquiredCount;
        jsonStr += ',"endAcquiredCount":' + endAcquiredCount;
        jsonStr += ',"numberAcquiredInPeriod":' + numberAcquiredInPeriod;
        jsonStr += ',"sessionCount":' + sessionCount;
        jsonStr += ',"weeks":' + weeks.setScale(2);
        jsonStr += ',"acquiredPerSession":' + acquiredPerSession.setScale(2);
        jsonStr +=
          ',"totalSessionDurationHrs":' + totalSessionDurationHrs.setScale(2);

        jsonStr += '},';
      }
      startAcquiredCount = endAcquiredCount;
      startdt = enddt;
    }

    jsonStr += ']';
    String target = ',]';
    String replacement = ']';
    jsonStr = jsonStr.replace(target, replacement);

    jsonStr = '{"data":' + jsonStr;
    jsonStr +=
      ',"duration":' +
      totalHours +
      ',"totalweeks":' +
      totalweeks +
      ',"totalsessions":' +
      totalSessions +
      '}';
    return jsonStr;
  }
}
