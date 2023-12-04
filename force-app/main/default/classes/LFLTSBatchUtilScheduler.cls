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
