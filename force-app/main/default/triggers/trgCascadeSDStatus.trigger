/**************************************************************
 * @name trgCascadeSDStatus
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description Update Trigger on SD__c
 * Supports the pushing of Status values down the hierarchy of Programs--< SD--< Objectives
 * Valid status values are Active|Inactive|Draft
 * So When a SD status is changed we push those changes down the hierarchy
 * This trigger passes a Map of changed status values to helpler class lflProgramStatusCascadeUtil
 * @see lflProgramStatusCascadeUtil
 */

trigger trgCascadeSDStatus on SD__c(after update) {
  Map<Id, String> statusMap = new Map<Id, String>();

  for (Id sid : Trigger.newMap.keySet()) {
    if (
      Trigger.oldMap.get(sid).status__c != Trigger.newMap.get(sid).status__c
    ) {
      statusMap.put(sid, Trigger.newMap.get(sid).status__c);
    }
  }
  if (!statusMap.isEmpty()) {
    lflProgramStatusCascadeUtil.updateObjectiveStatusByMap(statusMap);
  }

}
