global class L4LTimeSeriesScheduler implements Schedulable {
  global void execute(SchedulableContext SC) {
    L4LTimeSeries l = new L4LTimeSeries();
    Integer x = l.loadCOTimeSeries();
    System.debug('timeseries list tslist.size()=' + x);
  }
}
