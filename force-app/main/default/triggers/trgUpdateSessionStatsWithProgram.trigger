trigger trgUpdateSessionStatsWithProgram on session_statistics__c(
  before insert
) {
  Logger.setScenario('trgUpdateSessionStatsWithProgram');

  Logger.debug(
      'ApexTrigger (before insert on session_statistics): trgUpdateSessionStatsWithProgram trigger.new=' +
      Trigger.New
    )
    .addTag('trgUpdateSessionStatsWithProgram')
    .addTag('logit()');

  Logger.saveLog();

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
    Logger.debug(
        'trgUpdateSessionStatsWithProgram associated program name=' +
        prog +
        ' ,record=' +
        new_ss_record
      )
      .addTag('trgUpdateSessionStatsWithProgram')
      .addTag('logit()');
    Logger.saveLog();
  }

}