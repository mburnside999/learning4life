public with sharing class L4LController {
  // Please Note: As of January 17, 2022 this is the controller for all L4L lwcs
  //
  @AuraEnabled(cacheable=false)
  public static String getSessionStatus(String recordId) {
    Logger.setScenario('L4LController');
    Logger.debug('Apex:getSessionStatus() recordId=' + recordId)
      .setRecordId(recordId)
      .addTag('L4LController.getSessionStatus()')
      .addTag('logit()');
    Logger.saveLog();

    String sessionStatus = [
      SELECT status__c
      FROM session__c
      WHERE Id = :recordId
      LIMIT 1
    ]
    .status__c;

    Logger.debug(
        'L4LController.getSessionStatus() sessionStatus= ' + sessionStatus
      )
      .setRecordId(recordId)
      .addTag('L4LController.getSessionStatus()')
      .addTag('logit()');

    Logger.saveLog();

    return sessionStatus;
  }

  @AuraEnabled(cacheable=false)
  public static List<Objective__c> getPopularObjectives(String clientId) {
    List<objective__c> objList = new List<Objective__c>();

    Logger.setScenario('L4LController');
    Logger.debug('Apex:getPopularObjectives() recordId=' + clientId)
      .setRecordId(clientId)
      .addTag('L4LController.getPopularObjectives()')
      .addTag('logit()');

    Logger.saveLog();

    AggregateResult[] popularObjectives = [
      SELECT objective__c, count(id) idcount
      FROM client_objective__c
      WHERE client__c != :clientId
      GROUP BY objective__C
      ORDER BY count(id) DESC
      LIMIT 50
    ];
    System.debug(popularObjectives);
    List<id> objids = new List<id>();

    for (AggregateResult ar : popularObjectives) {
      objids.add((Id) ar.get('Objective__c'));
    }
    objList = [
      SELECT Id, Name, Program__c, SD_Name__c
      FROM objective__c
      WHERE
        id IN :objids
        AND Id NOT IN (
          SELECT Objective__c
          FROM Client_Objective__c
          WHERE Client__c = :clientId
        )
        AND status__c = 'Active'
    ];

    System.debug(objList);

    return objList;
  }

  @AuraEnabled(cacheable=false)
  public static List<Session_obj__c> getSessionObjectives(String sess) {
    Logger.setScenario('L4LController');
    Logger.debug('Apex:getSessionObjectives() sess=' + sess)
      .setRecordId(sess)
      .addTag('L4LController.getSessionObjectives()')
      .addTag('logit()');

    String debugsoql =
      'SELECT Id,Name,Objective__c,Objective_Name__c,Correct__c,NonResponsive__c,' +
      'Incorrect__c,Prompted__c,SD__c,Program__c,Comment__c,Previous_Status__c' +
      ' FROM Session_Obj__c WHERE Session__c = :sess ORDER BY Name';

    Logger.fine('Apex:getSessionObjectives() soql= ' + debugsoql)
      .setRecordId(sess)
      .addTag('L4LController.getSessionObjectives()')
      .addTag('logit()');

    List<Session_obj__c> retlist = new List<Session_obj__c>(
      [
        SELECT
          Id,
          Name,
          Objective__c,
          Objective_Name__c,
          Correct__c,
          NonResponsive__c,
          Incorrect__c,
          Prompted__c,
          SD__c,
          Program__c,
          Comment__c,
          Previous_Status__c
        FROM Session_Obj__c
        WHERE Session__c = :sess
        ORDER BY Name
      ]
    );

    Logger.debug(
        'Apex:getSessionObjectives() retlist.size()= ' + retlist.size()
      )
      .setRecordId(sess)
      .addTag('L4LController.getSessionObjectives()')
      .addTag('logit()');

    Logger.fine('Apex:getSessionObjectives() retlist= ' + retlist)
      .setRecordId(sess)
      .addTag('L4LController.getSessionObjectives()')
      .addTag('logit()');

    Logger.saveLog();

    return retlist;
  }

  @AuraEnabled
  public static List<Client_Objective__c> getClientObjectivesForSession(
    String searchKey
  ) {
    Logger.setScenario('L4LController');
    Logger.debug('Apex:getClientObjectivesForSession() searchKey=' + searchKey)
      .setRecordId(searchKey)
      .addTag('L4LController.getClientObjectivesForSession()')
      .addTag('logit()');

    String debugsoql =
      'SELECT Id,Name,Objective__c,Objective_Name__c,Client__c,' +
      'SD_Name__c,Status__c,Re_Test_Recommended__c,Days_Since_Tested_Correct__c,Client_Objective_Notes__c' +
      ' FROM client_objective__c WHERE Client__c IN (SELECT client__c FROM session__c WHERE id = :searchKey)' +
      ' ORDER BY Program_Name__c';

    Logger.fine('Apex:getClientObjectivesForSession() soql=' + debugsoql)
      .setRecordId(searchKey)
      .addTag('L4LController.getClientObjectivesForSession()')
      .addTag('logit()');

    List<Client_Objective__c> retlist = new List<Client_Objective__c>(
      [
        SELECT
          Id,
          Name,
          Objective__c,
          Objective_Name__c,
          Client__c,
          Program_Name__c,
          SD_Name__c,
          Status__c,
          Re_Test_Recommended__c,
          Days_Since_Tested_Correct__c,
          Client_Objective_Notes__c
        FROM client_objective__c
        WHERE
          Client__c IN (SELECT client__c FROM session__c WHERE id = :searchKey)
        ORDER BY Program_Name__c
      ]
    );

    Logger.debug(
        'Apex:getClientObjectivesForSession() retlist.size=' + retlist.size()
      )
      .setRecordId(searchKey)
      .addTag('L4LController.getClientObjectivesForSession()')
      .addTag('logit()');

    Logger.fine('Apex:getClientObjectivesForSession() retlist=' + retlist)
      .setRecordId(searchKey)
      .addTag('L4LController.getClientObjectivesForSession()')
      .addTag('logit()');

    Logger.saveLog();

    return retlist;
  }

  @AuraEnabled(cacheable=false)
  public static List<Client_Objective__c> getClientObjectives(String clientId) {
    Logger.setScenario('L4LController');
    Logger.debug('Apex:getClientObjectives() clientId=' + clientId)
      .setRecordId(clientId)
      .addTag('L4LController.getClientObjectives()')
      .addTag('logit()');

    String debugsoql =
      'SELECT Id,Name,Client__c,Objective_Name__c,SD_Name__c,Program_Name__c,' +
      'Status__c,Frequency__c,Last_Tested_Correct__c,Re_Test_Recommended__c,Client_Objective_Notes__c' +
      ' FROM Client_Objective__c WHERE Client__c = :clientId ORDER BY Program_Name__c, Name';

    Logger.fine('Apex:getClientObjectives() soql=' + debugsoql)
      .setRecordId(clientId)
      .addTag('L4LController.getClientObjectives()')
      .addTag('logit()');

    List<Client_Objective__c> retlist = new List<Client_Objective__c>(
      [
        SELECT
          Id,
          Name,
          Client__c,
          Objective_Name__c,
          SD_Name__c,
          Program_Name__c,
          Status__c,
          Frequency__c,
          Last_Tested_Correct__c,
          Re_Test_Recommended__c,
          Client_Objective_Notes__c
        FROM Client_Objective__c
        WHERE Client__c = :clientId
        ORDER BY Program_Name__c, Name
      ]
    );

    Logger.debug('Apex:getClientObjectives() retlist.size()=' + retlist.size())
      .setRecordId(clientId)
      .addTag('L4LController.getClientObjectives()')
      .addTag('logit()');

    Logger.fine('Apex:getClientObjectives() retlist=' + retlist)
      .setRecordId(clientId)
      .addTag('L4LController.getClientObjectives()')
      .addTag('logit()');

    Logger.saveLog();

    return retlist;
  }

  @AuraEnabled
  public static List<Objective__c> getUnusedObjectives(String clientId) {
    Logger.setScenario('L4LController');

    Logger.debug('Apex:getUnusedObjectives() clientId=' + clientId)
      .setRecordId(clientId)
      .addTag('L4LController.getUnusedObjective()')
      .addTag('logit()');

    Logger.fine(
        'Apex:getUnusedObjectives(): SELECT Id, Name, Program__c, SD_Name__c ' +
        ' FROM Objective__c ' +
        ' WHERE Id NOT IN ( ' +
        ' SELECT Objective__c ' +
        ' FROM Client_Objective__c ' +
        ' WHERE Client__c = :clientId ORDER BY Program__c, Name )' +
        ' AND status__c="Active"'
      )
      .setRecordId(clientId)
      .addTag('L4LController.getUnusedObjective()')
      .addTag('logit()');

    System.debug('>>>>>> in getUnusedObjectives(clientId)');
    System.debug('>>>>>> clientId=' + clientId);
    //test written
    List<Objective__c> retlist = new List<Objective__c>(
      [
        SELECT Id, Name, Program__c, SD_Name__c
        FROM Objective__c
        WHERE
          Id NOT IN (
            SELECT Objective__c
            FROM Client_Objective__c
            WHERE Client__c = :clientId
          )
          AND status__c = 'Active'
        ORDER BY Program__c, Name
      ]
    );

    Logger.debug('Apex:getUnusedObjectives() retlist.size()=' + retlist.size())
      .setRecordId(clientId)
      .addTag('L4LController.getUnusedObjective()')
      .addTag('logit()');

    Logger.fine('Apex:getUnusedObjectives() retlist=' + retlist)
      .setRecordId(clientId)
      .addTag('L4LController.getUnusedObjective()')
      .addTag('logit()');

    Logger.saveLog();

    return retlist;
  }

  @AuraEnabled
  public static List<Objective__c> getUnusedObjectivesBySearch(
    String clientId,
    String searchstring
  ) {
    Logger.setScenario('L4LController');

    Logger.debug(
        'Apex:getUnusedObjectivesBySearch() clientId=' +
        clientId +
        ' searchstring=' +
        searchstring
      )
      .setRecordId(clientId)
      .addTag('L4LController.getUnusedObjectiveBySearch()')
      .addTag('logit()');

    Logger.fine(
        'Apex:getUnusedObjectives(): SELECT Id, Name, Program__c, SD_Name__c ' +
        ' FROM Objective__c ' +
        ' WHERE Id NOT IN ( ' +
        ' SELECT Objective__c ' +
        ' FROM Client_Objective__c ' +
        ' WHERE Client__c = :clientId ORDER BY Program__c, Name )' +
        ' AND status__c="Active" and Name like...'
      )
      .setRecordId(clientId)
      .addTag('L4LController.getUnusedObjectiveBySearch()')
      .addTag('logit()');

    System.debug(
      '>>>>>> in getUnusedObjectivesBySearch(clientId,searchstring)'
    );
    System.debug('>>>>>> clientId=' + clientId);

    searchstring = '%' + searchstring + '%';

    List<Objective__c> retlist = new List<Objective__c>(
      [
        SELECT Id, Name, Program__c, SD_Name__c
        FROM Objective__c
        WHERE
          Id NOT IN (
            SELECT Objective__c
            FROM Client_Objective__c
            WHERE Client__c = :clientId
          )
          AND status__c = 'Active'
          AND (SD__r.Program__r.Name LIKE :searchstring
          OR sd__r.name LIKE :searchstring
          OR name LIKE :searchstring)
        ORDER BY Program__c, Name
      ]
    );

    Logger.debug(
        'Apex:getUnusedObjectivesBySearch() retlist.size()=' + retlist.size()
      )
      .setRecordId(clientId)
      .addTag('L4LController.getUnusedObjectivesBySearch()')
      .addTag('logit()');

    Logger.fine('Apex:getUnusedObjectivesBySearch() retlist=' + retlist)
      .setRecordId(clientId)
      .addTag('L4LController.getUnusedObjectivesBySearch()')
      .addTag('logit()');

    Logger.saveLog();

    return retlist;
  }

  @AuraEnabled
  public static void deleteSessionObjectives(String sessionid) {
    Logger.debug('Apex:deleteSessionObjectives() sessionId=' + sessionId)
      .setRecordId(sessionId)
      .addTag('L4LController.deleteSessionObjectives()')
      .addTag('logit()');
    //test written
    Logger.fine(
        'Apex:deleteSessionObjectives() soql= delete [SELECT id FROM Session_Obj__c WHERE session__c = :sessionid]'
      )
      .setRecordId(sessionId)
      .addTag('L4LController.deleteSessionObjectives()')
      .addTag('logit()');

    Logger.saveLog();

    delete [SELECT id FROM Session_Obj__c WHERE session__c = :sessionid];
  }

  @AuraEnabled
  public static Integer createSessionObjectivesByArrayWithOrderedResults(
    String jsonstr,
    String sess,
    String skillstring
  ) {
    Logger.setScenario('L4LController');

    Logger.debug(
        'Apex:createSessionObjectivesByArrayWithOrderedResults() entering...'
      )
      .addTag(
        'L4LController.createSessionObjectivesByArrayWithOrderedResults()'
      )
      .addTag('logit()');

    Logger.fine(
        'Apex:createSessionObjectivesByArrayWithOrderedResults() jsonstr=' +
        jsonstr +
        'sess=' +
        sess +
        ' skillstring=' +
        skillstring
      )
      .addTag(
        'L4LController.createSessionObjectivesByArrayWithOrderedResults()'
      )
      .addTag('logit()');
    Logger.setScenario('L4LController');

    //test written
    System.debug('jsonstr:' + jsonstr);
    System.debug('sess:' + sess);
    System.debug('skillstring:' + skillstring);

    //deserialise the object array
    List<Client_Objective__c> objDeserialized = (List<Client_Objective__c>) JSON.deserializeStrict(
      jsonstr,
      List<Client_Objective__c>.class
    );

    Logger.fine(
        'Apex:createSessionObjectivesByArrayWithOrderedResults() objDeserialized=' +
        objDeserialized
      )
      .addTag(
        'L4LController.createSessionObjectivesByArrayWithOrderedResults()'
      )
      .addTag('logit()');

    List<L4LController.SessionResult> sessionresults = (List<L4LController.SessionResult>) JSON.deserializeStrict(
      skillstring,
      List<L4LController.SessionResult>.class
    );

    Logger.fine(
        'Apex:createSessionObjectivesByArrayWithOrderedResults() sessionresults=' +
        sessionresults
      )
      .addTag(
        'L4LController.createSessionObjectivesByArrayWithOrderedResults()'
      )
      .addTag('logit()');

    // // prepare a list for insertion in bulk
    List<Session_Obj__c> soList = new List<Session_Obj__c>();

    // loop thru the deserialised objectives
    for (Client_Objective__c o : objDeserialized) {
      for (L4LController.SessionResult mbsr : sessionresults) {
        // prepare a session_obj__c and add to array
        Session_Obj__c so = new Session_Obj__c();
        so.Session__c = sess;
        so.Objective__c = o.Objective__c;
        switch on mbsr.skill {
          when 'C' {
            // when block 1
            so.Correct__c = true;
            so.Incorrect__c = false;
            so.Prompted__c = false;
            so.NonResponsive__c = false;
          }
          when 'N' {
            // when block 1
            so.Correct__c = false;
            so.Incorrect__c = false;
            so.Prompted__c = false;
            so.NonResponsive__c = true;
          }
          when 'I' {
            // when block 2
            so.Correct__c = false;
            so.Incorrect__c = true;
            so.Prompted__c = false;
            so.NonResponsive__c = false;
          }
          when 'P' {
            // when block 3
            so.Correct__c = false;
            so.Incorrect__c = false;
            so.Prompted__c = true;
            so.NonResponsive__c = false;
          }
        }
        so.previous_status__c = o.status__c;
        soList.add(so);
      }
    }

    Logger.fine(
        'Apex:createSessionObjectivesByArrayWithOrderedResults() DML insert soList=' +
        soList
      )
      .addTag(
        'L4LController.createSessionObjectivesByArrayWithOrderedResults()'
      )
      .addTag('logit()');
    Logger.saveLog();

    insert soList;

    return soList.size();
  }

  @AuraEnabled
  public static Integer createClientObjectivesByArray(
    String jsonstr,
    String sess
  ) {
    Logger.setScenario('L4LController');

    Logger.debug('Apex:createClientObjectivesByArray() ...entering')
      .setRecordId(sess)
      .addTag('L4LController.createClientObjectivesByArray()')
      .addTag('logit()');

    Logger.fine('Apex:createClientObjectivesByArray() jsonstr=' + jsonstr)
      .setRecordId(sess)
      .addTag('L4LController.createClientObjectivesByArray()')
      .addTag('logit()');

    //deserailise the object array
    List<Objective__c> objDeserialized = (List<Objective__c>) JSON.deserializeStrict(
      jsonstr,
      List<Objective__c>.class
    );

    Logger.fine(
        'Apex:createClientObjectivesByArray() strict objDeserialized=' +
        objDeserialized
      )
      .setRecordId(sess)
      .addTag('L4LController.createClientObjectivesByArray()')
      .addTag('logit()');

    // // prepare a list for insertion in bulk
    List<Client_Objective__c> coList = new List<Client_Objective__c>();

    // loop thru the deserialised objectives
    for (Objective__c o : objDeserialized) {
      // prepare a sess_obj__c and add to array
      Client_Objective__c co = new Client_Objective__c();
      co.Client__c = sess;
      co.Objective__c = o.Id;
      //co.Status__c='CIP';
      coList.add(co);
    }
    Logger.fine(
        'Apex:createClientObjectivesByArray() DML insert coList=' + coList
      )
      .setRecordId(sess)
      .addTag('L4LController.createClientObjectivesByArray()')
      .addTag('logit()');

    insert coList;

    Logger.debug(
        'Apex:createClientObjectivesByArray() returning objDeserialized.size()=' +
        objDeserialized.size()
      )
      .setRecordId(sess)
      .addTag('L4LController.createClientObjectivesByArray()')
      .addTag('logit()');

    Logger.saveLog();

    return objDeserialized.size();
  }

  @AuraEnabled
  public static Integer setSessionObjectivesByArray(
    String jsonstr,
    String val
  ) {
    Logger.fine(
        'Apex:getSessionObjectivesByArray() jsonstr=' +
        jsonstr +
        'val=' +
        val
      )
      .addTag('L4LController.getSessionObjectivesByArray()')
      .addTag('logit()');
    Logger.setScenario('L4LController');

    boolean del = false;
    List<Session_Obj__c> soDeserialized = (List<Session_Obj__c>) JSON.deserializeStrict(
      jsonstr,
      List<Session_Obj__c>.class
    );
    for (Session_Obj__c so : soDeserialized) {
      switch on val {
        when 'Correct' {
          so.Correct__c = true;
          so.Incorrect__c = false;
          so.Prompted__c = false;
          so.NonResponsive__c = false;
          update so;
        }
        when 'NonResponsive' {
          so.Correct__c = false;
          so.Incorrect__c = false;
          so.Prompted__c = false;
          so.NonResponsive__c = true;

          update so;
        }
        when 'Incorrect' {
          so.Correct__c = false;
          so.Incorrect__c = true;
          so.Prompted__c = false;
          so.NonResponsive__c = false;

          update so;
        }
        when 'Prompted' {
          so.Correct__c = false;
          so.Incorrect__c = false;
          so.Prompted__c = true;
          so.NonResponsive__c = false;

          update so;
        }
        when 'Delete' {
          delete so;
        }
      }
    }
    Logger.fine(
        'Apex:getSessionObjectivesByArray() soDeserialized=' + soDeserialized
      )
      .addTag('L4LController.getSessionObjectivesByArray()')
      .addTag('logit()');

    Logger.debug(
        'Apex:getSessionObjectivesByArray() returning soDeserialized.size()=' +
        soDeserialized.size()
      )
      .addTag('L4LController.getSessionObjectivesByArray()')
      .addTag('logit()');
    Logger.saveLog();
    return soDeserialized.size();
  }

  public class SessionResult {
    public String skill { get; set; }
  }
}
