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
