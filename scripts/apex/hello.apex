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
LFLDTDRateMaster.getDTDRateArray('0018t000002vfSfAAI',99);



select count(id) from session_obj__C 
select count(id) from session_obj__C where  NOT(session__r.client__r.name  like '%Test%')
select session__r.client__r.name,count(Id) from session_obj__c group by session__r.client__r.name
select client__r.name,active__c,count(id) from client_objective__c group by client__r.name,active__c


String s = '[{"Id":"a088t000000Dt7LAAS","Name":"Bath","Program__c":"Receptive Labels","SD_Name__c":"3D Receptive","SD__c":"a0A8t0000003HsLEAU"},{"Id":"a088t000000Dt7MAAS","Name":"Bed","Program__c":"Receptive Labels","SD_Name__c":"3D Receptive","SD__c":"a0A8t0000003HsLEAU"},{"Id":"a088t000000Dt7NAAS","Name":"Bike","Program__c":"Receptive Labels","SD_Name__c":"3D Receptive","SD__c":"a0A8t0000003HsLEAU"},{"Id":"a088t000000Dt7OAAS","Name":"Block","Program__c":"Receptive Labels","SD_Name__c":"3D Receptive","SD__c":"a0A8t0000003HsLEAU"},{"Id":"a088t000000Dt7PAAS","Name":"Bowl","Program__c":"Receptive Labels","SD_Name__c":"3D Receptive","SD__c":"a0A8t0000003HsLEAU"}]';
Integer i = L4LController.createClientObjectivesByArray(s,'0018t000002vfSfAAI');
System.debug('======'+i);

sfdx force:source:deploy -m "ApexClass:L4LInvocableListUnusedObj,ApexClass:TestLFLInvocableListUnusedObj,ApexClass:L4LSDStageMap,ApexClass:TestL4LSDStageMap,ApexClass:ClientObjectiveList,ApexClass:TestClientObjectiveList" -u LFLHyperPARTIAL -l RunSpecifiedTests -r TestL4LSDStageMap,TestLFLInvocableListUnusedObj,TestC;lientObjectiveList

SELECT SELECT DurableId, QualifiedApiName, Label, DataType, ValueTypeId, PublisherId, Length, Precision, Scale, EntityDefinitionId, RelationshipName
    FROM FieldDefinition
    ORDER BY Label ASC NULLS FIRST


SELECT
        min(TS_load_DateTime__c),
        max(TS_load_DateTime__c)
      FROM client_objective_timeseries__c
      WHERE
        client__c = '0018t000002vfSfAAI'
        AND TS_load_DateTime__c > 2023-02-20T00:00:00Z
        AND TS_load_DateTime__c <= 2023-03-06T00:00:00Z

      SELECT RunID__c
      FROM client_objective_timeseries__c
      WHERE TS_load_DateTime__c <= 2023-02-26T11:00:00.000+0000 limit 1
        



sfdx force:data:soql:query --query "SELECT SELECT DurableId, QualifiedApiName, Label, DataType, ValueTypeId, PublisherId, Length, Precision, Scale, EntityDefinitionId, RelationshipName"  --usetoolingapi



