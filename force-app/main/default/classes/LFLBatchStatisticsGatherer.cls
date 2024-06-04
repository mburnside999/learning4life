/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGatherer
 * @date	2023
 * @group Learning For Life
 *
 * @description	Stats gathering
 *
 */

global class LFLBatchStatisticsGatherer implements Database.Batchable<AggregateResult>, Database.Stateful {
  Integer i = 0;
  Integer batch = 0;

  String msg = 'Client Objective Last Tested/Last Tested Correct Generation\n----------------------------------------------------------------------------\n';

  Map<String, client_objective__c> coObjectivesMap;
  Map<Id, Map<String, client_objective__c>> coClientMap;
  Map<String, Session__c> sessmap;
  List<Account> accountList = new List<Account>();
  LFL_Statistics_Gatherer_Log__c lflsgl = new LFL_Statistics_Gatherer_Log__c();

  global Iterable<AggregateResult> start(Database.BatchableContext bc) {
    // write a gatherer log entry
    lflsgl.LFLSG_Class__c = 'LFLBatchStatisticsGatherer';
    lflsgl.LFLSG_Objective__c = 'Update CO with Last Tested/Correct DTD dates';
    lflsgl.LFLSG_Status__c = 'Processing';
    insert lflsgl;
    //

    sessmap = new Map<String, Session__c>();
    for (Session__c s : [SELECT id, name, date__c FROM session__c]) {
      sessmap.put(s.name, s);
    }
    coObjectivesMap = new Map<String, client_objective__c>();
    coClientMap = new Map<Id, Map<String, client_objective__c>>();
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
      ORDER BY createddate DESC
      LIMIT 50000
    ]) {
      String key = co.objective__c + '-' + co.client__c;
      coObjectivesMap.put(key, co);
      coClientMap.put(co.client__c, coObjectivesMap);
    }
    msg += '\nBatches\n-----------\n';
    return new LFLAggregateResultIterable();
  }

  global void execute(
    Database.BatchableContext bc,
    List<AggregateResult> scope
  ) {
    AggregateResult[] results = (AggregateResult[]) scope;
    batch = batch + 1;
    Map<id, client_objective__c> updatesToCOMap = new Map<id, client_objective__c>();

    for (AggregateResult ar : results) {
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
        'SO Query==> createddate=' +
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

          Client_Objective__c co1 = (client_objective__c) updatesToCOMap.get(
            co.Id
          );
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
    System.debug(
      '***** update map size ====> ' + updatesToCOMap.keySet().size()
    );
    if (!updatesToCOMap.isEmpty()) {
      i += updatesToCOMap.keySet().size();
      update updatesToCOMap.values();
      msg +=
        'Batch: ' +
        batch +
        ': ' +
        updatesToCOMap.keySet().size() +
        ' Client Objective records updated\n';
    }
  }

  global void finish(Database.BatchableContext bc) {
    System.debug('in LFLBatchStatisticsGatherer.finish()');
    System.debug('updating Client Objectives');

    // write a gatherer log entry
    lflsgl.LFLSG_Status__c = 'Success';
    lflsgl.LFLSG_Message__c = 'Updated ' + i + ' Client Objective records';
    update lflsgl;

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String orgname = UserInfo.getOrganizationName();
    msg += '\nJob Completion\n-------------------\n';
    msg += 'Summary: ' + i + ' Client Objective records processed\n';

    mail.setToAddresses(new List<String>{ 'mburnside@salesforce.com' });
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName('Last Tested Stats Batch Processing');
    mail.setSubject(orgname + ' Stats completed');

    mail.setPlainTextBody(msg);

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
