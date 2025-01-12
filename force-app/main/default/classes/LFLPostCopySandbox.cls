global class LFLPostCopySandbox implements SandboxPostCopy {
  global void runApexClass(SandboxContext context) {
    System.debug('Org ID: ' + context.organizationId());
    System.debug('Sandbox ID: ' + context.sandboxId());
    System.debug('Sandbox Name: ' + context.sandboxName());

    //Programs
    StaticResource sr = [
      SELECT Id, Body
      FROM StaticResource
      WHERE Name = 'programs'
      LIMIT 1
    ];
    String body = sr.Body.toString();
    String[] filelines = body.split('\n');
    String n = 'Program__c';

    List<Program__c> programs = new List<Program__c>();
    for (Integer i = 1; i < filelines.size(); i++) {
      String[] inputvalues = new List<String>{};
      inputvalues = filelines[i].split(',');
      Program__c p = new Program__c();
      if (inputvalues[1] == '')
        continue;
      p.PID__c = inputvalues[1];
      p.Name = inputvalues[0];
      p.stage__c = inputvalues[2];
      p.status__c = inputvalues[3];
      programs.add(p);
    }
    System.debug(programs.size() + ' Programs submitted for Upsert');
    upsert programs PID__c;

    // build a map of PIDs
    Map<String, Id> pidmap = new Map<String, Id>();
    for (Program__c pr : [SELECT PID__c, Id FROM program__c]) {
      pidmap.put(pr.PID__c, pr.Id);
    }

    //SDS
    sr = [
      SELECT Id, Body
      FROM StaticResource
      WHERE Name = 'sds'
      LIMIT 1
    ];
    System.debug(sr);
    body = sr.Body.toString();
    filelines = body.split('\n');
    n = 'SD__c';
    List<SD__c> sds = new List<SD__c>();

    for (Integer i = 1; i < filelines.size(); i++) {
      String[] inputvalues = new List<String>{};
      inputvalues = filelines[i].split(',');
      //System.debug(inputvalues);
      SD__c sd = new SD__c();

      String pid = inputvalues[5];

      sd.Program__c = (Id) pidmap.get(pid);
      sd.Name = inputvalues[0];
      sd.SDID__c = inputvalues[4];
      sd.stage__c = inputvalues[1];
      sd.status__c = inputvalues[2];
      sd.area__c = inputvalues[3];
      sds.add(sd);
    }
    upsert sds SDID__c;
    System.debug(sds.size() + ' SDs submitted for Upsert');

    // build a map of SDs
    Map<String, Id> sidmap = new Map<String, Id>();
    for (SD__c sd : [SELECT SDID__c, Id FROM sd__c]) {
      sidmap.put(sd.SDID__c, sd.Id);
    }

    sr = [
      SELECT Id, Body
      FROM StaticResource
      WHERE Name = 'objectives'
      LIMIT 1
    ];
    body = sr.Body.toString();
    filelines = body.split('\n');
    n = 'Objective__c';
    List<Objective__c> objs = new List<Objective__c>();

    for (Integer i = 1; i < filelines.size(); i++) {
      String[] inputvalues = new List<String>{};
      inputvalues = filelines[i].split(',');
      Objective__c o = new Objective__c();
      if (inputvalues[1] == '')
        continue;
      String sdid = inputvalues[3];

      o.sd__c = (Id) sidmap.get(sdid);
      o.Name = inputvalues[0];
      o.OID__c = inputvalues[1];
      o.status__c = inputvalues[2];

      objs.add(o);
    }
    upsert objs OID__c;
    System.debug(objs.size() + ' Objectives submitted for Upsert');

    // Insert logic here to prepare the sandbox for use.
  }
}