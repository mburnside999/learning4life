public class LFLAggregateResultIterable implements Iterable<AggregateResult> {
  public Iterator<AggregateResult> iterator() {
    List<AggregateResult> aggresults = [
      SELECT
        client_objective__r.client__c client,
        min(RunID__c) minRunId,
        max(RunID__c) maxRunId,
        max(TS_load_datetime__c) maxTS,
        min(TS_load_datetime__c) minTS,
        count(objective__c) objIds,
        count_distinct(client_objective__c) distinctCOs,
        count_distinct(client__c) distinctClients
      FROM client_objective_timeseries__c
      WHERE
        status__c = 'ACQ'
        //AND client_objective__r.client__r.lastname > 'M'
        //AND client_objective__r.client__r.lastname > 'Q'
        AND client_objective__r.client__r.current__c = TRUE
      GROUP BY client_objective__r.client__c
    ];
    return new LFLAggregateResultIterator(aggresults);
  }
}
