/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGatherer
 * @date	2023
 * @group Learning For Life
 *
 * @description	Stats gathering
 *
 */

global class LFLBatchStatisticsGatherer5 implements Database.Batchable<AggregateResult>, Database.Stateful {
  Integer i = 0;
  integer batch = 0;
  String msg = 'SD Statistics Generation\n--------------------------------------\n';
  global Iterable<AggregateResult> start(Database.BatchableContext bc) {
    msg += '\nBatches\n-----------\n';
    return new LFLAggregateResultIterable5();
  }

  global void execute(
    Database.BatchableContext bc,
    List<AggregateResult> scope
  ) {
    AggregateResult[] results = (AggregateResult[]) scope;
    List<Program__c> progList = new List<Program__c>();
    batch = batch + 1;
    for (AggregateResult ar : scope) {
      i = i + 1;
      String progid = (String) ar.get('program__c');
      String progname = (String) ar.get('progname');

      Decimal correct = (Decimal) ar.get('correct');
      Decimal incorrect = (Decimal) ar.get('incorrect');
      Decimal prompted = (Decimal) ar.get('prompted');
      Decimal nonresponsive = (Decimal) ar.get('noresponsive');
      Decimal sessions = (Decimal) ar.get('sessions');
      Decimal clients = (Decimal) ar.get('clients');
      Date earliest_session_date = (Date) ar.get('earliest_session_date');
      Date latest_session_date = (Date) ar.get('latest_session_date');
      Decimal score =
        (Decimal) (correct / (correct + incorrect + prompted + nonresponsive)) *
        100;

      Program__c prog = new Program__c(Id = progid);
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
      prog.stats_timestamp__c = DateTime.now();
      prog.Percent_Correct__c = score;
      prog.Sessions__c = Integer.valueOf(sessions);
      prog.Clients__c = Integer.valueOf(clients);
      prog.Incorrect__c = Integer.valueOf(incorrect);
      prog.Correct__c = Integer.valueOf(correct);
      prog.Prompted__c = Integer.valueOf(prompted);
      prog.Non_Responsive__c = Integer.valueOf(nonresponsive);
      prog.Total_Responses__c = Integer.valueOf(
        correct + incorrect + prompted + nonresponsive
      );
      prog.Earliest_Session_Date__c = earliest_session_date;
      prog.Latest_Session_Date__c = latest_session_date;

      // a.No_Of_Closed_sessions__c = sessions;
      // a.acq_rate__c = acqRate;
      // a.first_session__c = mindate;
      // a.latest_closed_session__c = maxdate;
      // a.elapsed_weeks__c = elapsed;
      // a.acq_session_rate__c = acqSessionRate;
      // a.acq_count__c = acqCount;
      // a.stats_timestamp__c = DateTime.now();
      progList.add(prog);

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
    update progList;
    msg +=
      'Batch: ' +
      batch +
      ': ' +
      progList.size() +
      ' Program records updated\n';
  }

  global void finish(Database.BatchableContext bc) {
    System.debug('in LFLBatchStatisticsGatherer4.finish()');

    //System.debug('updating Accounts');
    // update objList;
    // msg += objList.size() + ' SD records updated\n';
    msg += '\nJob Completion\n-------------------\n';
    msg += 'Summary: ' + i + ' Program records processed\n';

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
