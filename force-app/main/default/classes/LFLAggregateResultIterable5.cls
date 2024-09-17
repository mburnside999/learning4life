public class LFLAggregateResultIterable5 implements Iterable<AggregateResult> {
  public Iterator<AggregateResult> iterator() {
    List<AggregateResult> aggresults = [
      SELECT
        objective__r.sd__r.program__c,
        objective__r.sd__r.program__r.Name progname,
        count(id) ssrecords,
        count_distinct(session__c) sessions,
        count_distinct(session__r.client__c) clients,
        sum(TotalAcquiredCorrect__c) correct,
        sum(TotalAcquiredInCorrect__c) incorrect,
        sum(TotalAcquirednonREsponsive__c) noresponsive,
        Sum(TotalAcquiredprompted__c) prompted,
        Min(Session__r.Date__c) earliest_session_date,
        Max(Session__r.Date__c) latest_session_date
      FROM session_Statistics__c
      WHERE objective__c != NULL AND lastmodifieddate = LAST_N_DAYS:500
      GROUP BY objective__r.sd__r.program__c, objective__r.sd__r.program__r.Name
    ];
    return new LFLAggregateResultIterator(aggresults);
  }
}
