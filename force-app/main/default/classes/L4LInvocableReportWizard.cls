/**************************************************************
 * @author	Mike Burnside
 * @name L4LInvocableReportWizard
 * @date	2022
 * @group Learning For Life
 *
 * @description Invocable methods
 *
 */

global with sharing class L4LInvocableReportWizard {
  /*******************************************************************************************************
   * @description returns the status of a given session
   * @param requests List<Request>
   *
   * @return result List<String>
   *
   * @example
   */

  @InvocableMethod(
    label='L4L Invocable Report Wizard'
    description='L4L Invocable Report Wizard'
  )
  public static List<String> getStatusCountsBetweenDates(
    List<Requests> requests
  ) {
    // initialise our list of results

    String SCENARIO = 'Report Wizard - get aggregated client objectives between dates - Apex';

    Logger.setScenario(SCENARIO);
    Logger.info(
        'L4LInvocableReportWizard.getStatusCountsBetweenDates - invocable called from Flow'
      )
      .addTag('LFLInvocableSessionStatistics.computeSessionStats()')
      .addTag('logit()');

    List<String> result = new List<String>();

    String str = '';
    DateTime starttime = requests[0].starttime;
    DateTime endtime = requests[0].endtime;
    Id clientId = requests[0].clientId;

    System.debug('L4LInvocableReportWizard: received the following from flow');
    System.debug('L4LInvocableReportWizard: received starttime: ' + starttime);
    System.debug('L4LInvocableReportWizard: received endtime: ' + endtime);
    System.debug('L4LInvocableReportWizard: received clientId: ' + clientId);
    System.debug(
      'L4LInvocableReportWizard: here are the received dates in local format.'
    );
    System.debug(
      'L4LInvocableReportWizard: formatted starttime: ' + starttime.format()
    );
    System.debug(
      'L4LInvocableReportWizard: formatted endtime: ' + endtime.format()
    );

    TimeZone tz = UserInfo.getTimeZone();
    System.debug(
      'L4LInvocableReportWizard: the user timezone is: ' + tz.toString()
    );

    // start time processing //
    System.debug('L4LInvocableReportWizard: processing starttime...');
    Integer offset = tz.getOffset(starttime.dateGMT());
    System.debug(
      'L4LInvocableReportWizard: at the received starttime the offset to GMT is : ' +
        offset / 1000 +
        ' seconds.'
    );
    starttime = starttime.addSeconds(0 - (offset / 1000));
    System.debug(
      'L4LInvocableReportWizard: starttime after subtracting the offset to GMT : ' +
      starttime
    );
    System.debug(
      'L4LInvocableReportWizard: formatted local starttime after applying the offset to GMT: ' +
      starttime.format()
    );

    // end time processing //
    System.debug('L4LInvocableReportWizard: processing endtime');
    endtime = endtime.addDays(1); // ensure endtime is stretched to include the whole day
    System.debug(
      'L4LInvocableReportWizard: stretched the endtime to ' + endtime
    );

    offset = tz.getOffset(endtime.dateGMT());
    System.debug(
      'L4LInvocableReportWizard: at the stretched endtime the offset to GMT is: ' +
        offset / 1000 +
        ' seconds.'
    );
    endtime = endtime.addSeconds(0 - (offset / 1000));
    System.debug(
      'L4LInvocableReportWizard: stretched endtime after subtracting the offset to GMT: ' +
      endtime
    );
    System.debug(
      'L4LInvocableReportWizard: formatted local stretched endtime after applying the offset to GMT: ' +
      endtime.format()
    );
    System.debug(
      'L4LInvocableReportWizard: BOTTOM LINE we submit a SOQL statement that says=> SELECT..cols.. WHERE lastmodifieddate>=' +
        starttime +
        ' AND lastmodifieddate < ' +
        endtime
    );

    // fix for the DML overflow
    Map<String, Integer> projAcqMap = new Map<String, Integer>();

    AggregateResult[] countAcquired = [
      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM Client_Objective__c
      WHERE client__c = :clientId AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ];

    for (AggregateResult ar : countAcquired) {
      String pname = (String) ar.get('Name');
      Integer acqcnt = (Integer) ar.get('expr0');
      System.debug('==> ' + pname + ' ' + acqcnt);
      projAcqMap.put(pname, acqcnt);
    }

    System.debug(projAcqMap);

    List<Client_Objective__c> allcoList = [
      SELECT
        Objective_Name__c,
        status__c,
        Objective__r.SD__r.Program__r.Name,
        lastmodifieddate
      FROM Client_Objective__c
      WHERE client__c = :clientId
    ];

    // end of fix

    // execute a SOQL aggregate query
    AggregateResult[] groupedResults = [
      SELECT client__c, Objective__r.SD__r.Program__r.Name, status__c, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND status__c IN ('ACQ', 'HLD', 'ABS', 'OBJ')
        AND lastmodifieddate >= :starttime
        AND lastmodifieddate < :endtime
      GROUP BY client__c, Objective__r.SD__r.Program__r.Name, status__c
    ];

    System.debug(groupedResults);

    //hack to dedup program names
    Set<String> programSet = new Set<String>();
    System.debug('L4LInvocableReportWizard: deduping program names');
    for (AggregateResult ar : groupedResults) {
      programSet.add((String) ar.get('Name'));
    }

    System.debug('No of programs=' + programSet.size());

    if (programSet.size() > 0) {
      str += '<p>Total Number of Programs ' + programSet.size() + '</p>';
    }

    String oldpname = '';

    for (AggregateResult ar : groupedResults) {
      String statustext = '';
      String pname = (String) ar.get('Name');
      String status = (String) ar.get('Status__c');
      switch on status {
        when 'ACQ' {
          statustext = 'Acquired';
        }
        when 'HLD' {
          statustext = 'Held';
        }
        when 'ABS' {
          statustext = 'Absorbed';
        }
        when 'OBJ' {
          statustext = 'Current Objectives';
        }
        when else {
          statustext = '????';
        }
      }

      if (pname != oldpname) {
        // simulate a break report
        str += '<br/><p>Program: ' + pname + '</p>';
        str +=
          '<p>Objectives Acquired (All Time): ' +
          //countAllTimeAcquired(clientId, pname) +
          getAllTimeAcquired(pname, projAcqMap) +
          '</p>';
      }
      str +=
        '<p>Number ' +
        statustext +
        ' (This Period): ' +
        ar.get('expr0') +
        '</p>';

      List<client_objective__c> colist = getObjectiveList(
        clientId,
        pname,
        starttime,
        endtime,
        status,
        allcoList
      );

      for (Client_Objective__c co : colist) {
        str += '<p>&nbsp;&nbsp;&nbsp;&nbsp;> ' + co.objective_name__c + '</p>';
      }

      oldpname = pname;
    }

    System.debug(str);

    // DEPRECATED: Flow now does the insert to the NDIS_Report__c object
    //NDIS_Report__c ndr = new NDIS_Report__c();
    //ndr.client__c=clientId;
    //ndr.NDIS_Report__c=str;
    //insert ndr;

    result.add(str);
    return (result); //return our list of results
  }

  static Integer countAllTimeAcquired(Id clientId, String pname) {
    AggregateResult[] countAcquired = [
      SELECT Objective__r.SD__r.Program__r.Name, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND Objective__r.SD__r.Program__r.Name = :pname
        AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ];

    Integer result = (countAcquired.size() > 0
      ? (Integer) countAcquired[0].get('expr0')
      : 0);

    return result;
  }

  static Integer getAllTimeAcquired(
    String pname,
    Map<String, Integer> projAcqMap
  ) {
    if (projAcqMap == null)
      return 0;

    Integer result = projAcqMap.get(pname);

    if (result != null) {
      return result;
    } else {
      return 0;
    }
  }

  static List<Client_Objective__c> getObjectiveList(
    Id clientId,
    String pname,
    Datetime starttime,
    Datetime endtime,
    String status,
    List<Client_Objective__c> allcoList
  ) {
    List<client_objective__c> retlist = new List<client_objective__c>();

    for (client_objective__c co : allcoList) {
      if (
        (co.status__c == status) &&
        (co.Objective__r.SD__r.Program__r.Name == pname) &&
        (co.lastmodifieddate >= starttime) &&
        (co.lastmodifieddate < endtime)
      ) {
        retlist.add(co);
      }
    }
    return retlist;
  }

  /**************************************************************
   * @author	Mike Burnside
   * @name L4LInvocableReportWizard.Requests
   * @date	2022
   * @group Learning For Life
   *
   * @description Inner class to combine clientid, strttime, emdtime
   */

  global class Requests {
    @InvocableVariable
    global Id clientId;

    @InvocableVariable
    global DateTime starttime;

    @InvocableVariable
    global DateTime endtime;
  }
}
