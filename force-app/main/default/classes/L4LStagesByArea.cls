public with sharing class L4LStagesByArea {
  @AuraEnabled(cacheable=false)
  public static String getSDUsage(String clientId) {
    // Query for a list of Client_Objective__c and SD__c objects
    List<Client_Objective__c> clientObjectives = [
      SELECT Id, SD_Name__c, Name, SDId__c, Status__c
      FROM Client_Objective__c
      WHERE Client__c = :clientId
    ];
    List<SD__c> sdRecords = [
      SELECT
        Id,
        Name,
        Stage__c,
        Area__c,
        Program_Name__c,
        Objective_Active_Count__c,
        Description__c
      FROM SD__c
      WITH SECURITY_ENFORCED
      ORDER BY Stage__c ASC NULLS LAST, Area__c
    ];

    // Create a map to store the unique SD__c records
    Map<Id, XSD> xuniqueSDRecords = new Map<Id, XSD>();

    // Create a map to store the match count for each SD__c record
    Map<Id, Integer> xsdMatchCount = new Map<Id, Integer>();

    // Iterate through the list of SD__c records
    for (SD__c sd : sdRecords) {
      XSD xsd = new XSD();
      xsd.sd = sd;

      // Set a flag to track whether the SD__c record has been matched to a Client_Objective__c record
      Boolean matchFound = false;
      Boolean CABfound = false;

      // Iterate through the list of Client_Objective__c records
      for (Client_Objective__c co : clientObjectives) {
        // Check if the SDId__c field of the Client_Objective__c record matches the Id field of the SD__c record
        if (co.SDId__c == sd.Id) {
          // If a match is found, set the flag to true
          matchFound = true;

          // Increment the match count for the SD__c record
          if (xsdMatchCount.containsKey(xsd.sd.Id)) {
            xsdMatchCount.put(xsd.sd.Id, xsdMatchCount.get(xsd.sd.Id) + 1);
          } else {
            xsdMatchCount.put(xsd.sd.Id, 1);
          }
          // Check if the Status__c of the Client_Objective__c record is 'CAB', and set the CABfound flag
          if (co.Status__c == 'CAB') {
            CABfound = true;
          }
        }
      }

      // If the flag is still false (i.e. no match was found), add the SD__c record to the map
      if (!matchFound) {
        xuniqueSDRecords.put(xsd.sd.Id, xsd);
        xsdMatchCount.put(xsd.sd.Id, 0);
        xsd.CABStatus = 'false';
      }
      // If the flag is true (i.e. match with ClientObj was found), update the InUse Flag and add the SD__c record to the map
      if (matchFound) {
        xsd.CABStatus = 'true';
        xuniqueSDRecords.put(xsd.sd.Id, xsd);

        if (CABfound) {
          xsd.CABStatus = 'CorrectatBaseline';
        } else {
          xsd.CABStatus = 'true';
        }
      }
    }

    // Convert the map of unique SD__c records back into a list
    List<XSD> xuniqueSDList = new List<XSD>(xuniqueSDRecords.values());

    for (XSD xsd : xuniqueSDList) {
      xsd.sd.Match_Count__c = xsdMatchCount.get(xsd.sd.Id);
    }

    return JSON.serialize(xuniqueSDList);
  }

  public class XSD {
    public SD__C sd { get; set; }
    public String CABStatus { get; set; }
  }
}