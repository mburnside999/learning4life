
/**************************************************************
 * @author	Mike Burnside
 * @name LFLTSBatchUtil
 * @date	2023
 * @group Learning For Life
 *
 * @description	Perform batch integrity checks on CO Timeseries.
 *
 */

global class LFLTSBatchUtil implements Database.Batchable<sobject>, Database.Stateful {
  Integer i = 0;
  Integer nullStatus = 0;
  Set<string> runidSet = new Set<String>();
  Map<Date, Set<String>> mapper = new Map<Date, Set<String>>();
  Map<String, Integer> runcounts = new Map<String, Integer>();

  global Database.QueryLocator start(Database.BatchableContext bc) {
    System.debug('XXXXXX in LFLTSBatchUtil.start() XXXX');

    return Database.getQueryLocator(
      'SELECT Id,runid__c,ts_load_datetime__c,status__c from client_objective_timeseries__c order by runid__c'
    );
  }

  global void execute(
    Database.BatchableContext bc,
    List<client_objective_timeseries__c> listCOTS
  ) {
    for (client_objective_timeseries__c cots : listCOTS) {
      runidSet.add(cots.runid__c);
      i++;
      if (cots.status__c == null) {
        nullStatus++;
      }
      Date d = cots.ts_load_datetime__c.date();

      if (mapper.containskey(d)) {
        Set<String> s = mapper.get(d);
        s.add(cots.runid__c);
        mapper.put(d, s);
      } else {
        Set<String> t = new Set<String>();
        t.add(cots.runid__c);
        mapper.put(d, t);
      }
      Integer rc = 0;
      if (runcounts.containskey(cots.runid__c)) {
        rc = runcounts.get(cots.runid__c);
        rc += 1;
        runcounts.put(cots.runid__c, rc);
      } else {
        rc = 1;
        runcounts.put(cots.runid__c, rc);
      }
    }
  }

  global void finish(Database.BatchableContext bc) {
    System.debug('in LFLTSBatchUtil.finish()');
    System.debug('SET SIZE=' + runidSet.size());
    System.debug('RECORDS=' + i);
    String emailtext = '';

    emailtext += '----- COTS Summary ----- \n';

    emailtext += 'COTS Records Processed: ' + i + '\n';

    emailtext += 'Number of COTS runs: ' + runidSet.size() + '\n';
    emailtext += 'Number of COTS run dates: ' + mapper.keyset().size() + '\n\n';
    emailtext += '----- Runs / RunDate Alignment -----\n';

    if (runidSet.size() != mapper.keyset().size()) {
      emailtext += ' Test: COTS run/date count check. FAILED: The number of COTS run dates is different to the number of COTS runs\n';
    } else {
      emailtext += ' Test: COTS run/date count check. PASSED: The number of COTS run dates = the number of COTS runs\n';
    }

    emailtext += '\n';

    emailtext += '-----  Status Count --------- \n';
    if (nullStatus > 0) {
      emailtext +=
        ' Test: Null Status Count. FAILED: ' +
        nullStatus +
        ' COTS records have a null status';
    } else {
      emailtext += ' Test: Null Status Count. PASSED.';
    }
    emailtext += '\n';

    emailtext += '\n----- RUN Record Count Details --------- \n';

    // sort keys via a list
    List<String> runsetList = new List<String>();
    runsetList.addAll(runcounts.keySet());
    runsetList.sort();

    for (String key : runsetList) {
      Integer i = runcounts.get(key);
      emailtext += 'RunID: ' + key + ' Records: ' + i;

      if (i == 0) {
        emailtext += ' Test: Non zero COTS Record count. FAILED: zero COTS records for this run';
      } else {
        emailtext += ' Test: Non zero COTS Record count. PASSED';
      }
      emailtext += '\n';
    }

    emailtext += '\n----- Date Analysis Details --------- \n';

    // sort keys via a list
    List<Date> mapperList = new List<Date>();
    mapperList.addAll(mapper.keySet());
    mapperList.sort();

    for (Date d : mapperList) {
      Set<String> s = mapper.get(d);

      emailtext += ('Date: ' +
      d +
      ' - ' +
      'No of Runs: ' +
      s.size() +
      ' ' +
      s +
      ' ');
      if (s.size() > 1) {
        emailtext += ' Test: Single run per date. FAILED: duplicate runs detected for a date';
      } else {
        emailtext += ' Test: Single run per date. PASSED';
      }
      emailtext += '\n';
    }

    emailtext += '\n----- COTS Rollup Analysis --------- \n';

    List<client_objective_timeseries_rollup__c> rollupList = [
      SELECT id, Name, runid__c
      FROM client_objective_timeseries_rollup__c
      WHERE runid__c NOT IN :runcounts.keyset()
    ];

    if (rollupList.size() > 0) {
      emailtext +=
        ' Test: Orphan rollups. FAILED: ' +
        rollupList.size() +
        ' The following records do not have a valid RunID \n';
      emailtext += rollupList;
    } else {
      emailtext += ' Test: Orphan rollups. PASSED: All rollup records have a valid RunID\n';
    }

    List<AggregateResult> sumList = [
      SELECT sum(statuscount__c)
      FROM client_objective_timeseries_rollup__c
    ];

    Integer intSum = 0;
    Decimal decSum = (Decimal) sumList[0].get('expr0');

    if (decSum != null) {
      intSum = Integer.valueOf(decSum);
    }

    if (intSum - i != 0) {
      emailtext +=
        ' Test: Rollup sums. FAILED: rollup sumcount=' +
        intSum +
        ', total COTS records=' +
        i +
        '\n';
    } else {
      emailtext +=
        ' Test: Rollup sums. PASSED: rollup sumcount=' +
        intSum +
        ', total COTS records=' +
        i +
        '\n';
    }

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new List<String>{ 'mburnside@salesforce.com' };
    mail.setToAddresses(toAddresses);
    mail.setSubject('COTS Analysis Completed');

    mail.setPlainTextBody(emailtext);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
