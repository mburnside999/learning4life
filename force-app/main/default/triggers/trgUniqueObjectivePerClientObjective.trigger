trigger trgUniqueObjectivePerClientObjective on client_objective__c(
  before insert
) {
  Map<Id, List<Id>> mapClientToObjective = new Map<Id, List<Id>>();

  for (Client_Objective__c co : Trigger.New) {
    System.debug('mapClientToObjective===' + mapClientToObjective);
    if (!mapClientToObjective.containsKey(co.client__c)) {
      List<Id> objlist = new List<Id>();
      objList.add(co.objective__c);
      mapClientToObjective.put(co.client__c, objList);
    } else {
      List<Id> currObjList = (List<id>) mapClientToObjective.get(co.client__c);
      currObjList.add(co.objective__c);
      mapClientToObjective.put(co.client__c, currObjList);
    }
  }
  for (Client_Objective__c co : Trigger.New) {
    List<Id> l = (List<Id>) mapClientToObjective.get(co.client__c);
    List<client_objective__c> recs = [
      SELECT id, client__c, objective__c
      FROM client_objective__c
      WHERE client__c = :co.client__c AND objective__c IN :l
    ];
    if (recs.size() > 0)
      co.objective__c.addError('objective already exists');
  }

}
