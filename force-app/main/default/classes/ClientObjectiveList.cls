/**************************************************************
 * @name ClientObjectiveList
 * @author Mike De Hennin
 *
 * @date	2022
 * @group Learning For Life
 *
 * @description Client Objective operations
 *
 */

public with sharing class ClientObjectiveList {
  /*******************************************************************************************************
   * @description
   * @param clientId The Client ID
   *
   * @return List of Client Objectives
   *
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static List<Client_Objective__c> getClientObjectives(string clientId) {
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
