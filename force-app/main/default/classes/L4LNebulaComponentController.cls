/**************************************************************
 * @author	Mike Burnside
 * @name L4LNebulaComponentController
 * @date	2023
 * @group Learning For Life
 *
 * @description
 *
 */

public with sharing class L4LNebulaComponentController {
  private static String nebulaId;

  /*******************************************************************************************************
   * @description set up caching
   * @param recordId The Session ID
   *
   * @return Session status
   *
   * @example
   * String status=L4LController.getSessionStatus(recordId);
   */
  @AuraEnabled
  public static void setupCache() {
    if (!Cache.Session.contains('IsNewLoad')) {
      Cache.Session.put('IsNewLoad', true);
    }
  }

  /*******************************************************************************************************
   * @description helper for logging Warnings
   * @param recordId The related record
   * @param message The message text
   * @param scenario The logging scanario
   * @param tag The logging tag
   *
   * @return void
   *
   * @example
   */

  @AuraEnabled
  public static void logWarning(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.warn(message + ' record=' + recordId).setRecordId(recordId);
    saveNebulaLog();
  }

  /*******************************************************************************************************
   * @description helper for logging Info
   * @param recordId The related record
   * @param message The message text
   * @param scenario The logging scanario
   * @param tag The logging tag
   *
   * @return void
   *
   * @example
   */

  @AuraEnabled
  public static void logInfo(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.info(message).setRecordId(recordId).addTag(tag);
    saveNebulaLog();
  }

  /*******************************************************************************************************
   * @description helper for logging Fine
   * @param recordId The related record
   * @param message The message text
   * @param scenario The logging scanario
   * @param tag The logging tag
   *
   * @return void
   *
   * @example
   */

  @AuraEnabled
  public static void logFine(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.fine(message).setRecordId(recordId).addTag(tag);
    saveNebulaLog();
  }

  /*******************************************************************************************************
   * @description helper for logging Errors
   * @param recordId The related record
   * @param message The message text
   * @param scenario The logging scanario
   * @param tag The logging tag
   *
   * @return void
   *
   * @example
   */

  @AuraEnabled
  public static void logError(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.error(message).setRecordId(recordId);
    saveNebulaLog();
  }

  /*******************************************************************************************************
   * @description helper for logging Debug
   * @param recordId The related record
   * @param message The message text
   * @param scenario The logging scanario
   * @param tag The logging tag
   *
   * @return void
   *
   * @example
   */

  @AuraEnabled
  public static void logDebug(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.debug(message).setRecordId(recordId).addTag(tag);
    saveNebulaLog();
  }

  /*******************************************************************************************************
   * @description save Nebula log
   *
   * @return void
   *
   * @example
   */

  private static void saveNebulaLog() {
    Boolean isNewLoad = (Boolean) Cache.Session.get('IsNewLoad');
    if (isNewLoad) {
      nebulaId = Logger.getTransactionId();
      Cache.Session.put('nebulaId', Logger.getTransactionId());
      Cache.Session.put('IsNewLoad', false);
      Logger.saveLog();
    } else {
      String parentNebulaId = (String) Cache.Session.get('nebulaId');
      Logger.setParentLogTransactionId(parentNebulaId);
      Logger.saveLog();
    }
  }
}
