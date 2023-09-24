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



LFLDTDRateMaster.getDTDRateArray('0018t000003RdEjAAK',26);

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



LFLDTDRateMaster.getDTDRateArray('0018t000003RdEjAAK',24);


Map<string,date> rundatemap = new Map<string,date>();
list<aggregateresult> runDatesList=[select RunId__c,min(TS_load_DateTime__c) from client_objective_timeseries__c where client__c = 
        '0018t000003RdEjAAK' group by runid__c];
System.debug(runDatesList);
for (AggregateResult res: runDatesList){
  Datetime dt = (DateTime)res.get('expr0');
  String runid=(String)res.get('RunId__c');
  Date d = dt.date();
  rundatemap.put(runid,d);
 
}

System.debug(rundatemap);



list<aggregateresult> limitDatesList=[ SELECT runid__c,status__c,count(id)
      FROM client_objective_timeseries__c
      WHERE
        client__c = 
        '0018t000003RdEjAAK'
        group by runid__c,status__c
        having status__c='ACQ'
    ];

for (AggregateResult res: limitDatesList){
Integer i = (Integer) res.get('expr0');
String runid=(String) res.get('RunId__c');

Date rundate=(Date)rundatemap.get(runid);
System.debug('runid='+runid+' rundate='+rundate+' acqcount='+i);
}



    list<aggregateresult> runDatesList = [
      SELECT RunId__c, min(TS_load_DateTime__c)
      FROM client_objective_timeseries__c
      WHERE client__c = '0019n00000BPIjRAAX'
      GROUP BY runid__c
      ORDER BY runid__c
    ];
    String jsonStr;
    System.debug('rundateslist='+runDatesList);
    if (runDatesList.size()==0) {
      jsonStr = '[{';
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
      System.debug(jsonStr);
    }

 list<aggregateresult> limitDatesList = [
      SELECT runid__c, status__c, count(id)
      FROM client_objective_timeseries__c
      WHERE client__c = '0019n00000BPIjRAAX'
      GROUP BY runid__c, status__c
      HAVING status__c = 'ACQ'
      ORDER BY runid__c
    ];

    System.debug('++++'+limitDatesList);


String s = LFLDTDRates.getAcquisitionRateforClientTurbo('0018t000003RdEjAAK');
System.debug('============'+s+'================');


String s = LFLDTDRates.getAcquisitionRateforClientTurbo('0018t000003RdEjAAK');
System.debug('============'+s+'================');




String t=LFLDTDRateMaster.getDTDRateArray('0018t000003RdEjAAK',20);
system.debug('+++++++++++'+t+'++++++++++++++');


SELECT session__r.name,  
session__r.client__r.name, program_name__c, objective__r.name ,
session__r.Date__c ,SD_Name__c FROM Session_Statistics__c 
WHERE session__r.client__c = '0018t000003RdGPAA0' AND 
session__r.Date__c = 'All' ORDER BY program_name__c






    DateTime endtime = DateTime.now();
    DateTime starttime = endtime.addDays(-700);

    List<L4LInvocableReportWizard.Requests> reqlist = new List<L4LInvocableReportWizard.Requests>();

    L4LInvocableReportWizard.Requests req = new L4LInvocableReportWizard.Requests();
    req.clientId = '0018t000002vfSfAAI';
    req.starttime = starttime;
    req.endtime = endtime;
    reqlist.add(req);

    List<string> result = L4LInvocableReportWizard.getStatusCountsBetweenDates(
      reqlist
    );
    System.debug(reqlist);




    List<Client_Objective__c> allcoList = [
      SELECT
        Objective_Name__c,
        status__c,
        Objective__r.SD__r.Program__r.Name,
        lastmodifieddate
      FROM Client_Objective__c
      WHERE client__c = '0018t000002vfSfAAI'
    ];

    System.debug(allcoList);




      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND Objective__r.SD__r.Program__r.Name = :pname
        AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name


      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = '0018t000002vfSfAAI'
        AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name


      Map<String,Integer> aggMap = new Map<String,Integer>();
      
      AggregateResult[] countAcquired = [
      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = '0018t000002vfSfAAI'
        AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ];

    for(AggregateResult ar: countAcquired){
//aggMap.put((String) ar.get('Name'),(Integer) ar.get('expr0'));
String name=(String) ar.get('Name');
Integer cnt = (Integer)ar.get('expr0');
System.debug('==> '+name+' '+cnt);
aggMap.put(name,cnt);
    }
