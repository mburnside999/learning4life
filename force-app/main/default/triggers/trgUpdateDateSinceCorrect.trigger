trigger trgUpdateDateSinceCorrect on Session_Obj__c (before update) {

System.debug('XXXXXX in trgUpdateDateSinceCorrect');

for (Session_Obj__c so : Trigger.New) {

System.debug('XXXXX in loop');


if (so.correct__c==true && (so.previous_status__c=='AC')) {

System.debug('XXXXXX true condition');

Id clientid = [select session__r.client__r.id from session_obj__c where id = :so.id limit 1].session__r.client__r.id;

System.debug('XXXXXX clientid='+clientid);


Client_Objective__c co = [select id,last_tested_Correct__c from client_objective__c where client__c=:clientid and objective__C = :so.objective__c limit 1];

System.debug('XXXXXX co='+co.Id);


co.last_tested_correct__c=date.today();
System.debug('XXXXXX '+ co.last_tested_correct__c);



update co;

}

}






}