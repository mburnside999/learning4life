/**************************************************************
 * @author	Mike Burnside
 * @name L4LInvocableReportWizard
 * @date	2022
 * @group Learning For Life
 *
 * @description	  As of January 19, 2022 this is the controller for MDH's Report Wizard flow
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

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      null,
      'L4LInvocableReportWizard.getStatusCountsBetweenDates() note filtered client objective active__c =true',
      'Flow invoked Apex',
      'next-gen-nebula-apex'
    );

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

    // execute a SOQL aggregate query
    AggregateResult[] groupedResults = [
      SELECT client__c, Objective__r.SD__r.Program__r.Name, status__c, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND active__c = TRUE
        AND status__c IN ('ACQ', 'HLD', 'ABS', 'OBJ')
        AND lastmodifieddate >= :starttime
        AND lastmodifieddate < :endtime
      GROUP BY client__c, Objective__r.SD__r.Program__r.Name, status__c
    ];

    System.debug(groupedResults);

    //hack to dedup progream names
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
          countAllTimeAcquired(clientId, pname) +
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
        status
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
        AND active__c = TRUE
        AND Objective__r.SD__r.Program__r.Name = :pname
        AND status__c = 'ACQ'
      GROUP BY Objective__r.SD__r.Program__r.Name
    ];

    Integer result = (countAcquired.size() > 0
      ? (Integer) countAcquired[0].get('expr0')
      : 0);

    return result;
  }

  static List<Client_Objective__c> getObjectiveList(
    Id clientId,
    String pname,
    Datetime starttime,
    Datetime endtime,
    String status
  ) {
    return [
      SELECT Objective_Name__c
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND active__c = TRUE
        AND status__c = :status
        AND Objective__r.SD__r.Program__r.Name = :pname
        AND lastmodifieddate >= :starttime
        AND lastmodifieddate < :endtime
    ];
  }

  /**************************************************************
   * @author	Mike Burnside
   * @name L4LInvocableReportWizard.Requests
   * @date	2022
   * @group Learning For Life
   *
   * @description
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
