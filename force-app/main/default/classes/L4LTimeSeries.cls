public with sharing class L4LTimeSeries {
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
}
