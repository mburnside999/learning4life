@isTest
private class TestDaysSinceUpdatedTrg {
  @isTest
  static void testTrg() {
    Test.startTest();
    //the test load contains a single session_objective where correct__c=false and previous_status='ACQ'
    LFLPopulateTestData.load();
    Test.stopTest();

    Session_Obj__c so = [
      SELECT id, objective__c
      FROM Session_Obj__c
      WHERE Correct__c = FALSE AND previous_status__c = 'ACQ'
      LIMIT 1
    ];

    Id clientid = [
      SELECT session__r.client__r.id
      FROM session_obj__c
      WHERE id = :so.id
      LIMIT 1
    ]
    .session__r.client__r.id;

    so.correct__c = true;
    update so;

    client_objective__c co_afterUpdate = [
      SELECT id, last_tested_Correct__c
      FROM client_objective__c
      WHERE client__c = :clientid AND objective__C = :so.objective__c
      LIMIT 1
    ];

    System.assert(
      co_afterUpdate.last_tested_correct__c == date.today(),
      'expected the trigger to change the last_tested_correct to today'
    );
  }
}
