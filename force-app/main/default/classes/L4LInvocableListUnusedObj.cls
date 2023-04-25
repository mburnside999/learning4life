/**************************************************************
 * @author	Mike Burnside
 * @name L4LInvocableListUnusedObj
 * @date	2022
 * @group Learning For Life
 *
 * @description Invocable methods used by Flow to list unused objectives
 *
 */

public class L4LInvocableListUnusedObj {
  /*******************************************************************************************************
   * @description Return unused objectives
   * @param inputVariables List of Input Variables
   *
   * @return
   *
   * @example
   */

  @InvocableMethod(label='Remove Records')
  public static List<List<Objective__c>> RemoveRecords(
    List<InputVariables> inputVariables
  ) {
    // Get Input Variables

    String SCENARIO = 'L4LInvocableListUnusedObj - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'L4LInvocableListUnusedObj.RemoveRecords()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Objective__c> passedInObjs = inputVariables.get(0).getSDObj;
    List<Client_Objective__c> passedInClientObjs = inputVariables.get(0)
      .getClientObj;

    // Define Output Variables

    List<Objective__c> filteredRecords = new List<Objective__c>();
    List<List<Objective__c>> lstfilteredRecords = new List<List<Objective__c>>();

    {
      // Perform Logic
      Set<Id> recordIdsToRemove = new Set<Id>();

      // Build a set of record IDs from getClientObj
      for (Client_Objective__c client : passedInClientObjs) {
        Id recordId = (Id) client.get('Objective__c');
        recordIdsToRemove.add(recordId);
      }

      // Remove any records from getSDObj where the record ID is in the set of record IDs

      for (Objective__c sd : passedInObjs) {
        Id recordId = (Id) sd.get('Id');
        if (!recordIdsToRemove.contains(recordId)) {
          filteredRecords.add(sd);
        }
      }

      //  return filteredRecords;
    }

    //  return filteredRecords; in order to return as a collection needs to be a List of List hence...
    lstfilteredRecords.add(filteredRecords);
    return lstfilteredRecords;
  }

  public class InputVariables {
    @InvocableVariable
    public List<Client_Objective__c> getClientObj;

    @InvocableVariable
    public List<Objective__c> getSDObj;
  }

  public class ReturnVariables {
    @InvocableVariable
    // public List<Objective__c> filteredRecords;
    public List<List<Objective__c>> lstfilteredRecords;
  }
}
