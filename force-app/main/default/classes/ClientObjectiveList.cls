public with sharing class ClientObjectiveList {
  @AuraEnabled(cacheable=true)
  public static List<Client_Objective__c> getClientObjectives(string clientId) {
    List<Client_Objective__c> tmpList = [
      SELECT
        Objective_Name__c,
        active__c,
        Objective__c,
        SD_Name__c,
        Program_Name__c,
        Status__c,
        Client_Objective_Notes__c,
        Stage__c,
        Area__c
      FROM Client_Objective__c
      LIMIT 10
    ];
    System.debug('xxxxx' + tmpList);

    return [
      SELECT
        active__c,
        Objective_Name__c,
        Objective__c,
        SD_Name__c,
        Program_Name__c,
        Status__c,
        Client_Objective_Notes__c,
        Stage__c,
        Area__c
      FROM Client_Objective__c
      WHERE Client__c = :clientId AND active__c = TRUE
      WITH SECURITY_ENFORCED
      ORDER BY Stage__c ASC NULLS LAST, Area__c
    ];
  }
}
