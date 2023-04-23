/**************************************************************
 * @name trgCascadeProgramStatus
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description Update Trigger on Program__c
 * Supports the pushing of Status values down the hierarchy of Programs--< SD--< Objectives
 * Valid status values are Active|Inactive|Draft
 * So When a Program status is changed we push those changes down the hierarchy
 * This trigger passes a Map of changed status values to helpler class lflProgramStatusCascadeUtil
 * @see lflProgramStatusCascadeUtil
 */
trigger trgCascadeProgramStatus on Program__c(after update) {
  Map<Id, String> statusMap = new Map<Id, String>();
  for (Id pid : Trigger.newMap.keySet()) {
    if (
      Trigger.oldMap.get(pid).status__c != Trigger.newMap.get(pid).status__c
    ) {
      statusMap.put(pid, Trigger.newMap.get(pid).status__c);
    }
  }
  if (!statusMap.isEmpty()) {
    lflProgramStatusCascadeUtil.updateSDStatusByMap(statusMap);
  }
}
