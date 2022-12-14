public with sharing class LFLUtil {
  public LFLUtil() {
  }

  //Utility method to parse and validate JSON
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
