@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestCascadeProgramStatusTrg
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Tests for trigger CascadeProgramStatusTrg
 *
 */

private class TestCascadeProgramStatusTrg {
  @isTest
  static void testTrg() {
    Test.startTest();
    //the test load contains a single session_objective where correct__c=false and previous_status='ACQ'
    LFLPopulateTestData.load();
    Test.stopTest();

    Program__c p = [SELECT id, status__c FROM Program__c LIMIT 1];
    p.status__c = 'Inactive';
    update p;

    SD__c sd = [
      SELECT id, status__c
      FROM sd__c
      WHERE program__c = :p.id
      LIMIT 1
    ];

    System.assert(sd.status__c == 'Inactive', 'comment goes here');
  }
}
