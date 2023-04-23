/**************************************************************
 * @name LFLDTDRates
 * @author	Mike Burnside
 * @date	2023
 * @deprecated
 * @group Learning For Life - DEPRECATED
 * @description	Deprecated on 30/1/2023.
 * Roll up stats to the Program level.  
 *
 */

public with sharing class LFLInvocableMasteryStatistics {
  @InvocableMethod
  public static List<Response> computeMasteryStats(List<Id> sessions) {
    Logger.setScenario('LFLInvocableSessionStatistics');
    Logger.debug('Apex:computeMasteryStats() - invocable called from Flow')
      .setRecordId(sessions[0])
      .addTag('LFLInvocableSessionStatistics.computeMasteryStats()')
      .addTag('logit()');

    Id session = sessions[0];
    List<Response> responseList = new List<Response>();
    Response response = new Response();
    String PREVDEFAULT = 'BLANK';
    Id programId;
    Integer totalCorrect = 0;
    Integer totalIncorrect = 0;
    Integer totalPrompted = 0;
    Integer totalNonResponsive = 0;

    Id clientId;

    Map<Id, Integer> correctMap = new Map<Id, Integer>();
    Map<Id, Integer> nonResponsiveMap = new Map<Id, Integer>();
    Map<Id, Integer> incorrectMap = new Map<Id, Integer>();
    Map<Id, Integer> promptedMap = new Map<Id, Integer>();

    Set<Id> programSet = new Set<Id>();
    //Set<String> statusSet = new Set<String>();

    delete [SELECT id FROM Mastery_Statistics__c WHERE session__c = :session];

    for (Session_Obj__c so : [
      SELECT
        Objective__c,
        session__r.Client__c,
        Objective_Name__c,
        Correct__c,
        NonResponsive__c,
        Incorrect__c,
        Prompted__c,
        previous_status__c,
        session__c,
        objective__r.sd__r.program__c
      FROM session_obj__c
      WHERE session__C = :session AND previous_status__c = 'ACQ'
    ]) {
      programId = so.objective__r.sd__r.program__c;
      programSet.add(programId);
      clientId = so.session__r.Client__c;

      if (so.correct__c == true) {
        Integer i = (Integer) correctMap.get(programId);
        if (i != null) {
          correctMap.put(programId, i + 1);
        } else {
          correctMap.put(programId, 1);
        }
      }
      if (so.nonresponsive__c == true) {
        Integer i = (Integer) nonResponsiveMap.get(programId);
        if (i != null) {
          nonResponsiveMap.put(programId, i + 1);
        } else {
          nonResponsiveMap.put(programId, 1);
        }
      }

      if (so.incorrect__c == true) {
        Integer i = (Integer) incorrectMap.get(programId);
        if (i != null) {
          incorrectMap.put(programId, i + 1);
        } else {
          incorrectMap.put(programId, 1);
        }
      }
      if (so.prompted__c == true) {
        Integer i = (Integer) promptedMap.get(programId);
        if (i != null) {
          promptedMap.put(programId, i + 1);
        } else {
          promptedMap.put(programId, 1);
        }
      }
    }
    System.debug(correctMap);
    System.debug('correct ' + correctMap);
    System.debug('nonresponsive ' + nonResponsiveMap);
    System.debug('incorrect ' + incorrectMap);
    System.debug('prompted ' + promptedMap);

    Logger.debug(
        'Apex:computeMasteryStats() correctMap=' +
        correctMap +
        ' nonResponsiveMap=' +
        nonResponsiveMap +
        ' incorrectMap=' +
        incorrectMap +
        ' promptedMap=' +
        promptedMap
      )
      .setRecordId(sessions[0])
      .addTag('LFLInvocableSessionStatistics.computeMasteryStats()')
      .addTag('logit()');

    Logger.saveLog();

    Integer temp;
    Integer count = 0;

    for (Id pId : programSet) {
      count = 0;

      /** Dont skip **/
      Mastery_Statistics__c masteryStat = new Mastery_Statistics__c();
      masteryStat.session__c = session;
      masteryStat.previous_status__c = 'ACQ';
      masteryStat.program__c = pId;
      masteryStat.client__c = clientId;

      temp = correctMap.get(pId);
      if (temp != null) {
        masteryStat.totalacquiredcorrect__c = temp;
      } else {
        masteryStat.totalacquiredcorrect__c = 0;
      }
      totalCorrect += (Integer) masteryStat.totalacquiredcorrect__c;
      System.debug(totalCorrect);

      temp = nonResponsiveMap.get(pId);
      if (temp != null) {
        masteryStat.totalacquirednonresponsive__c = temp;
      } else {
        masteryStat.totalacquirednonresponsive__c = 0;
      }
      totalNonResponsive += (Integer) masteryStat.totalacquirednonresponsive__c;
      System.debug(totalNonResponsive);

      temp = incorrectMap.get(pId);
      if (temp != null) {
        masteryStat.totalacquiredincorrect__c = temp;
      } else {
        masteryStat.totalacquiredincorrect__c = 0;
      }
      totalIncorrect += (Integer) masteryStat.totalacquiredincorrect__c;
      System.debug(totalIncorrect);

      temp = promptedMap.get(pId);
      if (temp != null) {
        masteryStat.totalacquiredprompted__c = temp;
      } else {
        masteryStat.totalacquiredprompted__c = 0;
      }
      totalPrompted += (Integer) masteryStat.totalacquiredprompted__c;
      System.debug(totalPrompted);
      insert masteryStat;
    }
    String current = System.now().format();
    //Integer noOfObjectives = programSet.size();
    Decimal percentage = ((totalCorrect +
      totalIncorrect +
      totalNonResponsive +
      totalPrompted) > 0)
      ? (Decimal) (totalCorrect *
        100 /
        (totalCorrect +
        totalNonResponsive +
        totalIncorrect +
        totalPrompted))
      : 0;

    response.outputString =
      '\n---------------------------------------------------------------' +
      '\nSuccessfully generated mastery statistics at ' +
      current +
      '\n---------------------------------------------------------------' +
      '\nCorrect: ' +
      totalCorrect +
      '\nNonResponsive: ' +
      totalNonResponsive +
      '\nIncorrect: ' +
      totalIncorrect +
      '\nPrompted: ' +
      totalPrompted +
      '\n----------------------' +
      '\nPercent Correct: ' +
      percentage +
      '%' +
      '\n----------------------\n';
    responseList.add(response);
    return responseList;
  }

  public class Response {
    @InvocableVariable(
      label='Output'
      description='Calculate Statistics Result'
      required=true
    )
    public String outputString;
  }
}
