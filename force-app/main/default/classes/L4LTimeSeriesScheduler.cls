global class L4LTimeSeriesScheduler implements Schedulable {
  global void execute(SchedulableContext SC) {
    L4LTimeSeries l = new L4LTimeSeries();
    l.loadCOTimeSeries();
  }
}
