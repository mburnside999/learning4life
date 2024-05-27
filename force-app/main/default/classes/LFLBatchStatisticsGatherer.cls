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

  List<Account> accountList = new List<Account>();

  global Iterable<AggregateResult> start(Database.BatchableContext bc) {
    coObjectivesMap = new Map<String, client_objective__c>();
    coClientMap = new Map<Id, Map<String, client_objective__c>>();
    for (client_objective__c co : [
      SELECT
        id,
        client__c,
        objective__c,
        name,
        last_tested__c,
        last_tested_correct__c
      FROM client_objective__c
      ORDER BY lastmodifieddate DESC
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

          Client_Objective__c co1 = (client_objective__c) updatesToCOMap.get(
            co.Id
          );
          if (modifieddate >= co1.last_tested__c) {
            co1.last_tested__c = modifieddate;
          }
          if (correct) {
            System.debug(
              '*** correct:' +
                correct +
                ' co1.bltc: ' +
                co1.last_tested_correct__c
            );
            co1.last_tested_correct__c = modifieddate;
          }
          System.debug('existing, proposed ' + co1);
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
