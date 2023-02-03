public with sharing class L4LNebulaComponentController {
  private static String nebulaId;

  @AuraEnabled
  public static void setupCache() {
    if (!Cache.Session.contains('IsNewLoad')) {
      Cache.Session.put('IsNewLoad', true);
    }
  }

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
  @AuraEnabled
  public static void logInfo(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.info(message + ' record=' + recordId).setRecordId(recordId);
    saveNebulaLog();
  }

  @AuraEnabled
  public static void logFine(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.fine(message + ' record=' + recordId).setRecordId(recordId);
    saveNebulaLog();
  }

  @AuraEnabled
  public static void logError(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.error('ERROR: ' + message + ' record=' + recordId)
      .setRecordId(recordId);
    saveNebulaLog();
  }

  @AuraEnabled
  public static void logDebug(
    String recordId,
    String message,
    String scenario,
    String tag
  ) {
    Logger.setScenario(scenario);
    Logger.debug(message + ' recordId=' + recordId)
      .setRecordId(recordId)
      .addTag(tag);
    saveNebulaLog();
  }

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
