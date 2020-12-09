trigger trgUpdateDateSinceCorrect on Session_Obj__c (before update) {

System.debug('in trgUpdateDateSinceCorrect');

for (Session_Obj__c so : Trigger.New) {

System.debug('in New loop');


if (so.correct__c==true && (so.previous_status__c=='ACQ')) {

System.debug('true condition');

Id clientid = [select session__r.client__r.id from session_obj__c where id = :so.id limit 1].session__r.client__r.id;

System.debug('clientid='+clientid);


Client_Objective__c co = [select id,last_tested_Correct__c from client_objective__c where client__c=:clientid and objective__C = :so.objective__c limit 1];

System.debug('co='+co.Id);


co.last_tested_correct__c=date.today();
System.debug('last tested correct '+ co.last_tested_correct__c);



update co;

}

}






}