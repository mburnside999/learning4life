trigger trgUpdateDateSinceCorrect on Session_Obj__c(
  before update,
  after insert
) {
  System.debug('trgUpdateDateSinceCorrect: entering');

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
        SELECT id, last_tested__c, last_tested_Correct__c
        FROM client_objective__c
        WHERE client__c = :clientid AND objective__C = :objectiveId
        LIMIT 1
      ];

      System.debug(
        'trgUpdateDateSinceCorrect: related client_objective: ' + co.Id
      );
      if (Trigger.newMap.get(soid).correct__c) {
        System.debug('trgUpdateDateSinceCorrect: correct__c=true');
        co.last_tested_correct__c = date.today();
        System.debug(
          'trgUpdateDateSinceCorrect: setting last tested correct date to today(): ' +
          date.today()
        );
      }
      System.debug(
        'trgUpdateDateSinceCorrect: setting last tested date to today(): ' +
        date.today()
      );
      co.last_tested__c = date.today();

      System.debug(
        'trgUpdateDateSinceCorrect: updating client objective, co=' + co
      );
      update co;
    }
  }
}
