/**************************************************************
 * @author	Mike Burnside
 * @name L4LSDStageMap
 * @date	2023
 * @group Learning For Life
 *
 * @description
 *
 */

public with sharing class L4LSDStageMap {
  /*******************************************************************************************************
   * @description
   * @param clientId The Client ID
   *
   * @return A list of SDs
   *
   * @example
   */

  @AuraEnabled(cacheable=true)
  public static List<SD__c> removeDuplicates(String clientId) {
    // Query for a list of Client_Objective__c and SD__c objects
    List<Client_Objective__c> clientObjectives = [
      SELECT Id, SD_Name__c, Name, SDId__c
      FROM Client_Objective__c
      WHERE Client__c = :clientId
    ];
    List<SD__c> sdRecords = [
      SELECT
        Id,
        InUse__c,
        Name,
        Stage__c,
        Area__c,
        Program_Name__c,
        Objective_Active_Count__c,
        Description__c
      FROM SD__c
      ORDER BY Stage__c ASC NULLS LAST, Area__c
    ];

    // Create a map to store the unique SD__c records
    Map<Id, SD__c> uniqueSDRecords = new Map<Id, SD__c>();

    // Create a map to store the match count for each SD__c record
    Map<Id, Integer> sdMatchCount = new Map<Id, Integer>();

    // Iterate through the list of SD__c records
    for (SD__c sd : sdRecords) {
      // Set a flag to track whether the SD__c record has been matched to a Client_Objective__c record
      Boolean matchFound = false;

      // Iterate through the list of Client_Objective__c records
      for (Client_Objective__c co : clientObjectives) {
        // Check if the SDId__c field of the Client_Objective__c record matches the Id field of the SD__c record
        if (co.SDId__c == sd.Id) {
          // If a match is found, set the flag to true
          matchFound = true;

          // Increment the match count for the SD__c record
          if (sdMatchCount.containsKey(sd.Id)) {
            sdMatchCount.put(sd.Id, sdMatchCount.get(sd.Id) + 1);
          } else {
            sdMatchCount.put(sd.Id, 1);
          }
        }
      }

      // If the flag is still false (i.e. no match was found), add the SD__c record to the map
      if (!matchFound) {
        uniqueSDRecords.put(sd.Id, sd);
        sdMatchCount.put(sd.Id, 0);
      }

      // If the flag is true (i.e. match with ClientObj was found), update the InUse Flag and add the SD__c record to the map
      if (matchFound) {
        sd.InUse__c = true;
        uniqueSDRecords.put(sd.Id, sd);
      }
    }

    // Convert the map of unique SD__c records back into a list
    List<SD__c> uniqueSDList = new List<SD__c>(uniqueSDRecords.values());

    // Set the match count for each SD__c record in the list
    for (SD__c sd : uniqueSDList) {
      sd.Match_Count__c = sdMatchCount.get(sd.Id);
    }
    // Do something with the list of unique SD__c records
    System.debug(uniqueSDList);

    return uniqueSDList;
  }
}
