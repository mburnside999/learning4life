public with sharing class L4LTimeSeries {
  public Integer loadCOTimeSeries() {
    TimeSeries_Log__c log = new TimeSeries_Log__c();
    log.comments__c = 'Started client objective timeseries run';
    insert log;

    String clientObjectiveSOQLStr =
      'Select Client__c,Client_Objective_Notes__c, Date_Absorbed__c,' +
      'Date_Acquired__c, Date_CIP__c, Date_Held__c, Date_Introduced__c,' +
      'Days_Since_Tested_Correct__c, Days_Since_Tested__c, Frequency__c,' +
      'Name, Objective__c, Program_Name__c,' +
      'Re_Test_Recommended__c, Status__c FROM Client_Objective__c ';

    List<Client_Objective__c> results = new List<Client_Objective__c>();
    results = Database.query(clientObjectiveSOQLStr);

    List<Client_Objective_TimesSeries__c> tslist = new List<Client_Objective_TimesSeries__c>();

    for (client_objective__c co : results) {
      Client_Objective_TimesSeries__c tsrecord = new Client_Objective_TimesSeries__c();
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

    insert tslist;

    log.comments__c =
      'Successfully processed ' +
      tslist.size() +
      ' client objective timeseries records';

    System.debug('inserted ' + tslist.size() + ' records');

    return tslist.size();
  }
}
