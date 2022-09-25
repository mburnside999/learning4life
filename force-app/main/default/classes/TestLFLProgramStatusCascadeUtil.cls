@isTest
private class TestLFLProgramStatusCascadeUtil {
  @isTest
  static void testUpdateSDStatus() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    Map<Id, String> statusMap = new Map<Id, String>();

    Program__c p = [
      SELECT id, status__c
      FROM Program__c
      WHERE status__c = 'Active'
      LIMIT 1
    ];
    statusMap.put(p.id, 'Inactive');

    LFLProgramStatusCascadeUtil.updateSDStatusByMap(statusMap);

    SD__c sd = [
      SELECT id, status__c
      FROM sd__c
      WHERE program__c = :p.id
      LIMIT 1
    ];

    System.assert(sd.status__c == 'Inactive', 'expected Inactive status');
  }
  @isTest
  static void testUpdateObjectiveStatus() {
    Test.startTest();
    LFLPopulateTestData.load();
    Test.stopTest();

    Map<Id, String> statusMap = new Map<Id, String>();

    SD__c sd = [
      SELECT id, status__c
      FROM sd__c
      WHERE status__c = 'Active'
      LIMIT 1
    ];

    statusMap.put(sd.id, 'Inactive');

    LFLProgramStatusCascadeUtil.updateObjectiveStatusByMap(statusMap);

    objective__c o = [
      SELECT id, status__c
      FROM objective__c
      WHERE sd__c = :sd.id
      LIMIT 1
    ];

    System.assert(o.status__c == 'Inactive', 'comment goes here');
  }
}
