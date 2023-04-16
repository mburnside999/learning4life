/**************************************************************
 * @name trgCascadeProgramStatus
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description
 *
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
