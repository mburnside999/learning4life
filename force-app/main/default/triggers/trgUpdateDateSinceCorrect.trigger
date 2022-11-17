trigger trgUpdateDateSinceCorrect on Session_Obj__c(before update) {
  System.debug('trgUpdateDateSinceCorrect: entering');

  for (Session_Obj__c so : Trigger.New) {
    System.debug('trgUpdateDateSinceCorrect: in New loop');

    // if (so.correct__c == true && (so.previous_status__c == 'ACQ')) {

    Id clientid = [
      SELECT session__r.client__r.id
      FROM session_obj__c
      WHERE id = :so.id
      LIMIT 1
    ]
    .session__r.client__r.id;

    System.debug('trgUpdateDateSinceCorrect: related clientid: ' + clientid);

    Client_Objective__c co = [
      SELECT id, last_tested__c, last_tested_Correct__c
      FROM client_objective__c
      WHERE client__c = :clientid AND objective__C = :so.objective__c
      LIMIT 1
    ];

    System.debug(
      'trgUpdateDateSinceCorrect: related client_objective: ' + co.Id
    );
    if (so.correct__c == true) {
      System.debug(
        'trgUpdateDateSinceCorrect: marked Correct && previous status ACQ = true '
      );
      co.last_tested_correct__c = date.today();
      System.debug(
        'trgUpdateDateSinceCorrect: last tested correct date set to: ' +
        co.last_tested_correct__c
      );
    }
    co.last_tested__c = date.today();
    update co;
  }
}
