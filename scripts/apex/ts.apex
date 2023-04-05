Integer THRESHOLD1 = 1;
Integer THRESHOLD2 = 2;
Decimal valueAtThreshold1, valueAtThreshold2, totalSessionLength = 0;
Date d1 = Date.today();
Date d2 = Date.today();
String runId1, runId2;

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
  WHERE client__c = '0018t000002vfSfAAI'
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

  if (totalSessionLength >= THRESHOLD1 && !reachedThreshold1) {
    System.debug('reached ' + THRESHOLD1);
    reachedThreshold1 = true;
    valueAtThreshold1 = totalSessionLength;
    d1 = s.date__c;
    System.debug('date reached threshold1=' + d1);
    System.debug('valueAtThreshold1=' + valueAtThreshold1);
  }

  if (!reachedThreshold1)
    valueAtThreshold1 = totalSessionLength;

  if (totalSessionLength >= THRESHOLD2 && !reachedThreshold2) {
    System.debug('reached ' + THRESHOLD2);
    reachedThreshold2 = true;
    valueAtThreshold2 = totalSessionLength;
    d2 = s.date__c;
    System.debug('date reached threshold2=' + d2);
    System.debug('valueAtThreshold2=' + valueAtThreshold2);
  }

  if (!reachedThreshold2)
    valueAtThreshold2 = totalSessionLength;
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
  WHERE client__c = '0018t000002vfSfAAI' AND ts_load_datetime__c >= :d1
  GROUP BY client__c
];

if (lar1.size() == 0) {
  System.debug('Not in TS yet, using latest maxRunId');
  runId1 = maxRunId;
} else {
  runId1 = (String) lar1[0].get('expr0');
}

jsonStr +=
  '{"threshold":' +
  THRESHOLD1 +
  ',"reached":' +
  reachedThreshold1 +
  ',"valueAtThreshold":' +
  valueAtThreshold1 +
  ',"runId":"' +
  runId1 +
  '","dateAtThreshold":"' +
  d1 +
  '"';

System.debug(jsonStr);

List<AggregateResult> lar2 = [
  SELECT client__c, min(runid__c)
  FROM client_objective_timeseries__c
  WHERE client__c = '0018t000002vfSfAAI' AND ts_load_datetime__c >= :d2
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
  WHERE
    client__c = '0018t000002vfSfAAI'
    AND runid__c = :runId1
    AND status__c = 'ACQ'
  GROUP BY Objective__r.SD__r.Program__r.Name
]) {
  acqAtT1 += (Integer) ar.get('expr0');
  jsonStr += '{"progam":"' + ar.get('Name') + '",';
  jsonStr += '"acquired":' + ar.get('expr0') + '},';

  System.debug('Threshold1====>' + ar.get('Name') + ' ' + ar.get('expr0'));
}

jsonStr += '],"acquiredTotal":' + acqAtT1 + '},';
jsonStr +=
  '{"threshold":' +
  THRESHOLD2 +
  ',"reached":' +
  reachedThreshold2 +
  ',"valueAtThreshold":' +
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
  WHERE
    client__c = '0018t000002vfSfAAI'
    AND runid__c = :runId2
    AND status__c = 'ACQ'
  GROUP BY Objective__r.SD__r.Program__r.Name
]) {
  acqAtT2 += (Integer) ar.get('expr0');
  jsonStr += '{"progam":"' + ar.get('Name') + '",';
  jsonStr += '"acquired":' + ar.get('expr0') + '},';
  System.debug('Threshold2====>' + ar.get('Name') + ' ' + ar.get('expr0'));
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
