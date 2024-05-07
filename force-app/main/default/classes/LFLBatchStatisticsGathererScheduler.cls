/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGathererScheduler
 * @date	2023
 * @group Learning For Life
 *
 * @description	Schedule batch
 *
 */

global class LFLBatchStatisticsGathererScheduler implements Schedulable {
  /*******************************************************************************************************
   * @name execute
   * @description Execute method
   * @param SC
   *
   * @param void
   */

  @ReadOnly
  global void execute(SchedulableContext SC) {
    Id batchInstanceId = Database.executeBatch(
      new LFLBatchStatisticsGatherer(),
      10000
    );
  }
}
