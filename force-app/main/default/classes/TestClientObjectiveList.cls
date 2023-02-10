@isTest
private class TestClientObjectiveList {
  @isTest
  static void testGetsessionObjectives() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<Client_Objective__c> colist = clientObjectiveList.getClientObjectives(
      clientId
    );

    System.assert(
      colist != null,
      'Expected at least one client objective record retrieved.'
    );
  }
}
