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
  String msg = 'Client Statistics Generation\n-----------------------------\n';

  integer batch = 0;

  Map<Id, Integer> comap = new Map<Id, Integer>();
  List<AggregateResult> coagglist = new List<AggregateResult>();
  global Iterable<AggregateResult> start(Database.BatchableContext bc) {
    msg += '\nBatches\n-----------\n';
    coagglist = [
      SELECT client__c client, client__r.lastname lastname, count(ID) cos
      FROM client_objective__c
      WHERE status__c = 'ACQ' AND client__r.current__c = TRUE
      GROUP BY client__c, client__r.lastname
    ];

    for (AggregateResult coagg : coagglist) {
      comap.put((Id) coagg.get('client'), (Integer) coagg.get('cos'));
    }

    return new LFLAggregateResultIterable2();
  }

  global void execute(
    Database.BatchableContext bc,
    List<AggregateResult> scope
  ) {
    AggregateResult[] results = (AggregateResult[]) scope;
    List<Account> accountList = new List<Account>();
    batch = batch + 1;
    for (AggregateResult ar : scope) {
      i = i + 1;
      String client = (String) ar.get('client');
      String clientname = (String) ar.get('clientname');
      Integer acqCount = 0;
      if (comap.keySet().contains(client)) {
        acqCount = (Integer) comap.get(client);
      }
      Account a = new Account(Id = client);
      Date mindate = (Date) ar.get('mindate');
      Date maxdate = (Date) ar.get('maxdate');
      Decimal totalduration = (Decimal) ar.get('totalduration');

      //cast to decimal to avoid integer/integer division producing a zero result
      Decimal decimal_elapsed = Decimal.valueOf(mindate.daysBetween(maxdate));
      Decimal elapsed = decimal_elapsed / 7;
      Integer sessions = (Integer) ar.get('sessions');

      Decimal acqRate = 0;
      if (elapsed > 0) {
        acqRate = (Decimal) (acqCount / elapsed);
      } else {
        acqRate = 0;
      }

      Decimal acqSessionRate = 0;
      //cast to decimal to avoid integer/integer division producing a zero result
      Decimal decimal_acqCount = Decimal.valueOf(acqCount);
      Decimal decimal_sessions = Decimal.valueOf(sessions);
      if (sessions > 0) {
        acqSessionRate = decimal_acqCount / decimal_sessions;
      } else {
        acqSessionRate = 0;
      }

      a.Total_Session_Duration__c = totalduration;
      a.No_Of_Closed_sessions__c = sessions;
      a.acq_rate__c = acqRate;
      a.first_session__c = mindate;
      a.latest_closed_session__c = maxdate;
      a.elapsed_weeks__c = elapsed;
      a.acq_session_rate__c = acqSessionRate;
      a.acq_count__c = acqCount;
      a.stats_timestamp__c = DateTime.now();
      accountList.add(a);

      // msg +=
      //   'Earliest: ' +
      //   ar.get('mindate') +
      //   ', Latest: ' +
      //   ar.get('maxdate') +
      //   +', Elapsed: ' +
      //   elapsed +
      //   ' weeks, Client: ' +
      //   client +
      //   ', Name: ' +
      //   clientname +
      //   ', Sessions: ' +
      //   sessions +
      //   ', Total Duration: ' +
      //   totalduration +
      //   ' acqCount: ' +
      //   acqCount +
      //   ' acqRate: ' +
      //   acqRate.setScale(2) +
      //   +'\n';
      //   // Process each result here as needed
    }
    update accountList;
    msg +=
      'Batch: ' +
      batch +
      ': ' +
      accountList.size() +
      ' Client records updated\n';
  }

  global void finish(Database.BatchableContext bc) {
    System.debug('in LFLBatchStatisticsGatherer2.finish()');

    msg += '\nJob Completion\n-------------------\n';
    msg += 'Summary: ' + i + ' Client records processed\n';

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String orgname = UserInfo.getOrganizationName();

    mail.setToAddresses(new List<String>{ 'mburnside@salesforce.com' });
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName('Apex BatchStatisticsGatherer2');
    mail.setSubject(orgname + ' BatchStatisticsGatherer2 completed.');

    mail.setPlainTextBody(msg);

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