System.debug(aggMap);

    Integer result = (countAcquired.size() > 0
      ? (Integer) countAcquired[0].get('expr0')
      : 0);



-------
/**************************************************************
 * @author	Mike Burnside
 * @name L4LInvocableReportWizard
 * #description Invocable methods used by the Report Wizard flow
 * @date	2022
 * @group Learning For Life
 *
 * @description	As of January 19, 2022 this is the controller for MDH's Report Wizard flow
 *
 */

global with sharing class L4LInvocableReportWizard {
  /*******************************************************************************************************
   * @description returns the status of a given session
   * @param requests List<Request>
   *
   * @return result List<String>
   *
   * @example
   */

  @InvocableMethod(
    label='L4L Invocable Report Wizard'
    description='L4L Invocable Report Wizard'
  )
  public static List<String> getStatusCountsBetweenDates(
    List<Requests> requests
  ) {
    // initialise our list of results

    String SCENARIO = 'Report Wizard - get aggregated client objectives between dates - Apex';

    Logger.setScenario(SCENARIO);
    Logger.info(
        'L4LInvocableReportWizard.getStatusCountsBetweenDates - invocable called from Flow'
      )
      .addTag('LFLInvocableSessionStatistics.computeSessionStats()')
      .addTag('logit()');

    List<String> result = new List<String>();

    String str = '';
    DateTime starttime = requests[0].starttime;
    DateTime endtime = requests[0].endtime;
    Id clientId = requests[0].clientId;

    System.debug('L4LInvocableReportWizard: received the following from flow');
    System.debug('L4LInvocableReportWizard: received starttime: ' + starttime);
    System.debug('L4LInvocableReportWizard: received endtime: ' + endtime);
    System.debug('L4LInvocableReportWizard: received clientId: ' + clientId);
    System.debug(
      'L4LInvocableReportWizard: here are the received dates in local format.'
    );
    System.debug(
      'L4LInvocableReportWizard: formatted starttime: ' + starttime.format()
    );
    System.debug(
      'L4LInvocableReportWizard: formatted endtime: ' + endtime.format()
    );

    TimeZone tz = UserInfo.getTimeZone();
    System.debug(
      'L4LInvocableReportWizard: the user timezone is: ' + tz.toString()
    );

    // start time processing //
    System.debug('L4LInvocableReportWizard: processing starttime...');
    Integer offset = tz.getOffset(starttime.dateGMT());
    System.debug(
      'L4LInvocableReportWizard: at the received starttime the offset to GMT is : ' +
      offset / 1000 +
      ' seconds.'
    );
    starttime = starttime.addSeconds(0 - (offset / 1000));
    System.debug(
      'L4LInvocableReportWizard: starttime after subtracting the offset to GMT : ' +
      starttime
    );
    System.debug(
      'L4LInvocableReportWizard: formatted local starttime after applying the offset to GMT: ' +
      starttime.format()
    );

    // end time processing //
    System.debug('L4LInvocableReportWizard: processing endtime');
    endtime = endtime.addDays(1); // ensure endtime is stretched to include the whole day
    System.debug(
      'L4LInvocableReportWizard: stretched the endtime to ' + endtime
    );

    offset = tz.getOffset(endtime.dateGMT());
    System.debug(
      'L4LInvocableReportWizard: at the stretched endtime the offset to GMT is: ' +
      offset / 1000 +
      ' seconds.'
    );
    endtime = endtime.addSeconds(0 - (offset / 1000));
    System.debug(
      'L4LInvocableReportWizard: stretched endtime after subtracting the offset to GMT: ' +
      endtime
    );
    System.debug(
      'L4LInvocableReportWizard: formatted local stretched endtime after applying the offset to GMT: ' +
      endtime.format()
    );
    System.debug(
      'L4LInvocableReportWizard: BOTTOM LINE we submit a SOQL statement that says=> SELECT..cols.. WHERE lastmodifieddate>=' +
      starttime +
      ' AND lastmodifieddate < ' +
      endtime
    );

    // execute a SOQL aggregate query
    AggregateResult[] groupedResults = [
      SELECT client__c, Objective__r.SD__r.Program__r.Name, status__c, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND status__c IN ('ACQ', 'HLD', 'ABS', 'OBJ')
        AND lastmodifieddate >= :starttime
        AND lastmodifieddate < :endtime
      GROUP BY client__c, Objective__r.SD__r.Program__r.Name, status__c
    ];

    System.debug(groupedResults);

    //hack to dedup program names
    Set<String> programSet = new Set<String>();
    System.debug('L4LInvocableReportWizard: deduping program names');
    for (AggregateResult ar : groupedResults) {
      programSet.add((String) ar.get('Name'));
    }

    System.debug('No of programs=' + programSet.size());

    if (programSet.size() > 0) {
      str += '<p>Total Number of Programs ' + programSet.size() + '</p>';
    }

    String oldpname = '';

    for (AggregateResult ar : groupedResults) {
      String statustext = '';
      String pname = (String) ar.get('Name');
      String status = (String) ar.get('Status__c');
      switch on status {
        when 'ACQ' {
          statustext = 'Acquired';
        }
        when 'HLD' {
          statustext = 'Held';
        }
        when 'ABS' {
          statustext = 'Absorbed';
        }
        when 'OBJ' {
          statustext = 'Current Objectives';
        }
        when else {
          statustext = '????';
        }
      }

      if (pname != oldpname) {
        // simulate a break report
        str += '<br/><p>Program: ' + pname + '</p>';
        str +=
          '<p>Objectives Acquired (All Time): ' +
          countAllTimeAcquired(clientId, pname) +
          '</p>';
      }
      str +=
        '<p>Number ' +
        statustext +
        ' (This Period): ' +
        ar.get('expr0') +
        '</p>';

      List<client_objective__c> colist = getObjectiveList(
        clientId,
        pname,
        starttime,
        endtime,
        status
      );

      for (Client_Objective__c co : colist) {
        str += '<p>&nbsp;&nbsp;&nbsp;&nbsp;> ' + co.objective_name__c + '</p>';
      }

      oldpname = pname;
    }

    System.debug(str);

    // DEPRECATED: Flow now does the insert to the NDIS_Report__c object
    //NDIS_Report__c ndr = new NDIS_Report__c();
    //ndr.client__c=clientId;
    //ndr.NDIS_Report__c=str;
    //insert ndr;

    result.add(str);
    return (result); //return our list of results
  }

  static Integer countAllTimeAcquired(Id clientId, String pname) {
    AggregateResult[] countAcquired = [
      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND Objective__r.SD__r.Program__r.Name = :pname
        AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ];

    Integer result = (countAcquired.size() > 0
      ? (Integer) countAcquired[0].get('expr0')
      : 0);

    return result;
  }

  static List<Client_Objective__c> getObjectiveList(
    Id clientId,
    String pname,
    Datetime starttime,
    Datetime endtime,
    String status
  ) {
    return [
      SELECT Objective_Name__c
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND status__c = :status
        AND Objective__r.SD__r.Program__r.Name = :pname
        AND lastmodifieddate >= :starttime
        AND lastmodifieddate < :endtime
    ];
  }

  /**************************************************************
   * @author	Mike Burnside
   * @name L4LInvocableReportWizard.Requests
   * @date	2022
   * @group Learning For Life
   *
   * @description Inner class to combine clientid, strttime, emdtime
   */

  global class Requests {
    @InvocableVariable
    global Id clientId;

    @InvocableVariable
    global DateTime starttime;

    @InvocableVariable
    global DateTime endtime;
  }
}
-----

