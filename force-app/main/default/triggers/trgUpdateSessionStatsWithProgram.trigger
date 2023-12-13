/**************************************************************
 * @name trgUpdateSessionStatsWithProgram
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description
 *
 */

trigger trgUpdateSessionStatsWithProgram on session_statistics__c(
  before insert
) {
  String SCENARIO = 'Session Stats Trigger - before inserting attach Program Name - Apex';

  L4LNebulaComponentController.setupCache();
  L4LNebulaComponentController.logInfo(
    null,
    'ApexTrigger (before insert on session_statistics)',
    SCENARIO,
    'next-gen-nebula-apex'
  );

  for (session_statistics__c new_ss_record : Trigger.New) {
    Id objId = new_ss_record.objective__c;

    String prog = [
      SELECT SD__r.Program__r.Name
      FROM Objective__c
      WHERE id = :objId
      LIMIT 1
    ]
    .SD__r.Program__r.Name;
    new_ss_record.program_name__c = prog;

    L4LNebulaComponentController.logDebug(
      null,
      'trgUpdateSessionStatsWithProgram associated program name=' +
        prog +
        ' ,record=' +
        new_ss_record,
      SCENARIO,
      'next-gen-nebula-apex'
    );
  }

}
