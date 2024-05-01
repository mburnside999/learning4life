/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGatherer
 * @date	2023
 * @group Learning For Life
 *
 * @description	Stats gathering
 *
 */

global class LFLBatchStatisticsGatherer implements Database.Batchable<AggregateResult>, Database.Stateful {
  Integer i = 0;
  String msg;
  Map<String, Date> tslogdates = new Map<String, Date>();

  List<Account> accountList = new List<Account>();

  global Iterable<AggregateResult> start(Database.BatchableContext bc) {
    for (TimeSeries_Log__c tsl : [
      SELECT name, ts_log_datetime__c
      FROM timeseries_log__c
    ]) {
      Date d = Date.newInstance(
        tsl.ts_log_datetime__c.year(),
        tsl.ts_log_datetime__c.month(),
        tsl.ts_log_datetime__c.day()
      );
      tslogdates.put(tsl.name, d);
    }

    return new LFLAggregateResultIterable();
  }

  global void execute(
    Database.BatchableContext bc,
    List<AggregateResult> scope
  ) {
    AggregateResult[] results = (AggregateResult[]) scope;

    for (AggregateResult ar : scope) {
      i = i + 1;
      String client = (String) ar.get('client');
      Account a = new Account(Id = client);
      Date startd = (Date) tslogdates.get((String) ar.get('minRunId'));
      Date endd = (Date) tslogdates.get((String) ar.get('maxRunId'));
      Decimal elapsed = startd.daysBetween(endd) / 7;
      elapsed += 1;
      System.debug(
        'client= ' +
          client +
          ' startd' +
          startd +
          ' - ' +
          endd +
          ' = ' +
          elapsed +
          'weeks'
      );
      Integer distinctClients = (Integer) ar.get('distinctClients');
      Integer distinctCOs = (Integer) ar.get('distinctCOs');
      System.debug(' clients=' + distinctClients + ' cos=' + distinctCOs);
      //calculate acq/client/week
      Decimal acqRate = 0;
      if (elapsed > 0) {
        acqRate = (Decimal) (distinctCOs / distinctClients / elapsed);
      } else {
        acqRate = 0;
      }
      a.ACQ_Rate__c = acqRate;
      accountList.add(a);

      System.debug('Program: ' + client + ', acqRate: ' + acqRate.setScale(2));
      msg +=
        'Earliest: ' +
        ar.get('minRunId') +
        ', Latest: ' +
        ar.get('maxRunId') +
        +', Elapsed: ' +
        elapsed +
        ' weeks, Client: ' +
        client +
        ', distinctCOs: ' +
        distinctCOs +
        ', AcqRate: ' +
        acqRate.setScale(2) +
        '\n';
      //   // Process each result here as needed
    }
  }

  global void finish(Database.BatchableContext bc) {
    System.debug('in LFLBatchStatisticsGatherer.finish()');

    System.debug('updating Accounts');

    if (!Test.isRunningTest()) {
      update accountList;
    }

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String orgname = UserInfo.getOrganizationName();

    mail.setToAddresses(new List<String>{ 'mburnside@salesforce.com' });
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName('Stats Batch Processing');
    mail.setSubject(orgname + ' Stats completed');

    mail.setPlainTextBody('Successfully processed ' + i + ' records\n' + msg);

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
