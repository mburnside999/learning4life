@isTest
private class TestLFLInvocableListUnusedObj {
  @isTest
  static void test1() {
    Test.startTest();
    LFLPopulateTestData.load();
    List<Objective__c> objList = [SELECT id FROM objective__c];
    List<Client_Objective__c> clientobjList = [
      SELECT id, objective__c
      FROM client_objective__c
    ];
    Test.stopTest();

    List<L4LInvocableListUnusedObj.InputVariables> liv = new List<L4LInvocableListUnusedObj.InputVariables>();

    L4LInvocableListUnusedObj.InputVariables iv = new L4LInvocableListUnusedObj.InputVariables();
    iv.getClientObj = clientobjList;
    iv.getSDObj = objList;

    liv.add(iv);

    List<List<Objective__c>> res = L4LInvocableListUnusedObj.RemoveRecords(liv);

    System.assert(res[0].size() > 0);
  }
}
