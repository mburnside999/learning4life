@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLLoginBannerController
 * @date	2023
 * @group Learning For Life Testing
 *
 * @description	Test methods for TestLFLLoginBannerController
 *
 */
public with sharing class TestLFLLoginBannerController {
  
    /*******************************************************************************************************
   * @description Test getHighAndLowBoundaries method
   * @param void
   *
   *
   * @example
   * TestL4LSessionStatsController.testgetD3StatusYAxisScale();
   */

  @isTest
  static void testGetBannerDetail() {
    Test.startTest();

    
    LFLLoginBannerController.getBannerDetail();

    LFL_Notification_Banner__mdt welcome =LFL_Notification_Banner__mdt.getInstance(
      'Welcome'
    );

    System.assert(
      welcome != null,
      'Must have a LFL_Notification_Banner__mdt'
    );
  }
    

}