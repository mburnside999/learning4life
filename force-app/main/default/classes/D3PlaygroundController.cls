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
}
