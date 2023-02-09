public with sharing class L4LController {
  // Please Note: As of January 17, 2022 this is the controller for all L4L lwcs
  //
  @AuraEnabled(cacheable=false)
  public static String getSessionStatus(String recordId) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      recordId,
      'in L4LController.getSessionStatus()',
      'L4LController.getSessionStatus()',
      'next-gen-nebula-apex'
    );

    String sessionStatus = [
      SELECT status__c
      FROM session__c
      WHERE Id = :recordId
      LIMIT 1
    ]
    .status__c;

    L4LNebulaComponentController.logDebug(
      recordId,
      'returning sessionStatus= ' + sessionStatus,
      'L4LController.getSessionStatus()',
      'next-gen-nebula-apex'
    );

    return sessionStatus;
  }

  @AuraEnabled(cacheable=false)
  public static List<Objective__c> getPopularObjectives(String clientId) {
    List<objective__c> objList = new List<Objective__c>();
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getPopularObjectives()',
      'L4LController.getPopularObjectives()',
      'next-gen-nebula-apex'
    );

    AggregateResult[] popularObjectives = [
      SELECT objective__c, count(id) idcount
      FROM client_objective__c
      WHERE client__c != :clientId
      GROUP BY objective__C
      ORDER BY count(id) DESC
      LIMIT 50
    ];

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getPopularObjectives() popularObjectives=' +
      popularObjectives,
      'L4LController.getPopularObjectives()',
      'next-gen-nebula-apex'
    );

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

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getPopularObjectives() returning objList=' + objList,
      'L4LController.getPopularObjectives()',
      'next-gen-nebula-apex'
    );

    return objList;
  }

  @AuraEnabled(cacheable=false)
  public static List<Session_obj__c> getSessionObjectives(String sess) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.getSessionObjectives()',
      'L4LController.getSessionObjectives()',
      'next-gen-nebula-apex'
    );

    String debugsoql =
      'SELECT Id,Name,Objective__c,Objective_Name__c,Correct__c,NonResponsive__c,' +
      'Incorrect__c,Prompted__c,SD__c,Program__c,Comment__c,Previous_Status__c' +
      ' FROM Session_Obj__c WHERE Session__c = :sess ORDER BY Name';

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.getSessionObjectives() soql=' + debugsoql,
      'L4LController.getSessionObjectives()',
      'next-gen-nebula-apex'
    );

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

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.getSessionObjectives() returning retlist=' + retlist,
      'L4LController.getSessionObjectives()',
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  @AuraEnabled
  public static List<Client_Objective__c> getClientObjectivesForSession(
    String searchKey
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      searchKey,
      'L4LController.getClientObjectivesForSession()',
      'L4LController.getClientObjectivesForSession()',
      'next-gen-nebula-apex'
    );

    String debugsoql =
      'SELECT Id,Name,Objective__c,Objective_Name__c,Client__c,' +
      'SD_Name__c,Status__c,Re_Test_Recommended__c,Days_Since_Tested_Correct__c,Client_Objective_Notes__c' +
      ' FROM client_objective__c WHERE active__c=true and Client__c IN (SELECT client__c FROM session__c WHERE id = :searchKey)' +
      ' ORDER BY Program_Name__c';

    L4LNebulaComponentController.logDebug(
      searchKey,
      'L4LController.getClientObjectivesForSession() debugsoql=' + debugsoql,
      'L4LController.getClientObjectivesForSession()',
      'next-gen-nebula-apex'
    );

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
          active__c = TRUE
          AND Client__c IN (
            SELECT client__c
            FROM session__c
            WHERE id = :searchKey
          )
        ORDER BY Program_Name__c
      ]
    );

    L4LNebulaComponentController.logDebug(
      searchKey,
      'L4LController.getClientObjectivesForSession() returning retlist=' +
      retlist,
      'L4LController.getClientObjectivesForSession()',
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  @AuraEnabled(cacheable=false)
  public static List<Client_Objective__c> getClientObjectives(String clientId) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectives()',
      'L4LController.getClientObjectives()',
      'next-gen-nebula-apex'
    );

    String debugsoql =
      'SELECT Id,Name,Client__c,Objective_Name__c,SD_Name__c,Program_Name__c,' +
      'Status__c,Frequency__c,Last_Tested_Correct__c,Re_Test_Recommended__c,Client_Objective_Notes__c' +
      ' FROM Client_Objective__c WHERE active__c=true and Client__c = :clientId ORDER BY Program_Name__c, Name';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectives() debugsoql=' + debugsoql,
      'L4LController.getClientObjectives()',
      'next-gen-nebula-apex'
    );

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
          Client_Objective_Notes__c,
          active__c
        FROM Client_Objective__c
        WHERE active__c = TRUE AND Client__c = :clientId
        ORDER BY Program_Name__c, Name
      ]
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectives() returning retlist.size()=' +
      retlist.size(),
      'L4LController.getClientObjectives()',
      'next-gen-nebula-apex'
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectives() returning retlist=' + retlist,
      'L4LController.getClientObjectives()',
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  @AuraEnabled(cacheable=false)
  public static List<Client_Objective__c> getClientObjectivesFilteredOnActive(
    String clientId,
    boolean showActiveOnly
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectivesFilteredOnActive()',
      'L4LController.getClientObjectivesFilteredOnActive()',
      'next-gen-nebula-apex'
    );

    String queryCOString =
      'SELECT Id,Name,Client__c,Objective_Name__c,SD_Name__c,Program_Name__c,' +
      'Status__c,Frequency__c,Last_Tested_Correct__c,Re_Test_Recommended__c,Client_Objective_Notes__c,active__c ' +
      ' FROM Client_Objective__c WHERE Client__c = :clientId ';

    if (showActiveOnly) {
      queryCOString += ' and active__c=true';
    } else {
    }

    queryCOString += ' ORDER BY Program_Name__c, Name';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectivesFilteredOnActive() queryCOString=' +
      queryCOString,
      'L4LController.getClientObjectivesFilteredOnActive() queryCOString=' +
      queryCOString,
      'next-gen-nebula-apex'
    );

    List<Client_Objective__c> retlist = Database.query(queryCOString);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectivesFilteredOnActive()() returning retlist.size()=' +
      retlist.size(),
      'L4LController.getClientObjectivesFilteredOnActive()() returning retlist.size()=' +
      retlist.size(),
      'next-gen-nebula-apex'
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectivesFilteredOnActive()() returning retlist=' +
      retlist,
      'L4LController.getClientObjectivesFilteredOnActive()() retlist logged',
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  @AuraEnabled(cacheable=false)
  public static String getCOActivationSummary(String clientId) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getCOActivationSummary()',
      'L4LController.getCOActivationSummary()',
      'next-gen-nebula-apex'
    );

    String queryString =
      'SELECT count(id) active FROM client_objective__c ' +
      'WHERE client__c = :clientId AND active__c = TRUE group by active__c';

    List<AggregateResult> active = new List<AggregateResult>();
    active = Database.query(queryString);
    Integer activeInt;
    if (active.size() == 0) {
      activeInt = 0;
    } else {
      activeInt = (Integer) active[0].get('active');
    }
    queryString =
      'SELECT count(id) inactive FROM client_objective__c ' +
      'WHERE client__c = :clientId AND (active__c != TRUE or active__c=null) group by active__c';

    List<AggregateResult> inactive = new List<AggregateResult>();
    inactive = Database.query(queryString);
    Integer inactiveInt;
    if (inactive.size() == 0) {
      inactiveInt = 0;
    } else {
      inactiveInt = (Integer) inactive[0].get('deactivated');
    }

    Integer totalInt = activeInt + inactiveInt;

    String retStr =
      '{"active":' +
      activeInt +
      ',' +
      '"inactive":' +
      inactiveInt +
      ',' +
      '"total":' +
      totalInt +
      '}';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getCOActivationSummary() retstr=' + retstr,
      'L4LController.getCOActivationSummary() retstr=' + retstr,
      'next-gen-nebula-apex'
    );

    return retstr;
  }

  @AuraEnabled(cacheable=false)
  public static Client_Objective__c deactivateClientObjective(
    String clientObjectiveId
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientObjectiveId,
      'L4LController.deactivateClientObjective()',
      'L4LController.deactivateClientObjective()',
      'next-gen-nebula-apex'
    );

    client_objective__c co = [
      SELECT id, active__c
      FROM client_objective__c
      WHERE id = :clientObjectiveId
    ];
    co.active__c = false;
    update co;

    return co;
  }

  @AuraEnabled
  public static List<Objective__c> getUnusedObjectives(String clientId) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getUnusedObjectives()',
      'L4LController.getUnusedObjectives()',
      'next-gen-nebula-apex'
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController:getUnusedObjectives(): SELECT Id, Name, Program__c, SD_Name__c ' +
        ' FROM Objective__c ' +
        ' WHERE Id NOT IN ( ' +
        ' SELECT Objective__c ' +
        ' FROM Client_Objective__c ' +
        ' WHERE Client__c = :clientId ORDER BY Program__c, Name )' +
        ' AND status__c="Active"',
      'L4LController.getUnusedObjectives()',
      'next-gen-nebula-apex'
    );

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

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getUnusedObjectives() returning retlist=' + retlist,
      'L4LController.getUnusedObjectives()',
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  @AuraEnabled
  public static List<Objective__c> getUnusedObjectivesBySearch(
    String clientId,
    String searchstring
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getUnusedObjectivesBySearch() searchString=' +
      searchString,
      'L4LController.getUnusedObjectivesBySearch()',
      'next-gen-nebula-apex'
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'getUnusedObjectivesBySearch(): SELECT Id, Name, Program__c, SD_Name__c ' +
        ' FROM Objective__c ' +
        ' WHERE Id NOT IN ( ' +
        ' SELECT Objective__c ' +
        ' FROM Client_Objective__c ' +
        ' WHERE Client__c = :clientId ORDER BY Program__c, Name )' +
        ' AND status__c="Active" and Name like...',
      'L4LController.getUnusedObjectivesBySearch()',
      'next-gen-nebula-apex'
    );

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

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getUnusedObjectivesBySearch() returning retlist=' +
      retlist,
      'L4LController.getUnusedObjectivesBySearch()',
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  @AuraEnabled
  public static void deleteSessionObjectives(String sessionid) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      sessionId,
      'L4LController.deleteSessionObjectives() sessionId=' + sessionId,
      'L4LController.deleteSessionObjectives()',
      'next-gen-nebula-apex'
    );

    delete [SELECT id FROM Session_Obj__c WHERE session__c = :sessionid];
  }

  @AuraEnabled
  public static Integer createSessionObjectivesByArrayWithOrderedResults(
    String jsonstr,
    String sess,
    String skillstring
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults() jsonstr=' +
        jsonstr +
        ' sess=' +
        sess +
        'skillstring=' +
        skillstring,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults()',
      'next-gen-nebula-apex'
    );

    //test written
    System.debug('jsonstr:' + jsonstr);
    System.debug('sess:' + sess);
    System.debug('skillstring:' + skillstring);

    //deserialise the object array
    List<Client_Objective__c> objDeserialized = (List<Client_Objective__c>) JSON.deserializeStrict(
      jsonstr,
      List<Client_Objective__c>.class
    );

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults() objDeserialized==' +
      objDeserialized,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults()',
      'next-gen-nebula-apex'
    );

    List<L4LController.SessionResult> sessionresults = (List<L4LController.SessionResult>) JSON.deserializeStrict(
      skillstring,
      List<L4LController.SessionResult>.class
    );

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults() sessionresults==' +
      sessionresults,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults()',
      'next-gen-nebula-apex'
    );

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

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults() soList=' +
      soList,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults()',
      'next-gen-nebula-apex'
    );

    insert soList;

    return soList.size();
  }

  @AuraEnabled
  public static Integer createClientObjectivesByArray(
    String jsonstr,
    String sess
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.createClientObjectivesByArray() jsonstr=' + jsonstr,
      'L4LController.createClientObjectivesByArray()',
      'next-gen-nebula-apex'
    );

    //deserailise the object array
    List<Objective__c> objDeserialized = (List<Objective__c>) JSON.deserializeStrict(
      jsonstr,
      List<Objective__c>.class
    );

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

    insert coList;

    return objDeserialized.size();
  }

  @AuraEnabled
  public static Integer setSessionObjectivesByArray(
    String jsonstr,
    String val
  ) {
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logDebug(
      null,
      'L4LController.setSessionObjectivesByArray jsonstr=' +
        jsonstr +
        ' val=' +
        val,
      'L4LController.setSessionObjectivesByArray',
      'next-gen-nebula-apex'
    );

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

    return soDeserialized.size();
  }

  public class SessionResult {
    public String skill { get; set; }
  }
}
