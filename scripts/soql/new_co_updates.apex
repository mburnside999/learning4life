Map<Id, Map<String, client_objective__c>> coClientMap = new Map<Id, Map<String, client_objective__c>>();
Map<String, client_objective__c> coObjectivesMap = new Map<String, client_objective__c>();
for (client_objective__c co : [
  SELECT
    id,
    client__c,
    objective__c,
    name,
    last_tested__c,
    last_tested_correct__c
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
    max(lastmodifieddate) modifieddate
  FROM session_obj__c
  WHERE
    lastmodifieddate < 2023-12-31T00:00:00Z
    AND lastmodifieddate >= 2023-11-01T00:00:00Z
    AND session__r.status__c = 'Closed'
  GROUP BY session__r.client__c, objective__c, correct__c
  ORDER BY objective__c
  LIMIT 2000
]) {
  String client = (String) ar.get('client');
  DateTime dt = (DateTime) ar.get('modifieddate');
  Date modifieddate = (Date) dt.Date();
  Boolean correct = (Boolean) ar.get('correct');

  String objective = (String) ar.get('objective');

  if (!coClientMap.keySet().contains(client)) {
    continue;
  }
  Map<String, client_objective__c> coObjectiveMap = (Map<String, client_objective__c>) coClientMap.get(
    client
  );
  //System.debug('coObjetiveMap=>' + coObjectiveMap);
  System.debug(
    'SO Query==> modifieddate=' +
      modifieddate +
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

      if (correct) {
        System.debug('** Correct! **');
        System.debug('setting last_tested_correct to ' + modifieddate);
        co.last_tested_correct__c = modifieddate;
      }
      co.last_tested__c = modifieddate;
      System.debug('new, proposed ' + co);
      updatesToCOMap.put(co.Id, co);
    } else {
      System.debug('** existing co for updatesToCOMap');

      Client_Objective__c co1 = (client_objective__c) updatesToCOMap.get(co.Id);
      if (modifieddate >= co1.last_tested__c) {
        co1.last_tested__c = modifieddate;
      }
      if (correct) {
        //   && ((modifieddate >= co1.last_tested_correct__c) ||
        //   (co1.last_tested_correct__c == null))
        System.debug(
          '*** correct:' + correct + ' co1.bltc: ' + co1.last_tested_correct__c
        );
        co1.last_tested_correct__c = modifieddate;
      }
      System.debug('existing, proposed ' + co1);
      updatesToCOMap.put(co1.Id, co1);
    }
  }
}
System.debug('***** update map size ====> ' + updatesToCOMap.keySet().size());
if (!updatesToCOMap.isEmpty()) {
  System.debug('updating');
  //update updatesToCOMap.values();
}

// Id batchInstanceId = Database.executeBatch(
//       new LFLBatchStatisticsGatherer(),
//       1000
//     );

