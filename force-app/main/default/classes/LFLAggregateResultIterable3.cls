public class LFLAggregateResultIterable3 implements Iterable<AggregateResult> {
  public Iterator<AggregateResult> iterator() {
    List<AggregateResult> aggresults = [
      SELECT
        objective__c,
        objective__r.name objname,
        count(id) ssrecords,
        count_distinct(session__c) sessions,
        sum(TotalAcquiredCorrect__c) correct,
        sum(TotalAcquiredInCorrect__c) incorrect,
        sum(TotalAcquirednonREsponsive__c) noresponsive,
        Sum(TotalAcquiredprompted__c) prompted
      FROM session_Statistics__c
      WHERE objective__c != NULL
      GROUP BY objective__c, objective__r.name
    ];
    return new LFLAggregateResultIterator(aggresults);
  }
}
