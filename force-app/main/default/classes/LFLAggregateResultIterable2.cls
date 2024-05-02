public class LFLAggregateResultIterable2 implements Iterable<AggregateResult> {
  public Iterator<AggregateResult> iterator() {
    List<AggregateResult> aggresults = [
      SELECT
        client__r.Id client,
        client__r.lastname clientname,
        sum(Session_Length__c) totalduration,
        min(Date__c) mindate,
        max(Date__c) maxdate,
        count(Id) sessions
      FROM Session__c
      WHERE status__c = 'Closed' AND client__r.current__c = TRUE
      GROUP BY client__r.Id, client__r.lastname
    ];
    return new LFLAggregateResultIterator(aggresults);
  }
}
