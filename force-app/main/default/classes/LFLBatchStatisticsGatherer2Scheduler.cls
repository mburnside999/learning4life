/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGatherer2Scheduler
 * @date	2023
 * @group Learning For Life
 *
 * @description	Schedule batch
 *
 */

global class LFLBatchStatisticsGatherer2Scheduler implements Schedulable {
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
      new LFLBatchStatisticsGatherer2(),
      10000
    );
  }
}
