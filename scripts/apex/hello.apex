// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

L4LSessionStatsController.getD3SessionStatsHistogramData();

L4LTimeSeries x = new L4LTimeSeries();
System.debug(x.loadCOTimeSeries());

L4LTimeSeriesScheduler m = new L4LTimeSeriesScheduler();
String sch = '0 0 22 ? * 1';
String jobID = System.schedule('Time Series Schedule', sch, m);

List<Program__c> results = new List<Program__c>();
results = L4LSessionStatsController.getProgramsAndSDs('All');
System.debug('results.size()-' + results.size());

String json = '{"children":[';
json += '{"name": "flare",';
json += '"children": [';
System.debug(json);
Set<String> myset = new Set<string>();

Map<id, program__c> pmap = new Map<id, program__c>(
  [
    SELECT id, name
    FROM program__c
    WHERE id IN (SELECT program__c FROM sd__c WHERE area__c != NULL)
  ]
);
System.debug('pmap=' + pmap);

Map<id, Set<String>> areamap = new Map<id, Set<String>>();
List<AggregateResult> xarlist = [
  SELECT program__c, area__c, count(id)
  FROM sd__c
  WHERE area__c != NULL
  GROUP BY program__c, area__c
];
System.debug(xarlist);
for (aggregateResult a : xarlist) {
  id i = (id) a.get('program__c');
  string area = (string) a.get('area__c');

  if (areamap.get(i) == null) {
    Set<string> temp = new Set<string>();
    temp.add(area);
    areamap.put(i, temp);
  } else {
    Set<string> temp2 = areamap.get(i);
    temp2.add(area);
    areamap.put(i, temp2);
  }

  ///areamap.put(i,s);
}

System.debug('areamaP=' + areamap);

Set<id> idlist = pmap.keySet();
for (Id i : idlist) {
  //for (Program__c p: [select id,name from program__c limit 3])

  Program__c p = pmap.get(i);
  json += '{"name":"' + p.name + '",';
  json += '"children":[';

  Set<string> tempset = areamap.get(p.Id);

  for (String ss : tempset) {
    json += '{"name":"' + (String) ss + '",';
    json += '"children":[';
    for (sd__c sd : [
      SELECT name
      FROM sd__c
      WHERE program__c = :p.Id AND area__c = :ss
      LIMIT 10
    ]) {
      json += '{"name":"' + sd.name + '","value":"20"},';
    }

    json += ']},';
  }
  json += ']},';
}
json += ']}';
json += ']}';

String target = ',]';
String replacement = ']';
String json2 = json.replace(target, replacement);
System.debug(json2);

//

String j = L4LSessionStatsController.generateD3ProgramAreaSDJson(
  '0018t000002vfSfAAI',
  'All'
);
System.debug(j);

String j = L4LSessionStatsController.generateD3AreaSDJson(
  '0018t000002vfSfAAI',
  'Stage One'
);
System.debug(j);

LFLUtil.parse('{"name":"xxx"}');

String queryAreaString = 'SELECT name, objective_count__c,area__c, program__r.name FROM sd__c where area__c != NULL  limit 10';

List<sd__c> sdAllAreaList = Database.query(queryAreaString);
System.debug('------sdallarealiat=' + sdAllAreaList);

List<LFLSDWrapper> wrapper = new List<LFLSDWrapper>();

for (sd__c s : sdAllAreaList) {
  LFLSDWrapper w = new LFLSDWrapper(s);
  wrapper.add(w);
}

System.debug('-----' + wrapper);
wrapper.sort();
System.debug('----sort--' + wrapper);

sd__c s = new sd__C(name = 'sss');

L4LSessionStatsController.getD3SessionStatsHistogramData('0018t000002vfSfAAI');

L4LTimeSeries ts = new L4LTimeSeries();
ts.loadCOTimeSeries();

L4LTimeSeries.generateD3COTimeSeriesJson('0018t000002vfSfAAI', 'Null');

Integer i = L4LSessionStatsController.getD3StatusYAxisScale(
  '0018t000003DbqmAAC'
);
System.debug(i);

throw new L4LClientObjectiveMissingException('hello');

//update co to active
list<client_objective__c> colist = new List<client_objective__c>();

for (client_objective__c co : [
  SELECT id
  FROM client_objective__c
  WHERE active__c = NULL OR active__c = FALSE
]) {
  co.active__c = true;
  colist.add(co);
}
System.debug(colist.size());
//update colist;

//update cots to active
list<client_objective_timeseries__c> cotslist = new List<client_objective_timeseries__c>();
for (client_objective_timeseries__c ts : [
  SELECT id
  FROM client_objective_timeseries__c
  WHERE active__c = NULL OR active__c = FALSE
]) {
  ts.active__c = true;
  cotslist.add(ts);
}
System.debug(cotslist.size());
//update cotslist;
String x = L4LController.getCOArchiveSummary('0018t000003DbqmAAC');
System.debug(x);

List<Client_Objective__c> l = L4LController.getClientObjectivesFilteredOnActive('0018t000003DbqmAAC',true);
Syastem.debug('size = '+l.size());
SELECT count(id) archived FROM client_objective__c WHERE id = '0018t000003DbqmAAC' AND active__c != TRUE 
