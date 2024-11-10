public with sharing class SessionDAO {
  public SessionDAO() {
  }

  public static List<Session__c> getAllSessions() {
    return [SELECT id, client__c, name, date__c, status__c FROM session__c];
  }

  public static List<Session__c> getAllSessionsForAClient(Id clientId) {
    return [
      SELECT id, client__c, name, date__c, status__c
      FROM session__c
      WHERE client__c = :clientId
    ];
  }
}
