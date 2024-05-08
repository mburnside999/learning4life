Boolean updateRecords = false;
integer i;
String currentmax;
for (AggregateResult ar : [
  SELECT max(SDID__c) maxsdid
  FROM SD__c
  WHERE SDID__c LIKE 'LFL%'
]) {
  currentmax = (String) ar.get('maxsdid');
  System.debug(currentmax.substringAfterLast('-'));
  i = Integer.valueOf(currentmax.substringAfterLast('-')) + 1;
}

System.debug('Current MAX SDID=' + currentmax);
System.debug(
  'Next integer to be assigned=' +
    i +
    ', sequence would start at LFL-SD-' +
    String.valueOf(i).leftPad(6, '0')
);

List<SD__c> listsd = new List<SD__c>();
for (SD__c sd : [SELECT id, SDID__c FROM SD__c WHERE sdid__C = NULL]) {
  String formattedSDID = 'LFL-SD-' + String.valueOf(i).leftPad(6, '0');
  sd.SDID__c = formattedSDID;
  listsd.add(sd);
  System.debug('New SDID = ' + formattedSDID);
  i++;
}

System.debug('SD list: ' + listsd);
if (updateRecords) {
  update listsd;
  System.debug(listsd.size() + ' RECORDS UPDATED');
} else {
  System.debug(
    'NO RECORDS UPDATED, validation run only. Proposal is to update  ' +
      listsd.size() +
      ' SD records'
  );
  System.debug('Re-run with updateRecords==True to do the update');
}
