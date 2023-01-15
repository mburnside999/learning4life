@isTest
private class TestL4LSDStageMap {
  @isTest
  static void testRemoveDuplicates() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    List<SD__c> sdList = L4LSDStageMap.removeDuplicates(clientId);

    System.assert(sdList.size() > 0, 'Expected valid list of SDs');
  }
}
