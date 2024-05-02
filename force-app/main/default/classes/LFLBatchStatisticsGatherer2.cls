/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGatherer
 * @date	2023
 * @group Learning For Life
 *
 * @description	Stats gathering
 *
 */

global class LFLBatchStatisticsGatherer2 implements Database.Batchable<AggregateResult>, Database.Stateful {
  Integer i = 0;
  String msg;

  List<Account> accountList = new List<Account>();

  global Iterable<AggregateResult> start(Database.BatchableContext bc) {
    return new LFLAggregateResultIterable2();
  }

  global void execute(
    Database.BatchableContext bc,
    List<AggregateResult> scope
  ) {
    AggregateResult[] results = (AggregateResult[]) scope;

    for (AggregateResult ar : scope) {
      i = i + 1;
      String client = (String) ar.get('client');
      String clientname = (String) ar.get('clientname');

      Account a = new Account(Id = client);
      Date mindate = (Date) ar.get('mindate');
      Date maxdate = (Date) ar.get('maxdate');
      Decimal totalduration = (Decimal) ar.get('totalduration');
      Decimal elapsed = mindate.daysBetween(maxdate) / 7;
      Integer sessions = (Integer) ar.get('sessions');
      System.debug(
        'client= ' +
          client +
          ' mindate' +
          mindate +
          ' - ' +
          maxdate +
          ' = ' +
          elapsed +
          'weeks'
      );

      // Decimal acqRate = 0;
      // if (elapsed > 0) {
      //   acqRate = (Decimal) (distinctCOs / distinctClients / elapsed);
      // } else {
      //   acqRate = 0;
      // }
      a.Total_Session_Duration__c = totalduration;
      a.No_Of_Closed_sessions__c = sessions;
      accountList.add(a);

      msg +=
        'Earliest: ' +
        ar.get('mindate') +
        ', Latest: ' +
        ar.get('maxdate') +
        +', Elapsed: ' +
        elapsed +
        ' weeks, Client: ' +
        client +
        ', Name: ' +
        clientname +
        ', Sessions: ' +
        sessions +
        ', Total Duration: ' +
        totalduration +
        '\n';
      //   // Process each result here as needed
    }
  }

  global void finish(Database.BatchableContext bc) {
    System.debug('in LFLBatchStatisticsGatherer2.finish()');

    //System.debug('updating Accounts');

    if (!Test.isRunningTest()) {
      update accountList;
    }

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String orgname = UserInfo.getOrganizationName();

    mail.setToAddresses(new List<String>{ 'mburnside@salesforce.com' });
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName('Stats Batch Processing2');
    mail.setSubject(orgname + ' Stats completed');

    mail.setPlainTextBody('Successfully processed ' + i + ' records\n' + msg);

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