/**************************************************************
 * @author	Mike Burnside
 * @name L4LInvocableReportWizard
 * #description Invocable methods used by the Report Wizard flow
 * @date	2022
 * @group Learning For Life
 *
 * @description	As of January 19, 2022 this is the controller for MDH's Report Wizard flow
 *
 */

global with sharing class L4LInvocableReportWizard {
  /*******************************************************************************************************
   * @description returns the status of a given session
   * @param requests List<Request>
   *
   * @return result List<String>
   *
   * @example
   */

  @InvocableMethod(
    label='L4L Invocable Report Wizard'
    description='L4L Invocable Report Wizard'
  )
  public static List<String> getStatusCountsBetweenDates(
    List<Requests> requests
  ) {
    // initialise our list of results

    String SCENARIO = 'Report Wizard - get aggregated client objectives between dates - Apex';

    Logger.setScenario(SCENARIO);
    Logger.info(
        'L4LInvocableReportWizard.getStatusCountsBetweenDates - invocable called from Flow'
      )
      .addTag('LFLInvocableSessionStatistics.computeSessionStats()')
      .addTag('logit()');

    List<String> result = new List<String>();

    String str = '';
    DateTime starttime = requests[0].starttime;
    DateTime endtime = requests[0].endtime;
    Id clientId = requests[0].clientId;

    System.debug('L4LInvocableReportWizard: received the following from flow');
    System.debug('L4LInvocableReportWizard: received starttime: ' + starttime);
    System.debug('L4LInvocableReportWizard: received endtime: ' + endtime);
    System.debug('L4LInvocableReportWizard: received clientId: ' + clientId);
    System.debug(
      'L4LInvocableReportWizard: here are the received dates in local format.'
    );
    System.debug(
      'L4LInvocableReportWizard: formatted starttime: ' + starttime.format()
    );
    System.debug(
      'L4LInvocableReportWizard: formatted endtime: ' + endtime.format()
    );

    TimeZone tz = UserInfo.getTimeZone();
    System.debug(
      'L4LInvocableReportWizard: the user timezone is: ' + tz.toString()
    );

    // start time processing //
    System.debug('L4LInvocableReportWizard: processing starttime...');
    Integer offset = tz.getOffset(starttime.dateGMT());
    System.debug(
      'L4LInvocableReportWizard: at the received starttime the offset to GMT is : ' +
      offset / 1000 +
      ' seconds.'
    );
    starttime = starttime.addSeconds(0 - (offset / 1000));
    System.debug(
      'L4LInvocableReportWizard: starttime after subtracting the offset to GMT : ' +
      starttime
    );
    System.debug(
      'L4LInvocableReportWizard: formatted local starttime after applying the offset to GMT: ' +
      starttime.format()
    );

    // end time processing //
    System.debug('L4LInvocableReportWizard: processing endtime');
    endtime = endtime.addDays(1); // ensure endtime is stretched to include the whole day
    System.debug(
      'L4LInvocableReportWizard: stretched the endtime to ' + endtime
    );

    offset = tz.getOffset(endtime.dateGMT());
    System.debug(
      'L4LInvocableReportWizard: at the stretched endtime the offset to GMT is: ' +
      offset / 1000 +
      ' seconds.'
    );
    endtime = endtime.addSeconds(0 - (offset / 1000));
    System.debug(
      'L4LInvocableReportWizard: stretched endtime after subtracting the offset to GMT: ' +
      endtime
    );
    System.debug(
      'L4LInvocableReportWizard: formatted local stretched endtime after applying the offset to GMT: ' +
      endtime.format()
    );
    System.debug(
      'L4LInvocableReportWizard: BOTTOM LINE we submit a SOQL statement that says=> SELECT..cols.. WHERE lastmodifieddate>=' +
      starttime +
      ' AND lastmodifieddate < ' +
      endtime
    );

    // fix for the DML overflow
    Map<String, Integer> projAcqMap = new Map<String, Integer>();

    AggregateResult[] countAcquired = [
      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM Client_Objective__c
      WHERE client__c = :clientId AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ];

    for (AggregateResult ar : countAcquired) {
      String pname = (String) ar.get('Name');
      Integer acqcnt = (Integer) ar.get('expr0');
      System.debug('==> ' + pname + ' ' + acqcnt);
      projAcqMap.put(pname, acqcnt);
    }

    System.debug(projAcqMap);

    List<Client_Objective__c> allcoList = [
      SELECT
        Objective_Name__c,
        status__c,
        Objective__r.SD__r.Program__r.Name,
        lastmodifieddate
      FROM Client_Objective__c
      WHERE client__c = :clientId
    ];

    // end of fix

    // execute a SOQL aggregate query
    AggregateResult[] groupedResults = [
      SELECT client__c, Objective__r.SD__r.Program__r.Name, status__c, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND status__c IN ('ACQ', 'HLD', 'ABS', 'OBJ')
        AND lastmodifieddate >= :starttime
        AND lastmodifieddate < :endtime
      GROUP BY client__c, Objective__r.SD__r.Program__r.Name, status__c
    ];

    System.debug(groupedResults);

    //hack to dedup program names
    Set<String> programSet = new Set<String>();
    System.debug('L4LInvocableReportWizard: deduping program names');
    for (AggregateResult ar : groupedResults) {
      programSet.add((String) ar.get('Name'));
    }

    System.debug('No of programs=' + programSet.size());

    if (programSet.size() > 0) {
      str += '<p>Total Number of Programs ' + programSet.size() + '</p>';
    }

    String oldpname = '';

    for (AggregateResult ar : groupedResults) {
      String statustext = '';
      String pname = (String) ar.get('Name');
      String status = (String) ar.get('Status__c');
      switch on status {
        when 'ACQ' {
          statustext = 'Acquired';
        }
        when 'HLD' {
          statustext = 'Held';
        }
        when 'ABS' {
          statustext = 'Absorbed';
        }
        when 'OBJ' {
          statustext = 'Current Objectives';
        }
        when else {
          statustext = '????';
        }
      }

      if (pname != oldpname) {
        // simulate a break report
        str += '<br/><p>Program: ' + pname + '</p>';
        str +=
          '<p>Objectives Acquired (All Time): ' +
          //countAllTimeAcquired(clientId, pname) +
          getAllTimeAcquired(pname, projAcqMap) +
          '</p>';
      }
      str +=
        '<p>Number ' +
        statustext +
        ' (This Period): ' +
        ar.get('expr0') +
        '</p>';

      List<client_objective__c> colist = getObjectiveList(
        clientId,
        pname,
        starttime,
        endtime,
        status,
        allcoList
      );

      for (Client_Objective__c co : colist) {
        str += '<p>&nbsp;&nbsp;&nbsp;&nbsp;> ' + co.objective_name__c + '</p>';
      }

      oldpname = pname;
    }

    System.debug(str);

    // DEPRECATED: Flow now does the insert to the NDIS_Report__c object
    //NDIS_Report__c ndr = new NDIS_Report__c();
    //ndr.client__c=clientId;
    //ndr.NDIS_Report__c=str;
    //insert ndr;

    result.add(str);
    return (result); //return our list of results
  }

  static Integer countAllTimeAcquired(Id clientId, String pname) {
    AggregateResult[] countAcquired = [
      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND Objective__r.SD__r.Program__r.Name = :pname
        AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ];

    Integer result = (countAcquired.size() > 0
      ? (Integer) countAcquired[0].get('expr0')
      : 0);

    return result;
  }

  static Integer getAllTimeAcquired(
    String pname,
    Map<String, Integer> projAcqMap
  ) {
    if (projAcqMap == null)
      return 0;

    Integer result = projAcqMap.get(pname);

    if (result != null) {
      return result;
    } else {
      return 0;
    }
  }

  static List<Client_Objective__c> getObjectiveList(
    Id clientId,
    String pname,
    Datetime starttime,
    Datetime endtime,
    String status,
    List<Client_Objective__c> allcoList
  ) {
    List<client_objective__c> retlist = new List<client_objective__c>();

    for (client_objective__c co : allcoList) {
      if (
        (co.status__c == status) &&
        (co.Objective__r.SD__r.Program__r.Name == pname) &&
        (co.lastmodifieddate >= starttime) &&
        (co.lastmodifieddate < endtime)
      ) {
        retlist.add(co);
      }
    }
    return retlist;
  }

  /**************************************************************
   * @author	Mike Burnside
   * @name L4LInvocableReportWizard.Requests
   * @date	2022
   * @group Learning For Life
   *
   * @description Inner class to combine clientid, strttime, emdtime
   */

  global class Requests {
    @InvocableVariable
    global Id clientId;

    @InvocableVariable
    global DateTime starttime;

    @InvocableVariable
    global DateTime endtime;
  }
}



List<Behaviour_of_Concern__c> getUnused=L4LController.getUnusedBOC('0018t000002vfSfAAI');
System.debug(getUnused);


List<Behaviour_of_Concern__c> getPopularCBOC = L4LController.getPopularCBOC('0019n00000BPIjRAAX');
System.debug(getPopularCBOC);
List<client_boc__c> cbocList = L4LController.getActiveCBOCList('0018t000002yucNAAQ');
System.debug('size = '+cbocList.size());
