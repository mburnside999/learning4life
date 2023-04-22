/**************************************************************
 * @name public with sharing class LFLUtil
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description Utility
 *
 */

public with sharing class LFLUtil {
  /*******************************************************************************************************
   * @name isValidJSON
   * @description Parse and validate JSON
   *
   * @param String, a JSON string to be validated
   * @return Boolean, whether the string is valid JSON or not
   * @example
   * Boolean isValid=LFLUtil.isValidJSON(jsonStr);
   */

  public static Boolean isValidJSON(String jsonstr) {
    Boolean isValid = false;
    String message = jsonstr;
    try {
      Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(
        message
      );
      isValid = true;
    } catch (JSONException e) {
      System.debug(e.getMessage());
      return false;
    }
    System.debug('isValid=' + isValid);
    return true;
  }
}
