public with sharing class LFLDTDRates {
  @AuraEnabled(cacheable=true)
  public static String getAcquisitionRate(String clientId, Integer retro) {
    //get date and runid limits

    String jsonStr;
    Integer retro_start_months;

    if (retro == 0)
      retro_start_months = -999;
    else
      retro_start_months = -1 * retro;

    DateTime endpoint = Datetime.now().addMonths(retro_start_months);
    list<aggregateresult> limitDatesList = [
      SELECT min(createddate), max(createddate), min(runid__c), max(runid__c)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND createddate >= :endpoint
    ];

    jsonStr = buildJson(clientId, limitDatesList);
    return jsonStr;
  }

  /* get rates between starting and ending dates*/
  @AuraEnabled(cacheable=true)
  public static String getAcquisitionRateByDates(
    String clientId,
    DateTime dt1,
    DateTime dt2
  ) {
    //get date and runid limits

    String jsonStr;

    System.debug('received dt1=' + dt1 + ' dt2=' + dt2);
    if (dt2 <= dt1) {
      throw new L4LRateCalculationException(
        'end date must be after start date'
      );
    }

    list<aggregateresult> limitDatesList = [
      SELECT min(createddate), max(createddate), min(runid__c), max(runid__c)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND createddate > :dt1 AND createddate <= :dt2
    ];

    jsonStr = buildJson(clientId, limitDatesList);
    return jsonStr;
  }

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
      jsonStr += '}';
      return jsonStr;
    }

    DateTime startdt = (DateTime) limitDates.get('expr0');
    DateTime enddt = (DateTime) limitDates.get('expr1');
    String startRunId = (String) limitDates.get('expr2');
    String endRunId = (String) limitDates.get('expr3');

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

    // work out the number of acquired skills at the end
    list<aggregateresult> endingACQCountList = [
      SELECT count(id)
      FROM client_objective_timeseries__c
      WHERE client__c = :clientId AND status__c = 'ACQ' AND runid__c = :endRunId
    ];
    Integer endAcquiredCount = (Integer) endingACQCountList[0].get('expr0');

    // work out the elapsed days
    Integer elapsed = startd.daysBetween(endd);

    Decimal weeks = (Decimal) elapsed / 7;

    Integer numberAcquiredInPeriod = endAcquiredCount - startAcquiredCount;

    // calculate the weekly rate of acquisition
    Decimal rate;
    if (elapsed != 0) {
      rate = (decimal) (numberAcquiredInPeriod) / (weeks);
    } else
      rate = 0;

    // work out the number of sessions
    list<aggregateresult> sessionCountList = [
      SELECT count(id)
      FROM session__c
      WHERE client__c = :clientId AND Date__c > :startd AND date__c <= :endd
    ];

    Integer sessionCount = (Integer) sessionCountList[0].get('expr0');

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

    jsonStr += '}';

    return jsonStr;
  }
}
