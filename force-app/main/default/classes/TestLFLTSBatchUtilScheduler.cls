@isTest
private class TestLFLTSBatchUtilScheduler {
  /*******************************************************************************************************
   * @description Test schedule
   * @param void
   *
   *
   * @example
   * TestLFLTSBatchUtilScheduler.test();
   */

  static testMethod void test() {
    Test.startTest();
    String jobId = System.schedule(
      'testBasicScheduledApex',
      '0 30 * ? * *',
      new LFLTSBatchUtilScheduler()
    );

    CronTrigger ct = [
      SELECT Id, CronExpression, TimesTriggered, NextFireTime
      FROM CronTrigger
      WHERE id = :jobId
    ];

    System.assertEquals('0 30 * ? * *', ct.CronExpression);

    Test.stopTest();
  }
}
