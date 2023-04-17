@isTest
private class TestL4LStagesByArea {
  @isTest
  static void testGetSDUsage() {
    Test.startTest();
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;
    Test.stopTest();

    String sdJSONList = L4LStagesByArea.getSDUsage(clientId);

    System.assert(sdJSONList!=null, 'Expected valid list of SDs');
  }
}