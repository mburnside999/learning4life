/**************************************************************
 * @name L4LTimeSeriesScheduler
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	implements Schedulable the class scheduled to create the TimeSeries
 *
 */
global class L4LTimeSeriesScheduler implements Schedulable {
  global void execute(SchedulableContext SC) {
    L4LTimeSeries l = new L4LTimeSeries();
    Integer x = l.loadCOTimeSeries();
    System.debug('timeseries list tslist.size()=' + x);
  }
}
