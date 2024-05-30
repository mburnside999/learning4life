public class LFLAggregateResultIterable implements Iterable<AggregateResult> {
  public Iterator<AggregateResult> iterator() {
    List<AggregateResult> aggresults = [
      SELECT
        session__r.client__c client,
        objective__c objective,
        correct__c correct,
        max(createddate) createddate,
        max(session__r.name) sessionname
      FROM session_obj__c
      WHERE createddate = LAST_N_DAYS:14 AND session__r.status__c = 'Closed'
      GROUP BY session__r.client__c, objective__c, correct__c
      ORDER BY objective__c
    ];
    return new LFLAggregateResultIterator(aggresults);
  }
}
