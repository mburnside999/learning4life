public class LFLAggregateResultIterable4 implements Iterable<AggregateResult> {
  public Iterator<AggregateResult> iterator() {
    List<AggregateResult> aggresults = [
      SELECT
        objective__r.sd__c,
        objective__r.sd__r.Name sdname,
        count(id) ssrecords,
        count_distinct(session__c) sessions,
        count_distinct(session__r.client__c) clients,
        sum(TotalAcquiredCorrect__c) correct,
        sum(TotalAcquiredInCorrect__c) incorrect,
        sum(TotalAcquirednonREsponsive__c) noresponsive,
        Sum(TotalAcquiredprompted__c) prompted
      FROM session_Statistics__c
      WHERE objective__c != NULL
      GROUP BY objective__r.sd__c, objective__r.sd__r.Name
    ];
    return new LFLAggregateResultIterator(aggresults);
  }
}
