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
System.debug('size = '+l.size());
SELECT count(id) archived FROM client_objective__c WHERE id = '0018t000003DbqmAAC' AND active__c != TRUE 



sfdx force:data:soql:query --query  "SELECT client__c, Objective__r.SD__r.Program__r.Name, status__c, count(id)
      FROM Client_Objective__c
      WHERE
        active__c = TRUE
        AND status__c IN ('ACQ', 'HLD', 'ABS', 'OBJ')
      GROUP BY client__c, Objective__r.SD__r.Program__r.Name, status__c"
    ;
    
//* identify duplicate client objectives */  
for (Account acc: [select Id,Name from account]) {
client_objective__c a = new client_objective__c();
List<client_objective__c> deleteList = new List<client_objective__c> ();

    List<client_objective__c> l = [select id,client__c,objective__c,objective_name__c from client_objective__c where client__c=:acc.Id order by objective__c];
    System.debug('l.size()='+l.size());
    for (client_objective__c co :l){


if (a.Id==null) {
a=co;
} else {
if (co.objective__c == a.objective__c) 
{
deleteList.add(co);
}
a=co;

}

}
System.debug('===>'+acc.Name+' ==DELETE ===>'+deleteList);
}
   
Id clientId='0018t000002vfSfAAI';
list<aggregateresult> limitDatesList = [select min(createddate),max(createddate),min(runid__c),max(runid__c) from client_objective_timeseries__c where client__c=:clientId];
AggregateResult limitDates = limitDatesList[0];
system.debug(limitDates);
DateTime startdt = (DateTime) limitDates.get('expr0');
DateTime enddt=(DateTime) limitDates.get('expr1');
String startRunId=(String)limitDates.get('expr2');
String endRunId=(String)limitDates.get('expr3');

//coerce to Dates for elapsed
Date startd=startdt.date();
Date endd=enddt.date();


list<aggregateresult> startingACQCountList = [select count(id) from client_objective_timeseries__c where client__c='0018t000003DbqmAAC' 
and status__c='ACQ' and runId__c=:startRunId];

Integer startAcquiredCount=(Integer) startingACQCountList[0].get('expr0');
System.debug('starting '+startAcquiredCount);


list<aggregateresult> endingACQCountList = [select count(id) from client_objective_timeseries__c where client__c='0018t000003DbqmAAC' 
and status__c='ACQ' and runid__c=:endRunId];
Integer endAcquiredCount=(Integer) endingACQCountList[0].get('expr0');

System.debug('ending '+endAcquiredCount );


Integer elapsed = startd.daysBetween(endd);
Integer weeks= elapsed/7;

System.debug('elapsed days ='+elapsed);

Decimal rate = (decimal) (endAcquiredCount-startAcquiredCount)/(elapsed/7);
System.debug('rate ==>'+rate.setScale(2));

System.debug(LFLDTDRates.getAcquisitionRate('0018t000002vfSfAAI',3));

for (integer i=0;i<=12;i++){

String s = LFLDTDRates.getAcquisitionRate('0018t000002vfSfAAI',i);
System.debug('i='+i+'s='+s);

}



SELECT count(id)
      FROM session__c
      WHERE client__c = '0018t000002vfSfAAI'
      and Date__c >= 2022-11-27 AND DATE__C <= 2023-03-06

String s;   
for (Account accs : [select id,Name from account]) {
s=LFLDTDRates.getAcquisitionRate(accs.Id);
System.debug(accs.name +'==>'+s);
}


DateTime sd = DateTime.newInstance(2022, 2, 11, 8, 6, 16);
DateTime thismoment = DateTime.now();
DateTime ed = DateTime.newInstance(2022, 4, 11, 8, 6, 16);
String s=LFLDTDRates.getAcquisitionRate('0018t000002vfSfAAI',sd,ed);
System.debug(s);

DateTime thismoment = DateTime.now();
for (Integer i=1; i< 6; i++){
Integer j=6-i;
Integer k=j-1;
System.debug('j='+j+ 'k='+k);
}



