@isTest
private class TestCascadeSDStatusTrg {
  @isTest
  static void testTrg() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    sd__c sd = [
      SELECT id, status__c
      FROM sd__c
      WHERE status__c = 'Active'
      LIMIT 1
    ];
    sd.status__c = 'Inactive';
    update sd;

    objective__c o = [
      SELECT id, status__c
      FROM objective__c
      WHERE sd__c = :sd.id
      LIMIT 1
    ];

    System.assert(o.status__c == 'Inactive', 'comment goes here');
  }
}
