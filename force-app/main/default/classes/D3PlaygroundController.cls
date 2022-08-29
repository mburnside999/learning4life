public with sharing class D3PlaygroundController {
  @AuraEnabled(Cacheable=true)
  public static List<Account> getAccounts() {
    return [
      SELECT Id, Name, NumberOfEmployees, AnnualRevenue
      FROM Account
      WHERE NumberOfEmployees > 0
      LIMIT 20
    ];
  }

  @AuraEnabled(Cacheable=true)
  public static List<AggregateResult> getAvgEmployeesByType() {
    return [
      SELECT
        Type,
        Avg(numberofemployees) AvgEmployees,
        Max(numberofEmployees) MaxEmployees
      FROM account
      GROUP BY type
      LIMIT 20
    ];
  }

  @AuraEnabled(Cacheable=true)
  public static List<Program__c> getProgramsAndSds() {
    return [
      SELECT
        Id,
        Name,
        (SELECT id, name, program__r.name, description__c FROM sds__r)
      FROM Program__c
    ];
  }

  @AuraEnabled(Cacheable=true)
  public static List<AggregateResult> getClientObjectivesSDCount(
    String clientId
  ) {
    return [
      SELECT
        objective__r.sd__r.program__R.name progname,
        objective__r.sd__r.name sdname,
        count(id) sdcount
      FROM client_objective__c
      WHERE client__c = :clientId
      GROUP BY objective__r.sd__r.program__R.name, objective__r.sd__r.name
    ];
  }
}
