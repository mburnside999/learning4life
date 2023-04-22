/**************************************************************
 * @name L4LTimeSeriesScheduler
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	Implements Schedulable, invokes the class to create the TimeSeries
 *
 */

global class L4LTimeSeriesScheduler implements Schedulable {
  /*******************************************************************************************************
   * @name execute
   * @description Execute method
   * @param SC
   *
   * @param void
   */

  global void execute(SchedulableContext SC) {
    L4LTimeSeries l = new L4LTimeSeries();
    Integer x = l.loadCOTimeSeries();
    System.debug('timeseries list tslist.size()=' + x);
  }
}