DateTime starting = [select date__c from session__c where client__c='0018t000003DbqmAAC' limit 1].date__C;
System.debug(starting);

 //DateTime thismoment = DateTime.now();
    for (Integer i = 0; i < 1000; i++) {
      DateTime e = starting.addDays(1 * 7 * i);
      DateTime s = starting.addDays(1 * ((7 * i) + 14));
      if (e>DateTime.now()) return;
      //   dtdRateArray.add(
      //     LFLDTDRates.getAcquisitionRateByDates('0018t000002vfSfAAI', s, e)
      //   );
      System.debug(e);
      
    }

    st<aggregateresult> acqCountList = [
      SELECT runid__c, count(id) acqcount
      FROM client_objective_timeseries__c
      WHERE
        client__c = '0018t000002vfSfAAI'
        AND status__c = 'xxx'
        AND runid__c IN ('TSL-2023-01-000014')
      GROUP BY runid__c
      ORDER BY runid__c

Integer THRESHOLD1=1;
Integer THRESHOLD2=2;
Decimal valueAtThreshold1,valueAtThreshold2,totalSessionLength=0;
Date d1=Date.today();
Date d2=Date.today();
String runId1,runId2;

Boolean reachedThreshold1=false;
Boolean reachedThreshold2=false;
String jsonStr='{"reserved1":1,"reserved2":2';
for (Session__c s:[select date__c,session_length__C from session__c where client__c='0018t000002vfSfAAI' order by date__c] ){     
        totalSessionLength+=s.session_length__c;
        System.debug('date='+s.date__c+' length='+s.session_length__c+' ,totalSessionLength='+totalSessionLength); 
         
         if (totalSessionLength>=THRESHOLD1 && !reachedThreshold1) {
         System.debug('reached '+THRESHOLD1);
         reachedThreshold1=true;
         valueAtThreshold1=totalSessionLength;
         d1=s.date__c;
         System.debug('date reached threshold1='+d1);
         System.debug('valueAtThreshold1='+valueAtThreshold1);
         }

if (!reachedThreshold1) valueAtThreshold1=totalSessionLength;

          if (totalSessionLength>=THRESHOLD2 && !reachedThreshold2) {
         System.debug('reached '+THRESHOLD2);
         reachedThreshold2=true;
         valueAtThreshold2=totalSessionLength;
         d2=s.date__c;
         System.debug('date reached threshold2='+d2);
        System.debug('valueAtThreshold2='+valueAtThreshold2);

         }

if (!reachedThreshold2) valueAtThreshold2=totalSessionLength;

         

}
System.debug('d1'+d1+' '+'d2'+d2);
System.debug('reachedThreshold1'+reachedThreshold1+' '+'reachedThreshold2'+reachedThreshold2);
System.debug('valueAtThreshold1'+valueAtThreshold1+' '+'valueAtThreshold2'+valueAtThreshold2);
    
            jsonStr+=',"sessiondata":[';
          List<AggregateResult> lar1= [select client__c,max(runid__c) from client_objective_timeseries__c where client__c='0018t000002vfSfAAI' and ts_load_datetime__c < :d1 group by client__c ];
          runId1 = (String) lar1[0].get('expr0');
          
jsonStr+='{"threshold":'+THRESHOLD1+',"reached":'+reachedThreshold1+',"valueAtThreshold":'+valueAtThreshold1+',"runId":"'+runId1+'","dateAtThreshold":"'+d1+'"';

          
          System.debug(jsonStr);

 List<AggregateResult> lar2= [select client__c,max(runid__c) from client_objective_timeseries__c where client__c='0018t000002vfSfAAI' and ts_load_datetime__c < :d2 group by client__c ];
          runId2 = (String) lar2[0].get('expr0');

     System.debug('totalSessionLength='+totalSessionLength);
         

          

Integer acqAtT1=0;
jsonStr+=',"data":[';
      for (AggregateResult ar: [select Objective__r.SD__r.Program__r.Name,count(id) from client_objective_timeseries__c where client__c='0018t000002vfSfAAI' and runid__c=
      :runId1 and status__c='ACQ' group by Objective__r.SD__r.Program__r.Name ]) {
      
      acqAtT1+=(Integer)ar.get('expr0');
jsonStr+='{"progam":"'+ar.get('Name')+'",';
jsonStr+='"acquired":'+ar.get('expr0')+'},';

      System.debug('Threshold1====>'+ar.get('Name')+' '+ar.get('expr0'));

      }

     jsonStr+='],"acquiredTotal":'+ acqAtT1+'},' ;
      jsonStr+='{"threshold":'+THRESHOLD2+',"reached":'+reachedThreshold2+',"valueAtThreshold":'+valueAtThreshold2+',"runId":"'+runId2+'","dateAtThreshold":"'+d2+'"';






      System.debug('Total Acq at T1='+acqAtT1);
Integer acqAtT2=0;
jsonStr+=',"data":[';

          for (AggregateResult ar: [select Objective__r.SD__r.Program__r.Name,count(id) from client_objective_timeseries__c where client__c='0018t000002vfSfAAI' and runid__c=
      :runId2 and status__c='ACQ' group by Objective__r.SD__r.Program__r.Name ]) {
           acqAtT2+=(Integer)ar.get('expr0');
jsonStr+='{"progam":"'+ar.get('Name')+'",';
jsonStr+='"acquired":'+ar.get('expr0')+'},';
      System.debug('Threshold2====>'+ar.get('Name')+' '+ar.get('expr0'));

      }
                 jsonStr+='],"acquiredTotal":'+ acqAtT2+'},' ;



            jsonStr+=']}';
      System.debug(jsonStr);
      String jsontmp=jsonStr;

String target = ',]';
        String replacement = ']';
        jsonstr = jsontmp.replace(target, replacement);
         System.debug(jsonstr);

            System.debug(jsonStr);

            System.debug('Total Acq at T2='+acqAtT2);





          

     

     String s = L4LTimeSeries.generateD3COTSThresholdJson('0018t000002vfSfAAI', 100, 200);
     System.debug(s);



     String str = L4LTimeSeries.generateD3COTSJsonByProgramAndSD(
      '0018t000002vfSfAAI',
      'All',
      'All',
      'All',
      '2'
    );
    System.debug(str);



    String aggStr = L4LController.getCOActivationSummary('0018t000002vfSfAAI');
    System.debug(aggStr);

String jsonstr  = L4LTimeSeries.generateD3COTimeSeriesJson('0018t000002vfSfAAI', 'All');
System.debug(jsonstr);

String jsonstr  = L4LTimeSeries.generateD3COTSJsonByProgramAndSD('0018t000002vfSfAAI', 'All','All','Both','60');
System.debug(jsonstr);

String jsonstr  = L4LTimeSeries.generateD3COTimeSeriesByStatusJson('0018t000002vfSfAAI');

String jsonstr  = L4LTimeSeries.generateD3CORetestTimeSeriesJson('0018t000002vfSfAAI','ACQ');
System.debug(jsonStr);

String jsonstr  = L4LTimeSeries.generateD3COTSThresholdJson('0018t000002vfSfAAI',10,20);
System.debug(jsonStr);

String s = L4LController.updateSessionObjectiveWithLG('a058t000000IUErAAO');
System.debug(s);

select id,objective__c,lastmodifieddate from client_objective__c where id ='a058t000000IUErAAO'

0018t000002vfSfAAI

String l = L4LStagesByArea.getSDUsage('0018t000002vfSfAAI');
System.debug('=====>'+l);