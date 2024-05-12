/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGatherer
 * @date	2023
 * @group Learning For Life
 *
 * @description	Stats gathering
 *
 */

global class LFLBatchStatisticsGatherer4 implements Database.Batchable<AggregateResult>, Database.Stateful {
  Integer i = 0;
  integer batch = 0;
  String msg = 'SD Statistics Generation\n--------------------------------------\n';
  global Iterable<AggregateResult> start(Database.BatchableContext bc) {
    msg += '\nBatches\n-----------\n';
    return new LFLAggregateResultIterable4();
  }

  global void execute(
    Database.BatchableContext bc,
    List<AggregateResult> scope
  ) {
    AggregateResult[] results = (AggregateResult[]) scope;
    List<SD__c> sdList = new List<SD__c>();
    batch = batch + 1;
    for (AggregateResult ar : scope) {
      i = i + 1;
      String sdid = (String) ar.get('sd__c');
      String sdname = (String) ar.get('sdname');

      Decimal correct = (Decimal) ar.get('correct');
      Decimal incorrect = (Decimal) ar.get('incorrect');
      Decimal prompted = (Decimal) ar.get('prompted');
      Decimal nonresponsive = (Decimal) ar.get('noresponsive');
      Decimal sessions = (Decimal) ar.get('sessions');
      Decimal clients = (Decimal) ar.get('clients');

      Decimal score =
        (Decimal) (correct / (correct + incorrect + prompted + nonresponsive)) *
        100;

      SD__c sd = new SD__c(Id = sdid);
      // Date mindate = (Date) ar.get('mindate');
      // Date maxdate = (Date) ar.get('maxdate');
      // Decimal totalduration = (Decimal) ar.get('totalduration');

      // //cast to decimal to avoid integer/integer division producing a zero result
      // Decimal decimal_elapsed = Decimal.valueOf(mindate.daysBetween(maxdate));
      // Decimal elapsed = decimal_elapsed / 7;
      // Integer sessions = (Integer) ar.get('sessions');

      // Decimal acqRate = 0;
      // if (elapsed > 0) {
      //   acqRate = (Decimal) (acqCount / elapsed);
      // } else {
      //   acqRate = 0;
      // }

      // Decimal acqSessionRate = 0;
      // //cast to decimal to avoid integer/integer division producing a zero result
      // Decimal decimal_acqCount = Decimal.valueOf(acqCount);
      // Decimal decimal_sessions = Decimal.valueOf(sessions);
      // if (sessions > 0) {
      //   acqSessionRate = decimal_acqCount / decimal_sessions;
      // } else {
      //   acqSessionRate = 0;
      // }
      sd.stats_timestamp__c = DateTime.now();
      sd.Percent_Correct__c = score;
      sd.Sessions__c = Integer.valueOf(sessions);
      sd.Clients__c = Integer.valueOf(clients);
      sd.Incorrect__c = Integer.valueOf(incorrect);
      sd.Correct__c = Integer.valueOf(correct);
      sd.Prompted__c = Integer.valueOf(prompted);
      sd.Non_Responsive__c = Integer.valueOf(nonresponsive);
      sd.Total_Responses__c = Integer.valueOf(
        correct + incorrect + prompted + nonresponsive
      );
      // a.No_Of_Closed_sessions__c = sessions;
      // a.acq_rate__c = acqRate;
      // a.first_session__c = mindate;
      // a.latest_closed_session__c = maxdate;
      // a.elapsed_weeks__c = elapsed;
      // a.acq_session_rate__c = acqSessionRate;
      // a.acq_count__c = acqCount;
      // a.stats_timestamp__c = DateTime.now();
      sdList.add(sd);

      // msg +=
      //   ' Objective: ' +
      //   objective +
      //   ', correct: ' +
      //   correct +
      //   ', incorrect: ' +
      //   incorrect +
      //   ', prompted : ' +
      //   prompted +
      //   ' nonrepsonsive: ' +
      //   nonresponsive +
      //   ' score: ' +
      //   score.setScale(2) +
      //   '\n';
      //   // Process each result here as needed
    }
    update sdList;
    msg += 'Batch: ' + batch + ': ' + sdList.size() + ' SD records updated\n';
  }

  global void finish(Database.BatchableContext bc) {
    System.debug('in LFLBatchStatisticsGatherer4.finish()');

    //System.debug('updating Accounts');
    // update objList;
    // msg += objList.size() + ' SD records updated\n';
    msg += '\nJob Completion\n-------------------\n';
    msg += 'Summary: ' + i + ' SD records processed\n';

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String orgname = UserInfo.getOrganizationName();

    mail.setToAddresses(new List<String>{ 'mburnside@salesforce.com' });
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName('Apex BatchStatisticsGatherer4');
    mail.setSubject(orgname + ' BatchStatisticsGatherer4 completed.');

    mail.setPlainTextBody(msg);

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
