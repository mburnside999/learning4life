public with sharing class L4LController {
  // As of January 17, 2022 this is the controller for all L4L lwcs

  @AuraEnabled(cacheable=false)
  public static List<Session_obj__c> getSessionObjectives(String sess) {
    System.debug('>>>>>> in getSessionObjectives (sess)');
    //test written
    return [
      SELECT
        Id,
        Name,
        Objective__c,
        Objective_Name__c,
        Correct__c,
        Incorrect__c,
        Prompted__c,
        SD__c,
        Program__c,
        Comment__c,
        Previous_Status__c
      FROM Session_Obj__c
      WHERE Session__c = :sess
      ORDER BY Name
    ];
  }

  @AuraEnabled
  public static List<Client_Objective__c> getClientObjectivesForSession(
    String searchKey
  ) {
    //test written
    System.debug('>>>>>> getClientObjectivesForSession(searchKey)');
    System.debug('>>>>>> searchKey=' + searchKey);

    return [
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
    ];
  }

  @AuraEnabled(cacheable=false)
  public static List<Client_Objective__c> getClientObjectives(String clientId) {
    //test written
    System.debug('>>>>>> in getClientObjectives(clientId)');
    System.debug('>>>>>> clientId=' + clientId);
    System.debug('>>>>>> cacheable=false');

    return [
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
    ];
  }

  @AuraEnabled
  public static List<Objective__c> getUnusedObjectives(String clientId) {
    System.debug('>>>>>> in getUnusedObjectives(clientId)');
    System.debug('>>>>>> clientId=' + clientId);
    //test written
    return [
      SELECT Id, Name, Program__c, SD_Name__c
      FROM Objective__c
      WHERE
        Id NOT IN (
          SELECT Objective__c
          FROM Client_Objective__c
          WHERE Client__c = :clientId
        )
      ORDER BY Program__c, Name
    ];
  }

  @AuraEnabled
  public static void deleteSessionObjectives(String sessionid) {
    //test written
    System.debug('>>>>>> in deleteSessionObjectives(sessionid)');
    delete [SELECT id FROM Session_Obj__c WHERE session__c = :sessionid];
  }

  @AuraEnabled
  public static Integer createSessionObjectivesByArrayWithOrderedResults(
    String jsonstr,
    String sess,
    String skillstring
  ) {
    System.debug(
      '>>>>>> in createSessionObjectivesByArrayWithOrderedResults(jsonstr,sess,skillstr)'
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

    List<L4LController.SessionResult> sessionresults = (List<L4LController.SessionResult>) JSON.deserializeStrict(
      skillstring,
      List<L4LController.SessionResult>.class
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
          }
          when 'I' {
            // when block 2
            so.Correct__c = false;
            so.Incorrect__c = true;
            so.Prompted__c = false;
          }
          when 'P' {
            // when block 3
            so.Correct__c = false;
            so.Incorrect__c = false;
            so.Prompted__c = true;
          }
        }
        so.previous_status__c = o.status__c;
        soList.add(so);
      }
    }

    insert soList;
    return soList.size();
  }

  @AuraEnabled
  public static Integer createClientObjectivesByArray(
    String jsonstr,
    String sess
  ) {
    //test written
    System.debug('>>>>>> in createClientObjectivesByArray(jsonstr,sess)');
    System.debug('jsonstr:' + jsonstr);
    System.debug('sess:' + sess);
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
    //test written
    System.debug('>>>>>> in setSessionObjectivesByArray(jsonstr,val)');
    System.debug('jsonstr:' + jsonstr);
    System.debug('val:' + val);
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
          update so;
        }
        when 'Incorrect' {
          so.Correct__c = false;
          so.Incorrect__c = true;
          so.Prompted__c = false;
          update so;
        }
        when 'Prompted' {
          so.Correct__c = false;
          so.Incorrect__c = false;
          so.Prompted__c = true;
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
