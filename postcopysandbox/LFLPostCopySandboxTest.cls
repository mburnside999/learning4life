@isTest
class LFLPostCopySandboxTest {
  @isTest
  static void myUnitTest() {
    Test.startTest();
    Test.testSandboxPostCopyScript(
      new LFLPostCopySandbox(),
      UserInfo.getOrganizationId(),
      UserInfo.getOrganizationId(),
      UserInfo.getOrganizationName()
    );

    Test.stopTest();
    Integer pcount = [SELECT COUNT() FROM Program__c];
    Integer scount = [SELECT COUNT() FROM SD__c];
    Integer ocount = [SELECT COUNT() FROM Objective__c];

    System.assert(pcount > 5, 'expected 5+');
    System.assert(scount > 500, 'expected 500+');
    System.assert(ocount > 5000, 'expected 5000+');
  }
}
