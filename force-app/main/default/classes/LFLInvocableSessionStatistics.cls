/**************************************************************
 * @name LFLInvocableSessionStatistics
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description Invocable methods, called from Flow to support session closure
 *
 */

public with sharing class LFLInvocableSessionStatistics {
  /*******************************************************************************************************
   * @name computeSessionStats
   * @description computes statistics for a session.
   * Inserts session_statistics__c records.
   * This method is an InvocableMethod and is called from Flow when a Session is closed.
   * Flow uses the returned String to update the session with a rich text summary.
   *
   *
   * @param sessions, a list of Ids
   * @return a list of responses List<Response> (i.e. a single String response to Flow)
   *
   * @example
   */

  @InvocableMethod
  public static List<Response> computeSessionStats(List<Id> sessions) {
    String SCENARIO = 'computeSessionStats() - invocable called from Flow - Apex';

    Logger.setScenario(SCENARIO);
    Logger.info('Apex:computeSessionStats() - invocable called from Flow')
      .setRecordId(sessions[0])
      .addTag('LFLInvocableSessionStatistics.computeSessionStats()')
      .addTag('logit()');

    Logger.saveLog();

    Id session = sessions[0];
    List<Response> responseList = new List<Response>();
    Response response = new Response();
    String PREVDEFAULT = 'BLANK';
    String previousStr;
    Integer totalCorrect = 0;
    Integer totalIncorrect = 0;
    Integer totalPrompted = 0;
    Integer totalNonResponsive = 0;

    Map<Id, Map<String, Integer>> correctMap = new Map<Id, Map<String, Integer>>();
    Map<Id, Map<String, Integer>> nonResponsiveMap = new Map<Id, Map<String, Integer>>();
    Map<Id, Map<String, Integer>> incorrectMap = new Map<Id, Map<String, Integer>>();
    Map<Id, Map<String, Integer>> promptedMap = new Map<Id, Map<String, Integer>>();

    Set<id> objectiveSet = new Set<Id>();
    Set<String> statusSet = new Set<String>();

    delete [SELECT id FROM Session_Statistics__c WHERE session__c = :session];

    for (Session_Obj__c so : [
      SELECT
        Objective__c,
        Objective_Name__c,
        Correct__c,
        NonResponsive__c,
        Incorrect__c,
        Prompted__c,
        previous_status__c,
        session__c
      FROM session_obj__c
      WHERE session__C = :session
    ]) {
      previousStr = (so.previous_status__c == null)
        ? PREVDEFAULT
        : so.previous_status__c;
      objectiveSet.add(so.objective__c);
      statusSet.add(previousStr);

      if (so.correct__c == true) {
        Map<String, Integer> corrStatus = new Map<String, Integer>();
        corrStatus = correctMap.get(so.objective__c);

        if (corrStatus != null) {
          if (corrStatus.get(previousStr) != null) {
            corrStatus.put(
              previousStr,
              (Integer) corrStatus.get(previousStr) + 1
            );
          } else {
            corrStatus.put(previousStr, 1);
          }
        } else {
          corrStatus = new Map<String, Integer>();
          corrStatus.put(previousStr, 1);
          correctMap.put(so.objective__c, corrStatus);
        }
      }
      if (so.nonresponsive__c == true) {
        Map<String, Integer> nonResponsiveStatus = new Map<String, Integer>();
        nonResponsiveStatus = nonResponsiveMap.get(so.objective__c);

        if (nonResponsiveStatus != null) {
          if (nonResponsiveStatus.get(previousStr) != null) {
            nonResponsiveStatus.put(
              previousStr,
              (Integer) nonResponsiveStatus.get(previousStr) + 1
            );
          } else {
            nonResponsiveStatus.put(previousStr, 1);
          }
        } else {
          nonResponsiveStatus = new Map<String, Integer>();
          nonResponsiveStatus.put(previousStr, 1);
          nonResponsiveMap.put(so.objective__c, nonResponsiveStatus);
        }
      }
      if (so.incorrect__c == true) {
        Map<String, Integer> incorrStatus = new Map<String, Integer>();
        incorrStatus = incorrectMap.get(so.objective__c);

        if (incorrStatus != null) {
          if (incorrStatus.get(previousStr) != null) {
            incorrStatus.put(
              previousStr,
              (Integer) incorrStatus.get(previousStr) + 1
            );
          } else {
            incorrStatus.put(previousStr, 1);
          }
        } else {
          incorrStatus = new Map<String, Integer>();
          incorrStatus.put(previousStr, 1);
          incorrectMap.put(so.objective__c, incorrStatus);
        }
      }
      if (so.prompted__c == true) {
        Map<String, Integer> promptedStatus = new Map<String, Integer>();
        promptedStatus = promptedMap.get(so.objective__c);

        if (promptedStatus != null) {
          if (promptedStatus.get(previousStr) != null) {
            promptedStatus.put(
              previousStr,
              (Integer) promptedStatus.get(previousStr) + 1
            );
          } else {
            promptedStatus.put(previousStr, 1);
          }
        } else {
          promptedStatus = new Map<String, Integer>();
          promptedStatus.put(previousStr, 1);
          promptedMap.put(so.objective__c, promptedStatus);
        }
      }
    }
    System.debug(correctMap);
    System.debug('correct ' + correctMap);
    System.debug('nonresponsive ' + nonResponsiveMap);
    System.debug('incorrect ' + incorrectMap);
    System.debug('prompted ' + promptedMap);

    // Logger.debug(
    //   'Apex:computeSessionStats() correctMap=' +
    //   correctMap +
    //   ' nonResponsiveMap=' +
    //   nonResponsiveMap +
    //   ' incorrectMap=' +
    //   incorrectMap +
    //   ' promptedMap=' +
    //   promptedMap
    // );

    Map<String, Integer> temp = new Map<String, Integer>();
    Integer count = 0;
    for (Id i : objectiveSet) {
      for (String s : statusSet) {
        count = 0;
        Boolean skip = true; // assume skip - this status wasn't present in this objective

        temp = correctMap.get(i);
        if (temp != null) {
          if (temp.keySet().contains(s))
            skip = false;
        }
        temp = nonResponsiveMap.get(i);
        if (temp != null) {
          if (temp.keySet().contains(s))
            skip = false;
        }
        temp = incorrectMap.get(i);
        if (temp != null) {
          if (temp.keySet().contains(s))
            skip = false;
        }
        temp = promptedMap.get(i);
        if (temp != null) {
          if (temp.keySet().contains(s))
            skip = false;
        }

        if (!skip) {
          /** Dont skip, there's a previous_status for this objective in correct, incorrect or prompted
         so create a statistics record
        **/
          Session_Statistics__c sessionStat = new Session_Statistics__c();
          sessionStat.session__c = session;
          sessionStat.objective__c = i;
          sessionStat.previous_status__c = s;

          temp = correctMap.get(i);
          if (temp != null) {
            count = (temp.get(s) != null) ? (Integer) temp.get(s) : 0;
            sessionStat.totalacquiredcorrect__c = count;
          } else
            sessionStat.totalacquiredcorrect__c = 0;
          totalCorrect += (Integer) sessionStat.totalacquiredcorrect__c;

          temp = nonResponsiveMap.get(i);
          if (temp != null) {
            count = (temp.get(s) != null) ? (Integer) temp.get(s) : 0;
            sessionStat.totalacquirednonresponsive__c = count;
          } else
            sessionStat.totalacquirednonresponsive__c = 0;
          totalNonResponsive += (Integer) sessionStat.totalacquirednonresponsive__c;

          temp = incorrectMap.get(i);
          if (temp != null) {
            count = (temp.get(s) != null) ? (Integer) temp.get(s) : 0;
            sessionStat.totalacquiredincorrect__c = count;
          } else
            sessionStat.totalacquiredincorrect__c = 0;
          totalIncorrect += (Integer) sessionStat.totalacquiredincorrect__c;

          temp = promptedMap.get(i);
          if (temp != null) {
            count = (temp.get(s) != null) ? (Integer) temp.get(s) : 0;
            sessionStat.totalacquiredprompted__c = count;
          } else
            sessionStat.totalacquiredprompted__c = 0;
          totalPrompted += (Integer) sessionStat.totalacquiredprompted__c;

          System.debug(sessionStat);
          insert sessionStat;

          Logger.debug(
              'Apex:computeSessionStats() inserted session_statistics__c'
            )
            .setRecordId(sessionStat.id)
            .addTag('LFLInvocableSessionStatistics.computeSessionStats()')
            .addTag('logit()');
          Logger.saveLog();
        }
      }
    }
    String current = System.now().format();
    Integer noOfObjectives = objectiveSet.size();
    Decimal percentage = ((totalCorrect +
      totalIncorrect +
      totalPrompted +
      totalNonResponsive) > 0)
      ? (Decimal) (totalCorrect *
        100 /
        (totalCorrect +
        totalNonResponsive +
        totalIncorrect +
        totalPrompted))
      : 0;

    response.outputString =
      '\n---------------------------------------------------------------' +
      '\nSuccessfully generated session statistics at ' +
      current +
      '\n---------------------------------------------------------------' +
      '\nDistinct Objectives: ' +
      noOfObjectives +
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
