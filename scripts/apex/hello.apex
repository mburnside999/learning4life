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
String s;
for (Integer i=0; i< 6; i++){
DateTime thismoment = DateTime.now();
Integer j=6-i;
Integer k=j-1;
DateTime s = thismoment.addMonths(j *-1);
DateTime e = thismoment.addMonths(k *-1);
String str=LFLDTDRates.getAcquisitionRateByDates('0018t000002vfSfAAI',s,e);
//System.debug('j= '+j+' k= '+k + 's= '+s +'e='+e);
//System.debug('j='+j);
//System.debug('k='+k);
System.debug(str);
}

DateTime thismoment = DateTime.now();
DateTime s = thismoment.addmonths(j*-1);
DateTime e = thismoment.addmonths(k*-1);
String str=LFLDTDRates.getAcquisitionRateByDates('0018t000002vfSfAAI',s,e);

sfdx force:source:deploy -m "AuraDefinitionBundle,ApexClass,ApexTrigger,Flow,LightningMessageChannel" -u LFLHyperPARTIAL -l RunSpecifiedTests -r TestL4LController,TestL4LSessionStatsController,TestL4LSDStageMap,TestLFLUtil,TestLFLSDWrapper,TestL4LTimeSeries,TestL4LTimeSeriesScheduler,TestLFLClientObjectiveHelper,TestLFLInvocableMasteryStatistics,TestLFLInvocableReportWizard,TestLFLInvocableSessionStatistics,TestLFLPopulateTestData,TestLFLProgramStatusCascadeUtil,TestCascadeProgramStatusTrg,TestCascadeSDStatusTrg,TestDaysSinceUpdatedTrg,TestLFLSessionStatsTrg,TestClientObjectiveList,TestL4LNebulaComponentController,TestL4LExceptionClientObjectiveMissing

sfdx force:source:deploy -m "ApexClass:L4LDTDRateMaster, ApexClass:TestL4LDTDRateMaster" -u LFLHyperPARTIAL -l RunSpecifiedTests -r TestL4LDTDRateMaster
LFLDTDRateMaster.getDTDRateArray('0018t000002vfSfAAI',3);
