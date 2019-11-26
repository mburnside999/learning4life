public with sharing class MBSessionObjectives {
   

    @AuraEnabled(cacheable=true) 
    public static List<Session_obj__c> getSessionObjectives (String sess) {
        
        return [SELECT Id,Name,Objective__c,Objective_Name__c,Correct__c,Incorrect__c,Prompted__c,SD__c,Program__c FROM Session_Obj__c where Session__c = :sess order by Program__c,SD__c];
    }


 @AuraEnabled(cacheable=true) 
    public static List<Objective__c> getObjectives (String sess) {
        
        return [SELECT Id,Name,Program__c,SD_Name__c FROM Objective__c order by Program__c,Name];
    }

 @AuraEnabled(cacheable=true) 
    public static List<Objective__c> getUnusedObjectives (String sess) {
        
        return [SELECT Id,Name,Program__c,SD_Name__c FROM Objective__c where Id  not in (select Objective__c from Client_Objective__c where Client__c = :sess) order by Program__c,Name];
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
    public static Integer createSessionObjectivesByArray(String jsonstr,String sess ) {

//deserailise the object array      
 List<Objective__c> objDeserialized = (List<Objective__c>) JSON.deserializeStrict(jsonstr, List<Objective__c>.class);

// // prepare a list for insertion in bulk
List<Session_Obj__c> soList = new List<Session_Obj__c>();

// loop thru the deserialised objectives
for(Objective__c o : objDeserialized){

// prepare a sess_obj__c and add to array
Session_Obj__c so = new Session_Obj__c();
so.Session__c=sess;
so.Objective__c=o.Id;
so.Correct__C=false;
so.Incorrect__c=false;
so.Prompted__c=false;  


soList.add(so);
}

insert soList;   

return objDeserialized.size();


}

@AuraEnabled 
    public static Integer createClientObjectivesByArray(String jsonstr,String sess ) {

//deserailise the object array      
 List<Objective__c> objDeserialized = (List<Objective__c>) JSON.deserializeStrict(jsonstr, List<Objective__c>.class);

// // prepare a list for insertion in bulk
List<Client_Objective__c> coList = new List<Client_Objective__c>();

// loop thru the deserialised objectives
for(Objective__c o : objDeserialized){

// prepare a sess_obj__c and add to array
Client_Objective__c co = new Client_Objective__c();
co.Client__c=sess;
co.Objective__c=o.Id;
co.Status__c='CIP';
 


coList.add(co);
}

insert coList;   

return objDeserialized.size();


}





@AuraEnabled 
    public static Integer setSessionObjectivesByArray(String jsonstr, String val) {
    
    boolean del=false;
    
    List<Session_Obj__c> soDeserialized = (List<Session_Obj__c>) JSON.deserializeStrict(jsonstr, List<Session_Obj__c>.class);
  
    

   for(Session_Obj__c so : soDeserialized){

   switch on val {
   when 'Correct' {
      so.Correct__c=true;
      so.Incorrect__c=false;
      so.Prompted__c=false; 
      update so;
   }
   when 'Incorrect' {
      so.Correct__c=false;
      so.Incorrect__c=true;
      so.Prompted__c=false; 
      update so;

   }
    when 'Prompted' {
       so.Correct__c=false;
       so.Incorrect__c=false;
       so.Prompted__c=true; 
       update so;
   }  
   when 'Delete' {
       delete so;
   }

   }

   
   }
     

   

return soDeserialized.size();

}

}