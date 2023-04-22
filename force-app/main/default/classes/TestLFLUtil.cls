@isTest
/**************************************************************
 * @author	Mike Burnside
 * @name TestLFLUtil
 * @date	2022
 * @group Learning For Life Testing
 *
 * @description	Test methods for LFLUtil
 *
 */

private class TestLFLUtil {
  /*******************************************************************************************************
   * @description Test isValidJSON method
   * @param void
   *
   *
   * @example
   * TestLFLUtil.testUtil();
   */

  @isTest
  static void testUtil() {
    Boolean response = LFLUtil.isValidJSON('{"name":"xxx"}');
    System.assert(response, 'expexted valid JSON');

    response = LFLUtil.isValidJSON('this is not JSON');
    System.assert(
      response == false,
      'this should have failed to parse as json'
    );
  }
}
