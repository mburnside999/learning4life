Map<Id, Map<String, client_objective__c>> coClientMap = new Map<Id, Map<String, client_objective__c>>();
Map<String, client_objective__c> coObjectivesMap = new Map<String, client_objective__c>();

Map<String, Session__c> sessmap = new Map<String, Session__c>();
for (Session__c s : [SELECT id, name, date__c FROM session__c]) {
  sessmap.put(s.name, s);
}

for (client_objective__c co : [
  SELECT
    id,
    client__c,
    objective__c,
    name,
    last_tested__c,
    last_tested_correct__c,
    last_tested_session__c,
    last_tested_session_name__c,
    last_tested_correct_session__c,
    last_tested_correct_session_name__c,
    stats_timestamp__c
  FROM client_objective__c
  ORDER BY name
  LIMIT 50000
]) {
  String key = co.objective__c + '-' + co.client__c;
  coObjectivesMap.put(key, co);
  coClientMap.put(co.client__c, coObjectivesMap);
}

//System.debug(coObjectivesMap);

Map<id, client_objective__c> updatesToCOMap = new Map<id, client_objective__c>();

for (AggregateResult ar : [
  SELECT
    session__r.client__c client,
    objective__c objective,
    correct__c correct,
    max(createddate) createddate,
    max(session__r.name) sessionname
  FROM session_obj__c
  WHERE
    session__r.status__c = 'Closed'
    AND createddate > 2024-02-28T00:00:00Z
    AND createddate <= 2024-03-04T00:00:00Z
    and objective__c='a095h00000g1YccAAE'
  GROUP BY session__r.client__c, objective__c, correct__c
  ORDER BY objective__c, correct__c, max(createddate)
  LIMIT 5000
]) {
  String client = (String) ar.get('client');
  DateTime dt = (DateTime) ar.get('createddate');
  Date createddate = (Date) dt.Date();
  Boolean correct = (Boolean) ar.get('correct');
  String sessionname = (String) ar.get('sessionname');
  String objective = (String) ar.get('objective');

  String sessionId = sessmap.get(sessionname).Id;

  if (!coClientMap.keySet().contains(client)) {
    continue;
  }
  Map<String, client_objective__c> coObjectiveMap = (Map<String, client_objective__c>) coClientMap.get(
    client
  );
  //System.debug('coObjetiveMap=>' + coObjectiveMap);
  System.debug(
    'SO Query==> max(createddate)=' +
      createddate +
      ' objective=' +
      objective +
      ' correct=' +
      correct
  );

  String key = objective + '-' + client;
  //System.debug('key==>' + key);
  if (coObjectiveMap.containsKey(key)) {
    //protect against a CO that was deleted whilst it already had SO references
    Client_Objective__c co = (client_objective__c) coObjectiveMap.get(key);
    //System.debug('co===>' + co);
    if (!updatesToCOMap.keySet().contains(co.Id)) {
      System.debug('** new co for updatesToCOMap');

      System.debug('existing field values');
      System.debug(co);

      // System.debug('populating new field values');
      // System.debug(
      //   'last tested: ' +
      //     createddate +
      //     ' last_tested_Session:' +
      //     sessionId +
      //     ' last_tested_session_name:' +
      //     sessionname
      // );

      if (!correct) {
        co.last_tested__c = createddate;
        co.last_tested_session__c = sessionId;
        co.last_tested_session_name__c = sessionname;
      }
      System.debug('proposed field values');
      System.debug(co);

      if (correct) {
        System.debug('** Correct! **');

        co.last_tested_correct__c = createddate;
        co.last_tested_correct_session__c = sessionId;
        co.last_tested_correct_session_name__c = sessionname;

        if (
          co.last_tested_correct__c == null ||
          co.last_tested_correct__c > co.last_tested__c ||
          co.last_tested_correct_session_name__c >
          co.last_tested_session_name__c
        ) {
          co.last_tested__c = createddate;
          co.last_tested_session__c = sessionId;
          co.last_tested_session_name__c = sessionname;
        }
      }
      System.debug('new, proposed ' + co);
      co.stats_timestamp__c = DateTime.now();
      updatesToCOMap.put(co.Id, co);
    } else {
      System.debug('** existing co for updatesToCOMap');

      Client_Objective__c co1 = (client_objective__c) updatesToCOMap.get(co.Id);
      //if (sessionname >= co1.last_tested_session_name__c) {
      System.debug('getting co1 from updatesToCOMap');
      System.debug('setting last tested fields');

      if (!correct) {
        co1.last_tested__c = createddate;
        co1.last_tested_session__c = sessionId;
        co1.last_tested_session_name__c = sessionname;
        if (
          co1.last_tested_correct__c == null ||
          co1.last_tested_correct__c > co1.last_tested__c ||
          co1.last_tested_correct_session_name__c >
          co1.last_tested_session_name__c
        ) {
          co1.last_tested__c = createddate;
          co1.last_tested_session__c = sessionId;
          co1.last_tested_session_name__c = sessionname;
        }
      }

      if (correct) {
        System.debug('** Correct! **');

        co1.last_tested_correct__c = createddate;
        co1.last_tested_correct_session__c = sessionId;
        co1.last_tested_correct_session_name__c = sessionname;

        if (
          co1.last_tested_correct__c == null ||
          co1.last_tested_correct__c > co.last_tested__c ||
          co1.last_tested_correct_session_name__c >
          co1.last_tested_session_name__c
        ) {
          co1.last_tested__c = createddate;
          co1.last_tested_session__c = sessionId;
          co1.last_tested_session_name__c = sessionname;
        }
      }

      System.debug('existing, proposed ' + co1);
      co1.stats_timestamp__c = DateTime.now();
      updatesToCOMap.put(co1.Id, co1);
    }
  }
}
System.debug('***** update map size ====> ' + updatesToCOMap.keySet().size());
if (!updatesToCOMap.isEmpty()) {
  System.debug('updating');
  update updatesToCOMap.values();
}
