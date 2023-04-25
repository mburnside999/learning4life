/**************************************************************
 * @name LFLProgramStatusCascadeUtil
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 * @description Util class.
 * Methods for pushing of Status values down the hierarchy of Programs--< SD--< Objectives.
 * Status values are Active|Inactive|Draft
 */

public class LFLProgramStatusCascadeUtil {
  /*******************************************************************************************************
   * @name updateSDStatusByMap
   * @description Push changed Program status values to related SDs.
   * Invoked by Program__c trigger: trgCascadeProgramStatus.
   * @return void
   * @param statusMap Map of changed Program status values
   * @example
   */

  public static void updateSDStatusByMap(Map<id, string> statusMap) {
   
    String SCENARIO = 'Manage Hierarchy - Update SD status - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'updateSDStatusByMap()',
      SCENARIO,
      'next-gen-nebula-apex'
    );
    L4LNebulaComponentController.logDebug(
      null,
      'updateSDStatusByMap() statusMap='+statusMap,
      SCENARIO,
      'next-gen-nebula-apex'
    );
    
    List<sd__c> sdlist = new List<sd__c>();
    List<sd__c> sdupdatelist = new List<sd__c>();

    sdlist = [
      SELECT id, status__c, program__c
      FROM sd__C
      WHERE program__c IN :statusMap.keySet()
    ];

    L4LNebulaComponentController.logDebug(
      null,
      'updateSDStatusByMap() sdList='+sdList,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    for (sd__c sd : sdlist) {
      String status = statusMap.get(sd.program__c);
      sd.status__c = status;
      sdupdatelist.add(sd);
    }
    update sdupdatelist;
  }

  /*******************************************************************************************************
   * @name updateObjectiveStatusByMap
   * @description Push changed SD status values to related Objectives
   * Invoked by SD__c trigger: trgCascadeSDStatus
   * @param statusMap Map of changed SD status values
   * @return void
   * @example
   */

  public static void updateObjectiveStatusByMap(Map<id, string> statusMap) {
   
    String SCENARIO = 'Manage Hierarchy - Update Objective status - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'updateObjectiveStatusByMap()',
      SCENARIO,
      'next-gen-nebula-apex'
    );
   
    L4LNebulaComponentController.logDebug(
      null,
      'updateObjectiveStatusByMap() statusMap='+statusMap,
      SCENARIO,
      'next-gen-nebula-apex'
    );

  

    List<objective__c> olist = new List<objective__c>();
    List<objective__c> oupdatelist = new List<objective__c>();

    olist = [
      SELECT id, status__c, sd__c
      FROM objective__C
      WHERE sd__c IN :statusMap.keySet()
    ];
   
    L4LNebulaComponentController.logDebug(
      null,
      'updateSDStatusByMap() olist='+olist,
      SCENARIO,
      'next-gen-nebula-apex'
    );


    for (objective__c o : olist) {
      String status = statusMap.get(o.sd__c);
      o.status__c = status;
      oupdatelist.add(o);
    }
    update oupdatelist;
  }
}
