public class LFLTimeSeriesBatch implements Database.Batchable<sObject>, Database.Stateful {
  public String query;
  public String email = 'mburnside@salesforce.com';
  public String runId;
  public integer recs = 0;

  public Database.querylocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(query);
  }
/**************************************************************
 * @name LFLTimeSeriesBatch
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	
 *
 */
 
  public void execute(Database.BatchableContext BC, List<sObject> scope) {
    List<Client_Objective_TimeSeries__c> tslist = new List<Client_Objective_TimeSeries__c>();

    for (sObject s : scope) {
      Client_Objective_TimeSeries__c tsrecord = new Client_Objective_TimeSeries__c();
      Client_Objective__c co = (Client_Objective__c) s;
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
      tsrecord.Stage__c = co.Stage__c;
      tsrecord.Area__c = co.Area__c;
      tsrecord.status__c = co.status__c;
      tsrecord.active__c = co.active__c;
      tsrecord.Re_Test_Recommended__c = co.Re_Test_Recommended__c;

      tslist.add(tsrecord);
    }

    insert tslist;
    recs += tslist.size();
  }
  public void finish(Database.BatchableContext BC) {
    TimeSeries_Log__c endlog = new TimeSeries_Log__c();
    endlog.comments__c =
      'Successfully processed ' +
      recs +
      ' timeseries records';
    insert endlog;

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    mail.setToAddresses(new List<String>{ email });
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName('Batch Processing');
    mail.setSubject('LFLTimeSeriesBatch completed.');

    mail.setPlainTextBody(
      'LFLTimeSeriesBatch completed successfully: ' +
        recs +
        ' Client Objective TimeSeries records created.'
    );

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
