public class LFLClientObjectiveHelper {
  public static String getStatusCountsBetweenDates(
    DateTime starttime,
    DateTime endtime,
    Id clientid
  ) {
    // initialise our list of results

    String str = '<p></p>';

    // execute a SOQL aggregate query
    AggregateResult[] groupedResults = [
      SELECT client__c, Objective__r.SD__r.Program__r.Name, status__c, count(id)
      FROM Client_Objective__c
      WHERE
        client__c = :clientId
        AND status__c IN ('ACQ', 'HLD', 'ABS', 'OBJ')
        AND lastmodifieddate > :starttime
        AND lastmodifieddate <= :endtime
      GROUP BY client__c, Objective__r.SD__r.Program__r.Name, status__c
    ];

    System.debug(groupedResults);

    //hack to dedup progream names
    Set<String> programSet = new Set<String>();
    for (AggregateResult ar : groupedResults) {
      programSet.add((String) ar.get('Name'));
    }

    System.debug('No of programs=' + programSet.size());

    if (programSet.size() > 0) {
      str += '<p>Total Number of Programs ' + programSet.size() + '</p>';
      // iterate through the aggregate set pulling out the fields we want and build our list -- default the "expr(0)"" refers to the first aggregation column
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
        str += '<br/><p>' + pname + '</p>';
      }
      str += '<p>Number ' + statustext + ' ' + ar.get('expr0') + '</p>';

      oldpname = pname;
    }

    System.debug(str);

    NDIS_Report__c ndr = new NDIS_Report__c();
    ndr.client__c = clientId;
    ndr.NDIS_Report__c = str;
    insert ndr;

    return (str); //return our list of results
  }
}