14:47:56.171 (316923182)|USER_DEBUG|[4]|DEBUG|TSB==>{"rate":0.80,"startd":"2023-01-29 00:00:00","endd":"2023-03-05 00:00:00","elapsed":35,"startAcquiredCount":0,"endAcquiredCount":4,"numberAcquiredInPeriod":4,"sessionCount":14}
14:47:56.171 (373582645)|USER_DEBUG|[4]|DEBUG|TDC==>{"rate":5.50,"startd":"2023-02-19 00:00:00","endd":"2023-03-05 00:00:00","elapsed":14,"startAcquiredCount":31,"endAcquiredCount":42,"numberAcquiredInPeriod":11,"sessionCount":0}
14:47:56.171 (473155169)|USER_DEBUG|[4]|DEBUG|WZH==>{"rate":0.25,"startd":"2023-02-05 00:00:00","endd":"2023-03-05 00:00:00","elapsed":28,"startAcquiredCount":0,"endAcquiredCount":1,"numberAcquiredInPeriod":1,"sessionCount":4}
14:47:56.171 (486160339)|USER_DEBUG|[4]|DEBUG|ZBA==>{"rate":0,"startd":"N/A","endd":"N/A","elapsed":0,"startAcquiredCount":0,"endAcquiredCount":0,"numberAcquiredInPeriod":0}
14:47:56.171 (533888581)|USER_DEBUG|[4]|DEBUG|YLO==>{"rate":56.00,"startd":"2023-02-26 00:00:00","endd":"2023-03-05 00:00:00","elapsed":7,"startAcquiredCount":9,"endAcquiredCount":65,"numberAcquiredInPeriod":56,"sessionCount":1}
14:47:56.171 (544682231)|USER_DEBUG|[4]|DEBUG|LKR==>{"rate":0,"startd":"N/A","endd":"N/A","elapsed":0,"startAcquiredCount":0,"endAcquiredCount":0,"numberAcquiredInPeriod":0}
14:47:56.171 (558381327)|USER_DEBUG|[4]|DEBUG|EYO==>{"rate":0,"startd":"N/A","endd":"N/A","elapsed":0,"startAcquiredCount":0,"endAcquiredCount":0,"numberAcquiredInPeriod":0}
14:47:56.171 (568029008)|USER_DEBUG|[4]|DEBUG|AKR==>{"rate":0,"startd":"N/A","endd":"N/A","elapsed":0,"startAcquiredCount":0,"endAcquiredCount":0,"numberAcquiredInPeriod":0}
14:47:56.171 (578058570)|USER_DEBUG|[4]|DEBUG|ASH==>{"rate":0,"startd":"N/A","endd":"N/A","elapsed":0,"startAcquiredCount":0,"endAcquiredCount":0,"numberAcquiredInPeriod":0}
14:47:56.171 (704213058)|USER_DEBUG|[4]|DEBUG|MNE==>{"rate":8.50,"startd":"2023-01-22 00:00:00","endd":"2023-03-05 00:00:00","elapsed":42,"startAcquiredCount":1,"endAcquiredCount":52,"numberAcquiredInPeriod":51,"sessionCount":1}
14:47:56.171 (769400251)|USER_DEBUG|[4]|DEBUG|Andy Peterson-TEST==>{"rate":0.71,"startd":"2022-11-27 00:00:00","endd":"2023-03-05 00:00:00","elapsed":98,"startAcquiredCount":0,"endAcquiredCount":10,"numberAcquiredInPeriod":10,"sessionCount":22}
14:47:56.171 (867095269)|USER_DEBUG|[4]|DEBUG|KYU==>{"rate":1.86,"startd":"2022-11-27 00:00:00","endd":"2023-03-05 00:00:00","elapsed":98,"startAcquiredCount":19,"endAcquiredCount":45,"numberAcquiredInPeriod":26,"sessionCount":19}
14:47:56.171 (919278576)|USER_DEBUG|[4]|DEBUG|Jan Janson _TEST==>{"rate":0.21,"startd":"2022-11-27 00:00:00","endd":"2023-03-05 00:00:00","elapsed":98,"startAcquiredCount":3,"endAcquiredCount":6,"numberAcquiredInPeriod":3,"sessionCount":7}
14:47:56.171 (970777408)|USER_DEBUG|[4]|DEBUG|EMB==>{"rate":2.00,"startd":"2022-11-27 00:00:00","endd":"2023-03-05 00:00:00","elapsed":98,"startAcquiredCount":0,"endAcquiredCount":28,"numberAcquiredInPeriod":28,"sessionCount":1}
14:47:56.171 (1038510451)|USER_DEBUG|[4]|DEBUG|LTR==>{"rate":0.58,"startd":"2022-12-11 00:00:00","endd":"2023-03-05 00:00:00","elapsed":84,"startAcquiredCount":0,"endAcquiredCount":7,"numberAcquiredInPeriod":7,"sessionCount":15}
14:47:56.171 (1085250880)|USER_DEBUG|[4]|DEBUG|Mike Test==>{"rate":0.07,"startd":"2022-11-27 00:00:00","endd":"2023-03-05 00:00:00","elapsed":98,"startAcquiredCount":0,"endAcquiredCount":1,"numberAcquiredInPeriod":1,"sessionCount":0}
14:47:57.184 (1184532852)|USER_DEBUG|[4]|DEBUG|CSM==>{"rate":0.43,"startd":"2022-11-27 00:00:00","endd":"2023-03-05 00:00:00","elapsed":98,"startAcquiredCount":25,"endAcquiredCount":31,"numberAcquiredInPeriod":6,"sessionCount":6}
14:47:57.184 (1279349554)|USER_DEBUG|[4]|DEBUG|NJA==>{"rate":2.33,"startd":"2023-02-12 00:00:00","endd":"2023-03-05 00:00:00","elapsed":21,"startAcquiredCount":84,"endAcquiredCount":91,"numberAcquiredInPeriod":7,"sessionCount":10}
14:47:57.184 (1339478443)|USER_DEBUG|[4]|DEBUG|CLO==>{"rate":2.71,"startd":"2023-01-15 00:00:00","endd":"2023-03-05 00:00:00","elapsed":49,"startAcquiredCount":39,"endAcquiredCount":58,"numberAcquiredInPeriod":19,"sessionCount":28}
14:47:57.184 (1381322577)|USER_DEBUG|[4]|DEBUG|ARC==>{"rate":0.17,"startd":"2023-01-22 00:00:00","endd":"2023-03-05 00:00:00","elapsed":42,"startAcquiredCount":0,"endAcquiredCount":1,"numberAcquiredInPeriod":1,"sessionCount":2}
14:47:57.184 (1452401452)|USER_DEBUG|[4]|DEBUG|LMU==>{"rate":32.00,"startd":"2023-02-12 00:00:00","endd":"2023-03-05 00:00:00","elapsed":21,"startAcquiredCount":0,"endAcquiredCount":96,"numberAcquiredInPeriod":96,"sessionCount":0}

