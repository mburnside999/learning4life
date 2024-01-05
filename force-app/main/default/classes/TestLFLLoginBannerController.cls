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
   * @description Test testGetBannerDetail method
   * @param void
   *
   *
   * @example
   * TestLFLLoginBannerController.testGetBannerDetail();
   */

  @isTest
  static void testGetBannerDetail() {
    Test.startTest();
    Boolean flag = false;
    LFL_Notification_Banner__mdt welcome = LFLLoginBannerController.getBannerDetail(
      flag
    );
    System.assert(welcome != null, 'Must have a LFL_Notification_Banner__mdt');

    flag = true;
    LFL_Notification_Banner__mdt hidden = LFLLoginBannerController.getBannerDetail(
      flag
    );
    System.assert(hidden == null, 'Must be hidden');
  }
}
