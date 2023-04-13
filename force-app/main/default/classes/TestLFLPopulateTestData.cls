@isTest
private class TestLFLPopulateTestData {
  @isTest
  static void testLoad() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    Integer a = [SELECT COUNT() FROM client_objective__c];
    Integer sd = [SELECT COUNT() FROM SD__c];
    Integer o = [SELECT COUNT() FROM Objective__c];
    Integer p = [SELECT COUNT() FROM program__c];
    Integer so = [SELECT COUNT() FROM session_obj__c];
    Integer s = [SELECT COUNT() FROM session__c];

    System.assert(a > 0, 'Expected records were created.');
    System.assert(sd > 0, 'Expected records were created.');
    System.assert(o > 0, 'Expected records were created.');
    System.assert(p > 0, 'Expected records were created.');
    System.assert(so > 0, 'Expected records were created.');
    System.assert(s > 0, 'Expected records were created.');
  }
}
