@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLTimeSeriesBatchScheduler
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLTimeSeriesBatchScheduler
 *
 */

private class TestLFLTimeSeriesBatchScheduler {
  /*******************************************************************************************************
   * @description Test schedule
   * @param void
   *
   *
   * @example
   * TestLFLTimeSeriesBatchScheduler.test();
   */

  static testMethod void test() {
    Test.startTest();
    String jobId = System.schedule(
      'testBasicScheduledApex',
      '0 30 * ? * *',
      new LFLTimeSeriesBatchScheduler()
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
