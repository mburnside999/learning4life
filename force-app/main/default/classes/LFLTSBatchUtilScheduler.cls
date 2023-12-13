/**************************************************************
 * @author	Mike Burnside
 * @name LFLTSBatchUtilScheduler
 * @date	2023
 * @group Learning For Life
 *
 * @description	Schedule batch integrity checks on CO Timeseries.
 *
 */

global class LFLTSBatchUtilScheduler implements Schedulable {
  /*******************************************************************************************************
   * @name execute
   * @description Execute method
   * @param SC
   *
   * @param void
   */

  global void execute(SchedulableContext SC) {
    Id batchInstanceId = Database.executeBatch(new LFLTSBatchUtil(), 10000);
  }
}
