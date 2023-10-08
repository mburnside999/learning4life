/**************************************************************
 * @author	Mike Burnside
 * @name L4LController
 * @date	2022
 * @group Learning For Life
 *
 * @description	Main LWC controller class.
 *
 */
@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class L4LController {
  /*******************************************************************************************************
   * @description Returns the status of a given session
   * @param recordId The Session ID
   *
   * @return Session status
   *
   * @example
   * String status=L4LController.getSessionStatus(recordId);
   */

  @AuraEnabled(cacheable=false)
  public static String getSessionStatus(String recordId) {
    final String SCENARIO = 'Manage Sessions - Get Session Status - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      recordId,
      'in L4LController.getSessionStatus()',
      SCENARIO,
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return sessionStatus;
  }

  /*******************************************************************************************************
   * @description Returns a list of 50 popular Client Objectives, ignoring those that
   * have been already allocated to the client.
   *
   * @param clientId The client Id
   * @return List of popular Client Objectives
   *
   * @example
   * List<client_objective__c> coList = L4LController.getPopularObjectives(clientId)
   */

  @AuraEnabled(cacheable=false)
  public static List<Objective__c> getPopularObjectives(String clientId) {
    final String SCENARIO = 'Manage Client Objectives - Get Popular COs - Apex';

    List<objective__c> objList = new List<Objective__c>();
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getPopularObjectives()',
      SCENARIO,
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
      SCENARIO,
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return objList;
  }

  /*******************************************************************************************************
   * @description Returns a list of 50 popular Client BOC, ignoring those that
   * have been already allocated to the client.
   *
   * @param clientId The client Id
   * @return List of popular Client Objectives
   *
   * @example
   * List<client_BOC__c> cbocList = L4LController.getPopularCBOC(clientId)
   */

  @AuraEnabled(cacheable=false)
  public static List<Behaviour_of_Concern__c> getPopularCBOC(String clientId) {
    final String SCENARIO = 'Manage Client Objectives - Get Popular CBOCs - Apex';

    List<Behaviour_of_Concern__c> bocList = new List<Behaviour_of_Concern__c>();
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getPopularCBOC()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    AggregateResult[] popularCBOC = [
      SELECT Behaviour_of_Concern__c, count(id) idcount
      FROM client_boc__c
      WHERE client__c != :clientId
      GROUP BY Behaviour_of_Concern__c
      ORDER BY count(id) DESC
      LIMIT 50
    ];

    List<id> objids = new List<id>();

    for (AggregateResult ar : popularCBOC) {
      objids.add((Id) ar.get('Behaviour_of_Concern__c'));
    }
    bocList = [
      SELECT Id, Name
      FROM Behaviour_of_Concern__c
      WHERE
        id IN :objids
        AND Id NOT IN (
          SELECT Behaviour_of_Concern__c
          FROM Client_BOC__c
          WHERE Client__c = :clientId
        )
    ];

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getPopularCBOC() returning objList=' + bocList,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return bocList;
  }

  /*******************************************************************************************************
   * @description Returns a list of active Client BOC for a Client
   *
   * @param clientId The client Id
   * @return List of popular Client Objectives
   *
   * @example
   * List<client_BOC__c> cbocList = L4LController.getActiveCBOC(clientId)
   */

  @AuraEnabled(cacheable=false)
  public static List<client_BOC__c> getActiveCBOCList(String clientId) {
    final String SCENARIO = 'Manage Client Objectives - Get Active CBOCs - Apex';

    List<Client_BOC__c> cbocList = new List<Client_BOC__c>();

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getActiveCBOCList()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    cbocList = [
      SELECT
        Id,
        Behaviour_Of_Concern__c,
        client__c,
        clinical_notes__c,
        end_Date__c,
        start_Date__c,
        status__c
      FROM Client_BOC__c
      WHERE Client__c = :clientId AND status__c = 'Active'
    ];

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getActiveCBOCList() returning cbocList=' + cbocList,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return cbocList;
  }

  /*******************************************************************************************************
   * @description returns a list session objectives for a session.
   *
   * @param sess The session Id
   * @return List of session objectives
   *
   * @example
   * List<session_obj__c> soList = L4LController.getSessionObjectives(sess)
   */

  @AuraEnabled(cacheable=false)
  public static List<Session_obj__c> getSessionObjectives(String sess) {
    final String SCENARIO = 'Manage Session - Get Session Objectives - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      sess,
      'L4LController.getSessionObjectives()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String debugsoql =
      'SELECT Id,Name,Objective__c,Objective_Name__c,Correct__c,NonResponsive__c,' +
      'Incorrect__c,Prompted__c,SD__c,Program__c,Comment__c,Previous_Status__c' +
      ' FROM Session_Obj__c WHERE Session__c = :sess ORDER BY Name';

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.getSessionObjectives() soql=' + debugsoql,
      SCENARIO,
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description returns a list of session BOCs for a session.
   *
   * @param sess The session Id
   * @return List of session objectives
   *
   * @example
   * List<Session_BOC__c> soList = L4LController.getSessionBOC(sess)
   */

  @AuraEnabled(cacheable=false)
  public static List<Session_BOC__c> getSessionBOC(String sess) {
    final String SCENARIO = 'Manage Session - Get Session BOC- Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      sess,
      'L4LController.getSessionBCO()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String debugsoql =
      'SELECT Id,Client_BOC__c,Comments__c,Duration_Mins__c,Intensity__c,Occurrences__c,Session__c,Name ' +
      'FROM Session_BOC__c ' +
      ' WHERE Session__c = ' +
      sess +
      'ORDER BY Behaviour__c,CreatedDate';

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.getSessionBCO() soql=' + debugsoql,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Session_BOC__c> retlist = new List<Session_BOC__c>(
      [
        SELECT
          Id,
          Client_BOC__c,
          Comments__c,
          Duration_Mins__c,
          Intensity__c,
          Occurrences__c,
          Session__c,
          Behaviour__c,
          Name
        FROM Session_BOC__c
        WHERE Session__c = :sess
        ORDER BY Behaviour__c, CreatedDate
      ]
    );

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.getSessionBOC() returning retlist=' + retlist,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a list of ACTIVE Client BOC for a sesssion
   *
   *
   * TODO fix parameter name
   *
   * @param sessionId The session Id
   * @return List of Client Objectives
   *
   * @example
   * List<client_boc__c> coList = L4LController.getClientBOCForSession(sessionId)
   */

  @AuraEnabled
  public static List<Client_BOC__c> getClientBOCForSession(String sessionId) {
    final String SCENARIO = 'Manage Session - Get Client BOC for a Session - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      sessionId,
      'L4LController.getClientBOCForSession()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String debugsoql =
      'SELECT Id,Behaviour_of_Concern__c,BOC_Name__c,Client__c,Start_Date__c,End_Date__c,Clinical_Notes__c,Status__c' +
      'FROM Client_BOC__c WHERE active__c = TRUE AND Client__c IN (SELECT client__c FROM session__c WHERE id =' +
      sessionId +
      ') ORDER BY BOC_Name__c';

    L4LNebulaComponentController.logDebug(
      sessionId,
      'L4LController.getClientBOCForSession() debugsoql=' + debugsoql,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Client_BOC__c> retlist = new List<Client_BOC__c>(
      [
        SELECT
          Id,
          Behaviour_of_Concern__c,
          BOC_Name__c,
          Client__c,
          Start_Date__c,
          End_Date__c,
          Clinical_Notes__c,
          Status__c
        FROM Client_BOC__c
        WHERE
          status__c = 'Active'
          AND Client__c IN (
            SELECT client__c
            FROM session__c
            WHERE id = :sessionId
          )
        ORDER BY BOC_Name__c
      ]
    );

    L4LNebulaComponentController.logDebug(
      sessionId,
      'L4LController.getClientBOCForSession() returning retlist=' + retlist,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a list of ACTIVE Client Objectives for a sesssion ordered by
   * Program Name
   *
   * TODO fix parameter name
   *
   * @param searchKey The session Id
   * @return List of Client Objectives
   *
   * @example
   * List<client_objective__c> coList = L4LController.getClientObjectivesForSession(sessionId)
   */

  @AuraEnabled
  public static List<Client_Objective__c> getClientObjectivesForSession(
    String searchKey
  ) {
    final String SCENARIO = 'Manage Session - Get Client Objectives for a Session - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      searchKey,
      'L4LController.getClientObjectivesForSession()',
      SCENARIO,
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
      SCENARIO,
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a list of Client Objectives for a client, ordered by Program Name, Name
   *
   * TODO fix parameter name
   *
   * @param clientId The client Id
   * @return List of Client Objectives
   *
   * @example
   * List<client_objective__c> coList = L4LController.getClientObjectives(clientId)
   */

  @AuraEnabled(cacheable=false)
  public static List<Client_Objective__c> getClientObjectives(String clientId) {
    final String SCENARIO = 'Manage Client Objectives - Get Client Objectives for a Client - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getClientObjectives()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String debugsoql =
      'SELECT Id,Name,Client__c,Objective_Name__c,SD_Name__c,Program_Name__c,' +
      'Status__c,Frequency__c,Last_Tested_Correct__c,Re_Test_Recommended__c,Client_Objective_Notes__c' +
      ' FROM Client_Objective__c WHERE active__c=true and Client__c = :clientId ORDER BY Program_Name__c, Name';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectives() debugsoql=' + debugsoql,
      SCENARIO,
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectives() returning retlist=' + retlist,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a list of all, or active only Client Objectives for a client, ordered by Program Name, Name
   *
   * @param clientId The client Id
   * @param showActiveOnly Flag to indicate whether to show the ACTIVE objectives only
   * @return list of Client Objectives
   *
   * @example
   * List<client_objective__c> coList = L4LController.getClientObjectivesFilteredOnActive(clientId,true)
   */

  @AuraEnabled(cacheable=false)
  public static List<Client_Objective__c> getClientObjectivesFilteredOnActive(
    String clientId,
    boolean showActiveOnly
  ) {
    final String SCENARIO = 'Manage Client Objectives - Get (Active) or all Client Objectives for a Client - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getClientObjectivesFilteredOnActive()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String queryCOString =
      'SELECT Id,Name,Client__c,Objective_Name__c,SD_Name__c,Program_Name__c,' +
      'Status__c,Frequency__c,Last_Tested_Correct__c,Re_Test_Recommended__c,Client_Objective_Notes__c,active__c ' +
      ' FROM Client_Objective__c WHERE Client__c = :clientId ';

    if (showActiveOnly) {
      queryCOString += ' and active__c=true';
    }

    queryCOString += ' ORDER BY Program_Name__c, Name';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectivesFilteredOnActive() queryCOString=' +
      queryCOString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Client_Objective__c> retlist = Database.query(queryCOString);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectivesFilteredOnActive()() returning retlist.size()=' +
      retlist.size(),
      SCENARIO,
      'next-gen-nebula-apex'
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientObjectivesFilteredOnActive()() returning retlist=' +
      retlist,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a list of all, or active only Client BOC for a client
   *
   * @param clientId The client Id
   * @param showActiveOnly Flag to indicate whether to show the ACTIVE objectives only
   * @return list of Client_BOC
   *
   * @example
   * List<client_boc__c> cbocList = L4LController.getClientBOCFilteredOnActive(clientId,true)
   */

  @AuraEnabled(cacheable=false)
  public static List<Client_BOC__c> getClientBOCFilteredOnActive(
    String clientId,
    boolean showActiveOnly
  ) {
    final String SCENARIO = 'Manage Client BOC  - Get (Active) or all Client_BOC for a Client - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getClientBOCFilteredOnActive()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    String queryCBOCString =
      'SELECT Name,BOC_Name__c,Client__c,Status__c,Start_Date__c,End_Date__c, Clinical_Notes__c ' +
      ' FROM Client_BOC__c WHERE Client__c = :clientId ';

    if (showActiveOnly) {
      queryCBOCString += ' and status__c=\'Active\'';
    }

    queryCBOCString += ' ORDER BY Name';

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientBOCFilteredOnActive() queryCBOCString=' +
      queryCBOCString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Client_BOC__c> retlist = Database.query(queryCBOCString);

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientBOCFilteredOnActive()() returning retlist.size()=' +
      retlist.size(),
      SCENARIO,
      'next-gen-nebula-apex'
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getClientBOCFilteredOnActive()() returning retlist=' +
      retlist,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a JSON  string summarising ACTIVE, INACTIVE and TOTAL
   * Client Objectives for a client
   *
   * @param clientId The client Id
   * @return JSON string summary of statuses
   *
   * @example
   * String aggStr = L4LController.getCOActivationSummary(clientId)
   * aggStr contains JSON string: {"active":20, "inactive":5,"total",25}
   */

  @AuraEnabled(cacheable=false)
  public static String getCOActivationSummary(String clientId) {
    final String SCENARIO = 'Manage Client Objectives - JSON active/inactive summary - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getCOActivationSummary()',
      SCENARIO,
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
      inactiveInt = (Integer) inactive[0].get('inactive');
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retstr;
  }

  /*******************************************************************************************************
   * @description Deactivates a Client Objective
   * @param clientObjectiveId The Client Objective Id
   * @return The deactivated client objective
   *
   * @example
   * List<client_objective__c> coList = L4LController.deactivateClientObjective(clientObjectiveId)
   */

  @AuraEnabled(cacheable=false)
  public static Client_Objective__c deactivateClientObjective(
    String clientObjectiveId
  ) {
    final String SCENARIO = 'Manage Client Objectives - deactivate a CO - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientObjectiveId,
      'L4LController.deactivateClientObjective()',
      SCENARIO,
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

  /*******************************************************************************************************
   * @description Returns a list of all active objectives not yet assigned to a client
   * @param clientId The Client Objective Id
   * @return List of client objectives not assigned to client
   *
   * @example
   * List<objective__c> coList = L4LController.getUnusedObjectives(clientObjectiveId)
   */

  @AuraEnabled
  public static List<Objective__c> getUnusedObjectives(String clientId) {
    final String SCENARIO = 'Manage Client Objectives - return a list of candidate (unused) objectives - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getUnusedObjectives()',
      SCENARIO,
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a list of all active objectives not yet assigned to a client
   * @param clientId The Client Objective Id
   * @return List of client objectives not assigned to client
   *
   * @example
   * List<objective__c> coList = L4LController.getUnusedBOC(clientId)
   */

  @AuraEnabled
  public static List<Behaviour_of_Concern__c> getUnusedBOC(String clientId) {
    final String SCENARIO = 'Manage Client BOC - return a list of candidate (unused) BOC - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getUnusedBOC()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    //  L4LNebulaComponentController.logDebug(
    //    clientId,
    //    'L4LController:getUnusedObjectives(): SELECT Id, Name, Program__c, SD_Name__c ' +
    //    ' FROM Objective__c ' +
    //    ' WHERE Id NOT IN ( ' +
    //    ' SELECT Objective__c ' +
    //    ' FROM Client_Objective__c ' +
    //    ' WHERE Client__c = :clientId ORDER BY Program__c, Name )' +
    //    ' AND status__c="Active"',
    //    'L4LController.getUnusedObjectives()',
    //    'next-gen-nebula-apex'
    //  );

    //test written
    List<Behaviour_of_Concern__c> retlist = new List<Behaviour_of_Concern__c>(
      [
        SELECT Id, Name
        FROM Behaviour_of_Concern__c
        WHERE
          Id NOT IN (
            SELECT Behaviour_of_Concern__c
            FROM Client_BOC__c
            WHERE Client__c = :clientId
          )
        ORDER BY Name
      ]
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getUnusedBOC() returning retlist=' + retlist,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a list of all active objectives not yet assigned to this client 
   * that have a Name like %searchString%
   * 
   * @param clientId The Client Objective Id
   * @param searchstring The search string for the name

   * @return list of client objectives not assigned to client
   *
   * @example
   * List<objective__c> coList = L4LController.getUnusedObjectivesBySearch(clientId,'Banana')
   */

  @AuraEnabled
  public static List<Objective__c> getUnusedObjectivesBySearch(
    String clientId,
    String searchstring
  ) {
    final String SCENARIO = 'Manage Client Objectives - search for a list of candidate (unused) objectives  by keyword - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getUnusedObjectivesBySearch() searchString=' +
      searchString,
      SCENARIO,
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Returns a list of all active objectives not yet assigned to this client 
   * that have a Name like %searchString%
   * 
   * @param clientId The Client Objective Id
   * @param searchstring The search string for the name

   * @return list of client objectives not assigned to client
   *
   * @example
   * List<objective__c> coList = L4LController.getUnusedBOCBySearch(clientId,'Banana')
   */

  @AuraEnabled
  public static List<Behaviour_of_Concern__c> getUnusedBOCBySearch(
    String clientId,
    String searchstring
  ) {
    final String SCENARIO = 'Manage Client BOC - search for a list of candidate (unused) BOC  by keyword - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.getUnusedBOCBySearch() searchString=' + searchString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'getUnusedBOCBySearch(): SELECT Id, Name ' +
      ' FROM Behaviour_of_Concern__c ' +
      ' WHERE Id NOT IN ( ' +
      ' SELECT Behaviour_of_Concern__c ' +
      ' FROM Client_BOC__c ' +
      ' WHERE Client__c = :clientId ORDER BY Name )' +
      ' and Name like...',
      'L4LController.getUnusedBOCBySearch()',
      'next-gen-nebula-apex'
    );

    searchstring = '%' + searchstring + '%';

    List<Behaviour_of_Concern__c> retlist = new List<Behaviour_of_Concern__c>(
      [
        SELECT Id, Name
        FROM Behaviour_of_Concern__c
        WHERE
          Id NOT IN (
            SELECT Behaviour_of_Concern__c
            FROM Client_BOC__c
            WHERE Client__c = :clientId
          )
          AND Name LIKE :searchstring
        ORDER BY Name
      ]
    );

    L4LNebulaComponentController.logDebug(
      clientId,
      'L4LController.getUnusedBOCBySearch() returning retlist=' + retlist,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    return retlist;
  }

  /*******************************************************************************************************
   * @description Delete all session objectives for the session 
   * that have a Name like %searchString%
   * 
   * @param sessionid The Session Id

   * @return void
   *
   * @example
   * L4LController.deleteSessionObjectives(sessionid)
   */

  @AuraEnabled
  public static void deleteSessionObjectives(String sessionid) {
    final String SCENARIO = 'Manage Session Objectives - delete all Session Objectives for a Session - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      sessionId,
      'L4LController.deleteSessionObjectives() sessionId=' + sessionId,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    delete [SELECT id FROM Session_Obj__c WHERE session__c = :sessionid];
  }

  /*******************************************************************************************************
   * @description For a given session, for each client objective in a list create session objectives
   * from its list of DTD scores
   *
   * @param jsonstr A JSON string containing a list of client objectives
   * @param sess The session Id
   * @param skillstring A JSON string containing a list of DTD scores
   *
   * @return the number of session objectives added
   *
   * @example
   * Integer noOfCreatedSessionObjs = L4LController.createSessionObjectivesByArrayWithOrderedResults(jsonStr,sess,skillstring)
   */

  @AuraEnabled
  public static List<Session_Obj__c> createSessionObjectivesByArrayWithOrderedResults(
    String jsonstr,
    String sess,
    String skillstring
  ) {
    final String SCENARIO = 'Manage Session Objectives - create assessments C,I,N,P from a sequence - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      sess,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults() jsonstr=' +
      jsonstr +
      ' sess=' +
      sess +
      'skillstring=' +
      skillstring,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    //deserialise the object array
    List<Client_Objective__c> objDeserialized = (List<Client_Objective__c>) JSON.deserializeStrict(
      jsonstr,
      List<Client_Objective__c>.class
    );

    L4LNebulaComponentController.logDebug(
      sess,
      'L4LController.createSessionObjectivesByArrayWithOrderedResults() objDeserialized==' +
      objDeserialized,
      SCENARIO,
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
      SCENARIO,
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
      SCENARIO,
      'next-gen-nebula-apex'
    );

    insert soList;
    return soList;
    //return soList.size();
  }

  /*******************************************************************************************************
   * @description For a given session, for each client objective in a list create session objectives
   * from its list of DTD scores
   *
   * @param jsonstr A JSON string containing a list of client objectives
   * @param sess The session Id
   * @param skillstring A JSON string containing a list of DTD scores
   *
   * @return the number of session objectives added
   *
   * @example
   * Integer noOfCreatedSessionObjs = L4LController.createSessionBOCByArrayWithOrderedResults(jsonStr,sess,skillstring)
   */

  @AuraEnabled
  public static List<Session_BOC__c> createSessionBOCByArrayWithOrderedResults(
    String jsonstr,
    String sess,
    String skillstring
  ) {
    final String SCENARIO = 'Manage Session BOC - create BOC records from a sequence - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      sess,
      'L4LController.createSessionBOCByArrayWithOrderedResults() jsonstr=' +
      jsonstr +
      ' sess=' +
      sess +
      'skillstring=' +
      skillstring,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    //deserialise the object array
    //  List<Client_Objective__c> objDeserialized = (List<Client_Objective__c>) JSON.deserializeStrict(
    //    jsonstr,
    //    List<Client_Objective__c>.class
    //  );

    //  L4LNebulaComponentController.logDebug(
    //    sess,
    //    'L4LController.createSessionObjectivesByArrayWithOrderedResults() objDeserialized==' +
    //    objDeserialized,
    //    SCENARIO,
    //    'next-gen-nebula-apex'
    //  );

    //  List<L4LController.SessionResult> sessionresults = (List<L4LController.SessionResult>) JSON.deserializeStrict(
    //    skillstring,
    //    List<L4LController.SessionResult>.class
    //  );

    //  L4LNebulaComponentController.logDebug(
    //    sess,
    //    'L4LController.createSessionObjectivesByArrayWithOrderedResults() sessionresults==' +
    //    sessionresults,
    //    SCENARIO,
    //    'next-gen-nebula-apex'
    //  );

    // // prepare a list for insertion in bulk
    List<Session_BOC__c> sbocList = new List<Session_BOC__c>();

    //  // loop thru the deserialised objectives
    //  for (Client_Objective__c o : objDeserialized) {
    //    for (L4LController.SessionResult mbsr : sessionresults) {
    //      // prepare a session_obj__c and add to array
    //      Session_Obj__c so = new Session_Obj__c();
    //      so.Session__c = sess;
    //      so.Objective__c = o.Objective__c;
    //      switch on mbsr.skill {
    //        when 'C' {
    //          // when block 1
    //          so.Correct__c = true;
    //          so.Incorrect__c = false;
    //          so.Prompted__c = false;
    //          so.NonResponsive__c = false;
    //        }
    //        when 'N' {
    //          // when block 1
    //          so.Correct__c = false;
    //          so.Incorrect__c = false;
    //          so.Prompted__c = false;
    //          so.NonResponsive__c = true;
    //        }
    //        when 'I' {
    //          // when block 2
    //          so.Correct__c = false;
    //          so.Incorrect__c = true;
    //          so.Prompted__c = false;
    //          so.NonResponsive__c = false;
    //        }
    //        when 'P' {
    //          // when block 3
    //          so.Correct__c = false;
    //          so.Incorrect__c = false;
    //          so.Prompted__c = true;
    //          so.NonResponsive__c = false;
    //        }
    //      }
    //      so.previous_status__c = o.status__c;
    //      soList.add(so);
    //    }
    //  }

    //  L4LNebulaComponentController.logDebug(
    //    sess,
    //    'L4LController.createSessionObjectivesByArrayWithOrderedResults() soList=' +
    //    soList,
    //    SCENARIO,
    //    'next-gen-nebula-apex'
    //  );

    //insert soList;
    return sbocList;
  }

  /*******************************************************************************************************
   * @description Create client BOC from a JSON list of boc
   *
   * @param jsonstr A JSON string containing a list of objectives
   * @param clientId The Client Id
   *
   * @return The number of client BOC added
   *
   * @example
   * Integer noOfCreatedClientBOCs = L4LController.createClientBOCByArray(jsonStr,sess)
   */

  @AuraEnabled
  public static Integer createClientBOCByArray(
    String jsonstr,
    String clientId
  ) {
    final String SCENARIO = 'Manage Client BOC - create Client BOC from a JSON array - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      clientId,
      'L4LController.createClientBOCByArray() jsonstr=' + jsonstr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    //deserailise the object array
    List<Behaviour_of_Concern__c> objDeserialized = (List<Behaviour_of_Concern__c>) JSON.deserializeStrict(
      jsonstr,
      List<Behaviour_of_Concern__c>.class
    );

    // // prepare a list for insertion in bulk
    List<Client_BOC__c> cbocList = new List<Client_BOC__c>();

    // loop thru the deserialised objectives
    for (Behaviour_of_Concern__c boc : objDeserialized) {
      // prepare a sess_obj__c and add to array
      Client_BOC__c cboc = new Client_BOC__c();
      cboc.Client__c = clientId;
      cboc.Behaviour_of_Concern__c = boc.Id;
      cboc.Status__c = 'Active';
      cbocList.add(cboc);
    }

    insert cbocList;

    return objDeserialized.size();
  }

  /*******************************************************************************************************
   * @description Create client objectives from a JSON list of objectives
   *
   * @param jsonstr A JSON string containing a list of objectives
   * @param sess The session Id
   *
   * @return The number of client objectives added
   *
   * @example
   * Integer noOfCreatedClientObjs = L4LController.createClientObjectivesByArray(jsonStr,sess)
   */

  @AuraEnabled
  public static Integer createClientObjectivesByArray(
    String jsonstr,
    String sess
  ) {
    final String SCENARIO = 'Manage Client Objectives - create Client Objectives from a JSON array - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      sess,
      'L4LController.createClientObjectivesByArray() jsonstr=' + jsonstr,
      SCENARIO,
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

  /*******************************************************************************************************
   * @description Update session objective scores from a JSON list
   *
   * @param jsonstr A JSON string containing a list of session objectives to update
   * @param val The score - "Correct" or "Incorrect" ...etc
   *
   * @return The number of session objectives updated
   *
   * @example
   * Integer noOfSessionObjsUpdated = L4LController.setSessionObjectivesByArray(jsonStr,'Correct')
   */

  @AuraEnabled
  public static Integer setSessionObjectivesByArray(
    String jsonstr,
    String val
  ) {
    final String SCENARIO = 'Manage Session Objectives - update scores C,I,N,P from a JSON array - Apex';
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'L4LController.setSessionObjectivesByArray jsonstr=' +
      jsonstr +
      ' val=' +
      val,
      SCENARIO,
      'next-gen-nebula-apex'
    );

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

  /*******************************************************************************************************
   * @description Simple minded create a Session BOC -- for testing clone idea
   *
   * @param clientBOCId
   * @param sessionId
   * @param intensity
   * @param mins
   * @param occurrences
   * @param comments


   * @return The number of session BOC created (1)
   *
   * @example
   * Integer i = L4LController.createSessionBOC(...)
   */

  @AuraEnabled
  public static Integer createSessionBOC(
    String clientBOCId,
    String sessionId,
    String intensity,
    Decimal mins,
    Decimal occurrences,
    String comments
  ) {
    final String SCENARIO = 'Create Session BOC';
    L4LNebulaComponentController.setupCache();

    L4LNebulaComponentController.logInfo(
      clientBOCId,
      'L4LController.createSessionBOC()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Session_BOC__c sboc = new Session_BOC__c(
      Client_BOC__c = clientBOCId,
      Session__c = sessionId,
      Intensity__c = intensity,
      Duration_Mins__c = mins,
      Occurrences__c = occurrences,
      Comments__c = comments
    );

    insert sboc;

    return 1;
  }

  /*******************************************************************************************************
   * @description Update session objective scores from a JSON list
   *
   * @param jsonstr A JSON string containing a list of session objectives to update
   * @param val The score - "Correct" or "Incorrect" ...etc
   *
   * @return The number of session objectives updated
   *
   * @example
   * Integer noOfSessionObjsUpdated = L4LController.setSessionBOCByArray(jsonStr,'Correct')
   */

  @AuraEnabled
  public static Integer setSessionBOCByArray(String jsonstr, String val) {
    final String SCENARIO = 'Manage Session BOC';
    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'L4LController.setSessionBOCByArray jsonstr=' +
      jsonstr +
      ' val=' +
      val,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Session_BOC__c> soDeserialized = (List<Session_BOC__c>) JSON.deserializeStrict(
      jsonstr,
      List<Session_BOC__c>.class
    );

    for (Session_BOC__c so : soDeserialized) {
      switch on val {
        when 'Delete' {
          delete so;
        }
      }
    }

    return soDeserialized.size();
  }

  /*******************************************************************************************************
   * @description For a list of client objectives, update to a common status or activate/deactivate
   *
   * @param jsonstr A JSON string containing a list of client objectives to update
   * @param val "ACQ" or "OBJ" or "WEEKLY" or "FORTNIGHTLY" or "Activate" or "Deactivate"
   *
   * @return The number of client objectives updated
   *
   * @example
   * Integer noOfClientObjsUpdated = L4LController.setClientObjectivesByArray(jsonStr,'ACQ')
   * Integer noOfClientObjsActivated = L4LController.setClientObjectivesByArray(jsonStr,'Activate')

   */

  @AuraEnabled
  public static Integer setClientObjectivesByArray(String jsonstr, String val) {
    final String SCENARIO = 'Manage Client Objectives - update a CO status to ACQ/OBJ, active=true/false, or frequency Weekly/Fortnighly from a JSON array - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'L4LController.setClientObjectivesByArray jsonstr=' +
      jsonstr +
      ' val=' +
      val,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Client_Objective__c> coDeserialized = (List<Client_Objective__c>) JSON.deserializeStrict(
      jsonstr,
      List<Client_Objective__c>.class
    );

    Integer recsUpdated = 0;
    List<Client_Objective__c> updCOList = new List<Client_Objective__c>();

    for (Client_Objective__c co : coDeserialized) {
      switch on val {
        when 'ACQ' {
          if (co.Active__c == true) {
            co.Status__c = 'ACQ';
            updCOList.add(co);
            recsUpdated += 1;
          }
        }
        when 'OBJ' {
          if (co.Active__c == true) {
            co.Status__c = 'OBJ';
            updCOList.add(co);
            recsUpdated += 1;
          }
        }
        when 'WEEKLY' {
          if (co.Active__c == true) {
            co.Frequency__c = 'Weekly';
            updCOList.add(co);
            recsUpdated += 1;
          }
        }
        when 'FORTNIGHTLY' {
          if (co.Active__c == true) {
            co.Frequency__c = 'Fortnightly';
            updCOList.add(co);
            recsUpdated += 1;
          }
        }
        when 'MONTHLY' {
          if (co.Active__c == true) {
            co.Frequency__c = 'Monthly';
            updCOList.add(co);
            recsUpdated += 1;
          }
        }
        when 'TWICE-WEEKLY' {
          if (co.Active__c == true) {
            co.Frequency__c = 'Twice-Weekly';
            updCOList.add(co);
            recsUpdated += 1;
          }
        }
        when 'Deactivate' {
          co.Active__c = false;
          updCOList.add(co);
          recsUpdated += 1;
        }
        when 'Activate' {
          co.Active__c = true;
          updCOList.add(co);
          recsUpdated += 1;
        }
        // when 'Delete' {
        //   delete co;
        // }
      }
    }
    if (updCOList.size() > 0) {
      update updCOList;
    }

    return updCOList.size();
  }

  /*******************************************************************************************************
   * @description Updates Session Objective comment to "LG"
   *
   * @param sessObjId Session Objective id
   *
   * @return Summary of change to Session Objective
   *
   * @example
   * String str = L4LController.updateSessionObjectiveWithLG(sessObjId)
   *
   */

  @AuraEnabled(cacheable=false)
  public static String updateSessionObjectiveWithLG(String sessObjId) {
    final String SCENARIO = 'Manage Session Objectives - update an SO as Let-Go (LG) - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'L4LController.updateSessionObjectiveWithLG',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    final string lgcomment = 'LG';
    Session_Obj__c so = [
      SELECT id, comment__c
      FROM session_obj__c
      WHERE id = :sessObjId
      LIMIT 1
    ];
    so.comment__c = lgcomment;
    update so;
    return 'so.Id= ' + so.Id + ', comment=' + so.comment__c;
  }

  /*******************************************************************************************************
   * @description Updates Session Objective comment
   *
   * @param sessObjId Session Objective id
   * @param comment comment

   *
   * @return Summary of change to Session Objective
   *
   * @example
   * String str = L4LController.updateSessionObjectiveWithComment(sessObjId,comment)
   *
   */

  @AuraEnabled(cacheable=false)
  public static String updateSessionObjectiveWithComment(
    String sessObjId,
    String comment
  ) {
    final String SCENARIO = 'Manage Session Objectives - update an SO With comment - Apex';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'L4LController.updateSessionObjectiveWithComment',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Session_Obj__c so = [
      SELECT id, comment__c
      FROM session_obj__c
      WHERE id = :sessObjId
      LIMIT 1
    ];
    so.comment__c = comment;
    update so;
    return 'so.Id= ' + so.Id + ', comment=' + so.comment__c;
  }

  /**************************************************************
   * @author	Mike Burnside
   * @name SessionResult
   * @date	2022
   * @group Learning For Life
   *
   * @description	Helper.
   *
   */
  public class SessionResult {
    /*******************************************************************************************************
     * @description getter/setter
     *
     * @example
     *
     */
    public String skill { get; set; }
  }
}
