/**************************************************************
 * @author	Mike Burnside
 * @name LFLBatchStatisticsGatherer3Scheduler
 * @date	2023
 * @group Learning For Life
 *
 * @description	Schedule batch
 *
 */

global class LFLBatchStatisticsGatherer3Scheduler implements Schedulable {
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
      new LFLBatchStatisticsGatherer3(),
      1000
    );
  }
}
