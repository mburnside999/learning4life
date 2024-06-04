/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGatherer
 * @date	2023
 * @group Learning For Life
 *
 * @description	Stats gathering
 *
 */

global class LFLBatchStatisticsGatherer3 implements Database.Batchable<AggregateResult>, Database.Stateful {
  Integer i = 0;
  integer batch = 0;
  String msg = 'Objective Statistics Generation\n--------------------------------------\n';
  LFL_Statistics_Gatherer_Log__c lflsgl = new LFL_Statistics_Gatherer_Log__c();

  global Iterable<AggregateResult> start(Database.BatchableContext bc) {
    // write a gatherer log entry
    lflsgl.LFLSG_Class__c = 'LFLBatchStatisticsGatherer3';
    lflsgl.LFLSG_Objective__c = 'Update Objective session counts, C/I/N/P totals and percentages';
    lflsgl.LFLSG_Status__c = 'Processing';
    insert lflsgl;
    //

    msg += '\nBatches\n-----------\n';
    return new LFLAggregateResultIterable3();
  }

  global void execute(
    Database.BatchableContext bc,
    List<AggregateResult> scope
  ) {
    AggregateResult[] results = (AggregateResult[]) scope;
    List<Objective__c> objList = new List<Objective__c>();
    batch = batch + 1;
    for (AggregateResult ar : scope) {
      i = i + 1;
      String objective = (String) ar.get('objective__c');
      String objname = (String) ar.get('objname');

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

      Objective__c o = new Objective__c(Id = objective);
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
      o.stats_timestamp__c = DateTime.now();
      o.Percent_Correct__c = score;
      o.Sessions__c = Integer.valueOf(sessions);
      o.Clients__c = Integer.valueOf(clients);
      o.Incorrect__c = Integer.valueOf(incorrect);
      o.Correct__c = Integer.valueOf(correct);
      o.Prompted__c = Integer.valueOf(prompted);
      o.Non_Responsive__c = Integer.valueOf(nonresponsive);
      o.Total_Responses__c = Integer.valueOf(
        correct + incorrect + prompted + nonresponsive
      );
      o.Earliest_Session_Date__c = earliest_session_date;
      o.Latest_Session_Date__c = latest_session_date;

      // a.No_Of_Closed_sessions__c = sessions;
      // a.acq_rate__c = acqRate;
      // a.first_session__c = mindate;
      // a.latest_closed_session__c = maxdate;
      // a.elapsed_weeks__c = elapsed;
      // a.acq_session_rate__c = acqSessionRate;
      // a.acq_count__c = acqCount;
      // a.stats_timestamp__c = DateTime.now();
      objList.add(o);

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
    update objList;
    msg +=
      'Batch: ' +
      batch +
      ': ' +
      objList.size() +
      ' Objective records updated\n';
  }

  global void finish(Database.BatchableContext bc) {
    System.debug('in LFLBatchStatisticsGatherer3.finish()');

    //System.debug('updating Accounts');
    // update objList;
    // msg += objList.size() + ' Objective records updated\n';

    // write a gatherer log entry
    lflsgl.LFLSG_Status__c = 'Success';
    lflsgl.LFLSG_Message__c = 'Updated ' + i + ' Objective records';
    update lflsgl;

    msg += '\nJob Completion\n-------------------\n';
    msg += 'Summary: ' + i + ' Objective records processed\n';

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String orgname = UserInfo.getOrganizationName();

    mail.setToAddresses(new List<String>{ 'mburnside@salesforce.com' });
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName('Apex BatchStatisticsGatherer3');
    mail.setSubject(orgname + ' BatchStatisticsGatherer3 completed.');

    mail.setPlainTextBody(msg);

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
