public with sharing class L4LSessionStatsController {
  @AuraEnabled(cacheable=true)
  public static LFL_Stats_Boundary__mdt getHighAndLowBoundaries() {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug('Apex:getHighAndLowBoundaries')
      .addTag('L4LSessionStatsController.getHighAndLowBoundaries()')
      .addTag('logit()');

    LFL_Stats_Boundary__mdt lflStatsBoundaries = LFL_Stats_Boundary__mdt.getInstance(
      'lfl_stats_boundary'
    );

    Logger.debug(
        'Apex:getHighAndLowBoundaries, lflStatsBoundaries=' + lflStatsBoundaries
      )
      .addTag('L4LSessionStatsController.getHighAndLowBoundaries()')
      .addTag('logit()');

    return lflStatsBoundaries;
  }

  @AuraEnabled(cacheable=true)
  public static List<session_statistics__c> getD3SessionStatsHistogramData(
    String clientId
  ) {
    String querySessionStatsString = 'SELECT percent_correct__c FROM session_statistics__c where session__r.client__r.Id=:clientId';
    List<Session_Statistics__c> results = new List<Session_Statistics__c>();

    results = Database.query(querySessionStatsString);
    System.debug(results);
    return results;
  }

  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getSessionStats(String searchKey) {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug('Apex:getSessionStats() recordId=' + searchKey)
      .setRecordId(searchKey)
      .addTag('L4LSessionStatsController.getSessionStats()')
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
          totalacquirednonresponsive__c,
          Percent_Correct__c,
          Program_Name__c,
          SD_Name__c,
          SD_And_Objective_Str__c
        FROM session_statistics__c
        WHERE session__c = :searchKey
        ORDER BY program_name__c
      ]
    );

    Logger.debug('Apex:getSessionStats() results=' + results)
      .setRecordId(searchKey)
      .addTag('L4LSessionStatsController.getSessionStats()')
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
      .addTag('L4LSessionStatsController.getD3Stats()')
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
      'objective__r.name  ,session__r.Date__c ,previous_status__c ,Percent_Correct__c, SD_Name__c, SD_And_Objective_Str__c ' +
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
      .addTag('L4LSessionStatsController.getD3StatsByProgram()')
      .addTag('logit()');

    String querySessionStatsString =
      'SELECT session__r.name, session__r.client__c, session__r.client__r.name, program_name__c, ' +
      'objective__r.name  ,session__r.Date__c ,previous_status__c ,Percent_Correct__c, SD_Name__c, SD_And_Objective_Str__c ' +
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

  @AuraEnabled(cacheable=true)
  public static List<AggregateResult> getClientObjectivesByProgram(
    String clientId
  ) {
    String queryString =
      'SELECT  Objective__r.SD__r.Program__r.Name, ' +
      'count(Objective__c) objectiveCount FROM Client_Objective__c ' +
      'WHERE client__c = :clientId ' +
      'GROUP BY Objective__r.SD__r.Program__r.Name ' +
      'ORDER BY Objective__r.SD__r.Program__r.Name ';

    List<AggregateResult> results = new List<AggregateResult>();
    results = Database.query(queryString);

    Logger.debug('Apex:getD3Stats() queryStr=' + queryString)
      .setRecordId(clientId)
      .addTag('L4LSessionStatsController.getClientObjectivesByProgram()')
      .addTag('logit()');

    Logger.debug('Apex:getD3Stats() results' + results)
      .setRecordId(clientId)
      .addTag('L4LSessionStatsController.getClientObjectivesByProgram()')
      .addTag('logit()');
    Logger.saveLog();

    return results;
  }

  @AuraEnabled(cacheable=true)
  public static List<Session_Statistics__c> getD3StatsByProgramAndSD(
    String clientId,
    String programStr,
    String sdStr,
    Boolean showAcquired,
    String periodStr,
    String stageStr
  ) {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug(
        'Apex:getD3StatsByProgramAndSD() recordId=' +
        clientId +
        ' showAcquired=' +
        showAcquired
      )
      .setRecordId(clientId)
      .addTag('L4LController.getD3StatsByProgramAndSD()')
      .addTag('logit()');

    String querySessionStatsString =
      'SELECT session__r.name, session__r.client__c, session__r.client__r.name, program_name__c, ' +
      'objective__r.name  ,session__r.Date__c ,previous_status__c ,Percent_Correct__c, SD_Name__c, SD_And_Objective_Str__c ' +
      'FROM Session_Statistics__c ' +
      'WHERE session__r.client__c = :clientId ';

    if (programStr == 'All') {
    } else {
      querySessionStatsString += ' AND program_name__c=:programStr ';
    }

    if (sdStr == 'All') {
    } else {
      querySessionStatsString += ' AND SD_Name__c=:sdStr ';
    }

    if (stageStr == 'All') {
    } else {
      querySessionStatsString += ' AND objective__r.sd__r.Stage__c=:stageStr ';
    }
    if (showAcquired)
      querySessionStatsString += ' AND previous_status__c = \'ACQ\' ';

    if (periodStr == 'All') {
    } else {
      querySessionStatsString +=
        ' AND session__r.Date__c = LAST_N_DAYS' +
        ':' +
        periodStr +
        ' ';
    }

    querySessionStatsString += ' ORDER BY session__r.name, objective__r.name ';

    Logger.fine(
        'Apex:getD3Stats() getD3StatsByProgramAndSD() qry=' +
        querySessionStatsString
      )
      .setRecordId(clientId)
      .addTag('L4LSessionStatsController.getD3StatsByProgramAndSD()()')
      .addTag('logit()');
    Logger.saveLog();

    List<Session_Statistics__c> results = new List<Session_Statistics__c>();
    results = Database.query(querySessionStatsString);

    Logger.fine(
        'Apex:getD3Stats() getD3StatsByProgramAndSD() results=' + results
      )
      .setRecordId(clientId)
      .addTag('L4LSessionStatsController.getD3StatsByProgramAndSD()()')
      .addTag('logit()');
    Logger.saveLog();

    return results;
  }
  @AuraEnabled(Cacheable=true)
  public static List<Program__c> getProgramsAndSds(String stageStr) {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug('Apex:getProgramsAndSds')
      .addTag('L4LSessionStatsController.getProgramsAndSds()')
      .addTag('logit()');
    Logger.saveLog();

    String querySessionStatsString =
      'SELECT Id, Name,' +
      '(SELECT id, name, program__r.name, description__c FROM sds__r) ' +
      ' FROM Program__c WHERE status__c =  \'Active\'';

    if (stageStr == 'All') {
      querySessionStatsString += ' AND id IN (SELECT program__c FROM sd__c)';
    } else {
      querySessionStatsString += '  AND id IN (SELECT program__c FROM sd__c where stage__C=:stageStr) ';
    }
    System.debug(querySessionStatsString);

    List<Program__c> results = new List<Program__c>();
    results = Database.query(querySessionStatsString);

    return results;
  }

  @AuraEnabled(Cacheable=true)
  public static List<AggregateResult> getClientObjectivesSDCount(
    String clientId
  ) {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug('Apex:getClientObjectivesSDCount recordId=' + clientId)
      .setRecordId(clientId)
      .addTag('L4LSessionStatsController.getClientObjectivesSDCount()')
      .addTag('logit()');
    Logger.saveLog();

    return [
      SELECT
        objective__r.sd__r.program__R.name progname,
        objective__r.sd__r.name sdname,
        count(id) sdcount
      FROM client_objective__c
      WHERE client__c = :clientId
      GROUP BY objective__r.sd__r.program__R.name, objective__r.sd__r.name
      ORDER BY count(id)
    ];
  }

  @AuraEnabled(cacheable=true)
  public static String generateD3ProgramAreaSDJson(
    String clientId,
    String stageStr
  ) {
    Logger.setScenario('L4LSessionStatsController');
    Logger.debug('Apex:generateD3ProgramAreaSDJson')
      .addTag('L4LSessionStatsController.generateD3ProgramAreaSDJson()')
      .addTag('logit()');

    String jsontmp = '{"children":[';
    jsontmp += '{"name": "flare",';
    jsontmp += '"children": [';
    System.debug(jsontmp);
    Set<String> myset = new Set<string>();

    List<AggregateResult> countCoBySD = [
      SELECT objective__r.sd__c sdid, count(id) sdcount
      FROM client_objective__c
      WHERE client__c = :clientId
      GROUP BY objective__r.sd__c
      ORDER BY count(id)
    ];

    Map<Id, Integer> sdCountMap = new Map<Id, Integer>();

    for (AggregateResult sdc : countCoBySD) {
      sdCountMap.put((id) sdc.get('sdid'), (Integer) sdc.get('sdcount'));
    }

    System.debug(countCoBySD);

    String queryProgramString = 'SELECT id, name  ' + 'FROM program__c ';

    if (stageStr == 'All') {
      queryProgramString += ' WHERE id IN (SELECT program__c FROM sd__c WHERE area__c != NULL)';
    } else {
      queryProgramString += ' WHERE id IN (SELECT program__c FROM sd__c WHERE area__c != NULL and stage__c=:stageStr)  ';
    }

    Map<id, program__c> pmap = new Map<id, program__c>(
      (List<Program__c>) Database.query(queryProgramString)
    );
    System.debug('pmap=' + pmap);

    Map<id, Set<String>> areamap = new Map<id, Set<String>>();

    List<AggregateResult> xarlist = [
      SELECT program__c, area__c, count(id)
      FROM sd__c
      WHERE area__c != NULL
      GROUP BY program__c, area__c
    ];
    System.debug(xarlist);
    for (aggregateResult a : xarlist) {
      id i = (id) a.get('program__c');
      string area = (string) a.get('area__c');

      if (areamap.get(i) == null) {
        Set<string> temp = new Set<string>();
        temp.add(area);
        areamap.put(i, temp);
      } else {
        Set<string> temp2 = areamap.get(i);
        temp2.add(area);
        areamap.put(i, temp2);
      }

      ///areamap.put(i,s);
    }

    System.debug('areamaP=' + areamap);

    Set<id> idlist = pmap.keySet();
    for (Id i : idlist) {
      Program__c p = pmap.get(i);
      jsontmp += '{"name":"' + p.name + '",';
      jsontmp += '"children":[';
      Set<string> tempset = areamap.get(p.Id);
      for (String ss : tempset) {
        jsontmp += '{"name":"' + (String) ss + '",';
        jsontmp += '"children":[';
        for (sd__c sd : [
          SELECT Id, name
          FROM sd__c
          WHERE program__c = :p.Id AND area__c = :ss
        ]) {
          Integer val = 0;

          if ((Integer) sdCountMap.get(sd.Id) == null) {
            val = 1;
          } else {
            val = (Integer) sdCountMap.get(sd.Id) + 1;
          }
          jsontmp +=
            '{"name":"' +
            sd.name +
            '","value":' +
            val +
            ',"area":"' +
            ss +
            '","program":"' +
            p +
            '" },';
        }

        jsontmp += ']},';
      }
      jsontmp += ']},';
    }
    jsontmp += ']}';
    jsontmp += ']}';

    String target = ',]';
    String replacement = ']';
    String jsonstr = jsontmp.replace(target, replacement);
    System.debug(jsonstr);
    Logger.debug('Apex:generateD3ProgramAreaSDJson jsonstr=' + jsonstr)
      .addTag('L4LSessionStatsController.generateD3ProgramAreaSDJson()')
      .addTag('logit()');
    Logger.saveLog();
    return jsonstr;
  }
}
