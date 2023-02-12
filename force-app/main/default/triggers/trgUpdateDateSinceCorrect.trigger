trigger trgUpdateDateSinceCorrect on Session_Obj__c(
  before update,
  after insert
) {
  System.debug('trgUpdateDateSinceCorrect: entering');

  L4LNebulaComponentController.setupCache();
  L4LNebulaComponentController.logDebug(
    null,
    'Trigger: trgUpdateDateSinceCorrect:',
    'Trigger: trgUpdateDateSinceCorrect:',
    'next-gen-nebula-apex'
  );

  for (Id soid : Trigger.newMap.keyset()) {
    System.debug('trgUpdateDateSinceCorrect: in New loop');
    Boolean fire = false;

    if (Trigger.isInsert)
      fire = true;

    if (Trigger.isUpdate) {
      if (
        (Trigger.oldMap.get(soid).correct__c !=
        Trigger.newMap.get(soid).correct__c) ||
        (Trigger.oldMap.get(soid).incorrect__c !=
        Trigger.newMap.get(soid).incorrect__c) ||
        (Trigger.oldMap.get(soid).prompted__c !=
        Trigger.newMap.get(soid).prompted__c) ||
        (Trigger.oldMap.get(soid).nonresponsive__c !=
        Trigger.newMap.get(soid).nonresponsive__c)
      ) {
        fire = true;
      }
    }

    // if (so.correct__c == true && (so.previous_status__c == 'ACQ')) {
    if (fire) {
      L4LNebulaComponentController.logDebug(
        soid,
        'Trigger: trgUpdateDateSinceCorrect: C,I,N,P changed ',
        'Trigger: trgUpdateDateSinceCorrect: C,I,N,P changed ',
        'next-gen-nebula-apex'
      );

      Id clientid = [
        SELECT session__r.client__r.id
        FROM session_obj__c
        WHERE id = :soid
        LIMIT 1
      ]
      .session__r.client__r.id;

      Id objectiveId = Trigger.newMap.get(soid).objective__c;

      System.debug('trgUpdateDateSinceCorrect: related clientid: ' + clientid);

      Client_Objective__c co = [
        SELECT id, last_tested__c, last_tested_Correct__c, active__c
        FROM client_objective__c
        WHERE client__c = :clientid AND objective__C = :objectiveId
        LIMIT 1
      ];

      // allow edits when inactive CO detected but log a warning
      if (co.active__c == false) {
        L4LNebulaComponentController.logWarning(
          co.id,
          'Trigger: trgUpdateDateSinceCorrect: Warning, the related CO is inactive - why is the SO being assessed?!',
          'Trigger: trgUpdateDateSinceCorrect: Warning, the related CO is inactive - why is the SO being assessed?!',
          'next-gen-nebula-apex'
        );
      }

      if (Trigger.newMap.get(soid).correct__c) {
        co.last_tested_correct__c = date.today();

        L4LNebulaComponentController.logDebug(
          co.id,
          'Trigger: trgUpdateDateSinceCorrect: Correct__c=true, setting CO last_tested_correct date to today ',
          'Trigger: trgUpdateDateSinceCorrect: Correct__c=true, setting CO last_tested_correct date to today ',
          'next-gen-nebula-apex'
        );
      }

      co.last_tested__c = date.today();
      L4LNebulaComponentController.logDebug(
        co.id,
        'Trigger: trgUpdateDateSinceCorrect: setting CO last tested date to today ',
        'Trigger: trgUpdateDateSinceCorrect: setting CO last tested date to today ',
        'next-gen-nebula-apex'
      );

      System.debug(
        'trgUpdateDateSinceCorrect: updating client objective, co=' + co
      );
      update co;
      L4LNebulaComponentController.logDebug(
        co.id,
        'Trigger: trgUpdateDateSinceCorrect: update successful',
        'Trigger: trgUpdateDateSinceCorrect: update successful',
        'next-gen-nebula-apex'
      );
    }
  }
}
