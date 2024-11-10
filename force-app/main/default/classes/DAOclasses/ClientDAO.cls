public with sharing class ClientDAO {
  public static final String RECORDTYPEID;

  static {
    RECORDTYPEID = [
      SELECT Id
      FROM RecordType
      WHERE Name = 'LFL Client' AND SobjectType = 'Account'
    ]
    .Id;
  }

  public ClientDAO() {
  }

  public static Account getClientById(Id clientId) {
    return [
      SELECT Id, FirstName, LastName, Current__c
      FROM Account
      WHERE Id = :clientId
      LIMIT 1
    ];
  }

  public static List<Account> getAllCurrentClients() {
    return [
      SELECT Id, FirstName, LastName, Current__c, First_Session__c
      FROM Account
      WHERE RecordTypeID = :RECORDTYPEID AND current__c = TRUE
    ];
  }
}
