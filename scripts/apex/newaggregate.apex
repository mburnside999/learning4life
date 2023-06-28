list<Session__c> sessionList = [
  SELECT date__c
  FROM Session__c
  WHERE client__c = '0018t000003RdEjAAK'
  ORDER BY date__c
];
System.debug('xxxxxx' + sessionList);

Map<string, date> rundatemap = new Map<string, date>();
list<aggregateresult> runDatesList = [
  SELECT RunId__c, min(TS_load_DateTime__c)
  FROM client_objective_timeseries__c
  WHERE client__c = '0018t000003RdEjAAK'
  GROUP BY runid__c
  ORDER BY runid__c
];
System.debug(runDatesList);
for (AggregateResult res : runDatesList) {
  Datetime dt = (DateTime) res.get('expr0');
  String runid = (String) res.get('RunId__c');
  Date d = dt.date();
  rundatemap.put(runid, d);
}

System.debug(rundatemap);

list<aggregateresult> limitDatesList = [
  SELECT runid__c, status__c, count(id)
  FROM client_objective_timeseries__c
  WHERE client__c = '0018t000003RdEjAAK'
  GROUP BY runid__c, status__c
  HAVING status__c = 'ACQ'
  ORDER BY runid__c
];
Integer prevval;
Integer thisval;
Date startdt;
Date enddt;

for (AggregateResult res : limitDatesList) {
  thisval = (Integer) res.get('expr0');
  Integer i = (Integer) res.get('expr0');
  String runid = (String) res.get('RunId__c');
  Date rundate = (Date) rundatemap.get(runid);
  enddt = rundate;
  if (prevval != null) {
    Integer numberAcquiredInPeriod = thisval - prevval;
    Integer elapsed = startdt.daysBetween(enddt);

    Decimal weeks = (Decimal) elapsed / 7;
    Decimal rate;
    if (elapsed != 0) {
      rate = (decimal) (numberAcquiredInPeriod) / (weeks);
    } else
      rate = 0;

    System.debug(
      'startcount=' +
      prevval +
      ' endcount=' +
      thisval +
      ' startdt=' +
      startdt +
      ' enddt=' +
      enddt +
      ' elapsed=' +
      elapsed +
      ' weeks=' +
      weeks +
      ' numberAcquiredInPeriod=' +
      numberAcquiredInPeriod +
      ' rate=' +
      rate
    );
    Integer sesscount = 0;
    for (Session__c s : sessionList) {
      if (s.Date__c > startdt && s.date__c <= enddt) {
        sesscount += 1;
      }
    }
    System.debug('sessioncount=' + sesscount);
  }
  prevval = thisval;
  startdt = enddt;
}
