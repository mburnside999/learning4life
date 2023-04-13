@isTest
private class TestLFLDTDRateMaster {
  @isTest
  static void testGetDTDRateArray() {
    LFLPopulateTestData.load();
    Id clientId = [SELECT id FROM Account WHERE FirstName = 'Test FName'].Id;

    String s = LFLDTDRateMaster.getDTDRateArray(clientId, 3);
    System.assert(s != null);
  }
}
