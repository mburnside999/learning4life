public with sharing class L4LSessionStatsController {
  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getSessionStats(String searchKey) {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug('Apex:getSessionStats() recordId=' + searchKey)
      .setRecordId(searchKey)
      .addTag('L4LController.getSessionStats()')
      .addTag('logit()');

    List<Session_Statistics__c> results = new List<Session_Statistics__c>(
      [
        SELECT
          id,
          name,
          objective__r.name,
          session__r.name,
          previous_status__c,
          icon__c,
          iconstr__c,
          totalacquiredcorrect__c,
          totalacquiredincorrect__c,
          totalacquiredprompted__c,
          Percent_Correct__c,
          Program_Name__c
        FROM session_statistics__c
        WHERE session__c = :searchKey
        ORDER BY program_name__c
      ]
    );

    Logger.debug('Apex:getSessionStats() results=' + results)
      .setRecordId(searchKey)
      .addTag('L4LController.getSessionStats()')
      .addTag('logit()');
    Logger.saveLog();

    return results;
  }
  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getD3Stats(
    String clientId,
    Boolean showAcquired
  ) {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug(
        'Apex:getD3Stats() recordId=' +
        clientId +
        ' showAcquired=' +
        showAcquired
      )
      .setRecordId(clientId)
      .addTag('L4LController.getD3Stats()')
      .addTag('logit()');

    // List<Session_Statistics__c> results = new List<Session_Statistics__c>();
    // if (showAcquired) {
    //   results = [
    //     SELECT
    //       session__r.name,
    //       session__r.client__c,
    //       session__r.client__r.name,
    //       program_name__c,
    //       objective__r.name,
    //       session__r.Date__c,
    //       previous_status__c,
    //       Percent_Correct__c
    //     FROM Session_Statistics__c
    //     WHERE session__r.client__c = :clientId AND previous_status__c = 'ACQ'
    //   ];
    // } else {
    //   results = [
    //     SELECT
    //       session__r.name,
    //       session__r.client__c,
    //       session__r.client__r.name,
    //       program_name__c,
    //       objective__r.name,
    //       session__r.Date__c,
    //       previous_status__c,
    //       Percent_Correct__c
    //     FROM Session_Statistics__c
    //     WHERE session__r.client__c = :clientId
    //   ];
    // }

    // return results;

    String querySessionStatsString =
      'SELECT session__r.name, session__r.client__c, session__r.client__r.name, program_name__c, ' +
      'objective__r.name  ,session__r.Date__c ,previous_status__c ,Percent_Correct__c ' +
      'FROM Session_Statistics__c ' +
      'WHERE session__r.client__c = :clientId ';

    if (showAcquired)
      querySessionStatsString += ' AND previous_status__c = \'ACQ\' ';

    querySessionStatsString += 'ORDER BY session__r.name, objective__r.name ';

    Logger.debug(
        'Apex:getD3Stats() querySessionStatsStr=' + querySessionStatsString
      )
      .setRecordId(clientId)
      .addTag('L4LSessionStatsController.getD3Stats()')
      .addTag('logit()');
    Logger.saveLog();

    List<Session_Statistics__c> results = new List<Session_Statistics__c>();
    results = Database.query(querySessionStatsString);

    return results;
  }

  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getD3StatsByProgram(
    String clientId,
    String programStr,
    Boolean showAcquired
  ) {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug(
        'Apex:getD3StatsByProgram() recordId=' +
        clientId +
        ' showAcquired=' +
        showAcquired
      )
      .setRecordId(clientId)
      .addTag('L4LController.getD3StatsByProgram()')
      .addTag('logit()');

    String querySessionStatsString =
      'SELECT session__r.name, session__r.client__c, session__r.client__r.name, program_name__c, ' +
      'objective__r.name  ,session__r.Date__c ,previous_status__c ,Percent_Correct__c ' +
      'FROM Session_Statistics__c ' +
      'WHERE session__r.client__c = :clientId AND program_name__c=:programStr ';

    if (showAcquired)
      querySessionStatsString += ' AND previous_status__c = \'ACQ\' ';

    querySessionStatsString += 'ORDER BY session__r.name, objective__r.name ';

    Logger.debug(
        'Apex:getD3Stats() querySessionStatsStr=' + querySessionStatsString
      )
      .setRecordId(clientId)
      .addTag('L4LSessionStatsController.getD3StatsByProgram()')
      .addTag('logit()');
    Logger.saveLog();

    List<Session_Statistics__c> results = new List<Session_Statistics__c>();
    results = Database.query(querySessionStatsString);
    return results;
  }
}
