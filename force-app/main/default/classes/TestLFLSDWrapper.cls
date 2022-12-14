@isTest
private class TestLFLSDWrapper {
  @isTest
  static void testcomparison() {
    Test.startTest();
    sd__c sd1 = new sd__C(name = 'bbbb');
    sd__c sd2 = new sd__C(name = 'aaaa');
    sd__c sd3 = new sd__C(name = 'bbbb');
    sd__c sd4 = new sd__C(name = 'cccc');
    Test.stopTest();

    List<LFLSDWrapper> wrapperlist = new List<LFLSDWrapper>();
    wrapperlist.add(new LFLSDWrapper(sd1));
    wrapperlist.add(new LFLSDWrapper(sd2));
    wrapperlist.add(new LFLSDWrapper(sd3));
    wrapperlist.add(new LFLSDWrapper(sd4));

    wrapperlist.sort();

    System.assert(wrapperlist[0].sd.name == 'aaaa', 'sorted incorrectly');

    try {
      wrapperlist.add(new LFLSDWrapper(null));
    } catch (System.NullPointerException e) {
      System.assert(e.getMessage() != null, e.getMessage());
    }
  }
}
