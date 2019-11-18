public with sharing class MBSessionObjectives {
   

    @AuraEnabled(cacheable=true) 
    public static List<Session_obj__c> getSessionObjectives (String sess) {
        
        return [SELECT Id,Name,Objective__c,Objective_Name__c,Correct__c,Incorrect__c,Prompted__c,SD__c FROM Session_Obj__c where Session__c = :sess];
    }


 @AuraEnabled(cacheable=true) 
    public static List<Objective__c> getObjectives (String sess) {
        
        return [SELECT Id,Name,Program__c,SD_Name__c FROM Objective__c order by Program__c,Name limit 20];
    }


 @AuraEnabled
    public static void deleteSessionObjectives (String sessionid) {
       delete [select id from Session_Obj__c where session__c=:sessionid];
      }

 @AuraEnabled
    public static void createSessionObjectives (String sessionid, String objective) {
        
Session_Obj__c so = new Session_Obj__c();
so.session__c=sessionid;
so.objective__c=objective;
so.Correct__C=false;
so.Incorrect__c=false;
so.Prompted__c=false;

insert so;


        
    }
@AuraEnabled 
    public static void setSessionObjectives(String key, String val) {
        
        Session_Obj__c so = [select id, Correct__c,Incorrect__c,Prompted__c from Session_Obj__c where id = :key limit 1];

switch on val {
   when 'Correct' {
      so.Correct__c=true;
      so.Incorrect__c=false;
      so.Prompted__c=false; 
   }
   when 'Incorrect' {
      so.Correct__c=false;
      so.Incorrect__c=true;
      so.Prompted__c=false; 
   }
    when 'Prompted' {
       so.Correct__c=false;
       so.Incorrect__c=false;
       so.Prompted__c=true; 
   }
   when else {
       System.debug('default');
   }
}

update so;

      
    }



@AuraEnabled 
    public static Integer setSessionObjectivesByArray(String jsonstr, String val) {
        
 List<Session_Obj__c> soDeserialized = (List<Session_Obj__c>) JSON.deserializeStrict(jsonstr, List<Session_Obj__c>.class);
 
 for(Session_Obj__c so : soDeserialized){

   switch on val {
   when 'Correct' {
      so.Correct__c=true;
      so.Incorrect__c=false;
      so.Prompted__c=false; 
   }
   when 'Incorrect' {
      so.Correct__c=false;
      so.Incorrect__c=true;
      so.Prompted__c=false; 
   }
    when 'Prompted' {
       so.Correct__c=false;
       so.Incorrect__c=false;
       so.Prompted__c=true; 
   }
   when else {
       System.debug('default');
   }
}

update soDeserialized;


      
 }


return soDeserialized.size();



}

}