@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestTrgUniqueObjectivePerClientObjective
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test trigger TrgUniqueObjectivePerClientObjective
 *
 */

private class TestTrgUniqueObjectivePerClientObjective {
  /*******************************************************************************************************
   * @description Test DuplicateObjectivePrevention
   * @param void
   *
   *
   * @example
   * TestTrgUniqueObjectivePerClientObjective.testDuplicateObjectivePrevention();
   */

  @isTest
  static void testDuplicateObjectivePrevention() {
    Test.startTest();
    LFLPopulateTestData.load();
    String RecTypeId = [
      SELECT Id
      FROM RecordType
      WHERE Name = 'LFL Client' AND SobjectType = 'Account'
    ]
    .Id;
    Account newAccount1 = new Account(
      RecordTypeID = RecTypeId,
      FirstName = 'XX',
      LastName = 'YY',
      PersonHomePhone = '1234567',
      PersonMobilePhone = '12345678'
    );
    insert newAccount1;

    Test.stopTest();

    Client_Objective__c co = [
      SELECT id, client__c, objective__c, status__c
      FROM client_objective__c
      LIMIT 1
    ];
    co.status__c = 'ACQ';

    Client_Objective__c co1 = new Client_Objective__c(
      client__c = newAccount1.Id,
      objective__c = co.objective__c,
      status__c = 'ACQ'
    );

    Client_Objective__c co2 = new Client_Objective__c(
      client__c = newAccount1.Id,
      objective__c = co.objective__c,
      status__c = 'CIP'
    );

    List<client_objective__c> lco = new List<client_objective__c>();
    lco.add(co);
    lco.add(co1);
    lco.add(co2);

    Boolean preventedDuplicate = false;
    try {
      insert lco; //insert a duplicate objective
    } catch (Exception e) {
      preventedDuplicate = true; //trigger detects duplicates objectives
    }
    System.assert(preventedDuplicate == true);
  }
}
