Boolean updateRecords = true;
integer i;
String currentmax;
for (AggregateResult ar : [
  SELECT max(PID__c) maxpid
  FROM Program__c
  WHERE PID__c LIKE 'LFL%'
]) {
  currentmax = (String) ar.get('maxpid');
  System.debug(currentmax.substringAfterLast('-'));
  i = Integer.valueOf(currentmax.substringAfterLast('-')) + 1;
}

System.debug('Current MAX PID=' + currentmax);
System.debug(
  'Next integer to be assigned=' +
    i +
    ', sequence would start at LFL-P-' +
    String.valueOf(i).leftPad(6, '0')
);

List<Program__c> listprog = new List<Program__c>();
for (Program__c sd : [SELECT id, PID__c FROM Program__c WHERE PID__c = NULL]) {
  String formattedPID = 'LFL-P-' + String.valueOf(i).leftPad(6, '0');
  sd.PID__c = formattedPID;
  listprog.add(sd);
  System.debug('New PID = ' + formattedPID);
  i++;
}

System.debug('PID list: ' + listprog);
if (updateRecords) {
  update listprog;
  System.debug(listprog.size() + ' RECORDS UPDATED');
} else {
  System.debug(
    'NO RECORDS UPDATED, validation run only. Proposal is to update  ' +
      listprog.size() +
      ' Program records'
  );
  System.debug('Re-run with updateRecords==True to do the update');
}
