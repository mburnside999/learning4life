Boolean updateRecords = true;
integer i;
String currentmax;
for (AggregateResult ar : [
  SELECT max(OID__c) maxoid
  FROM Objective__c
  WHERE OID__c LIKE 'LFL%'
]) {
  currentmax = (String) ar.get('maxoid');
  System.debug(currentmax.substringAfterLast('-'));
  i = Integer.valueOf(currentmax.substringAfterLast('-')) + 1;
}

System.debug('Current MAX OID=' + currentmax);
System.debug(
  'Next integer to be assigned=' +
    i +
    ', sequence would start at LFL-O-' +
    String.valueOf(i).leftPad(6, '0')
);

List<Objective__c> listobj = new List<Objective__c>();
for (Objective__c obj : [
  SELECT id, OID__c
  FROM Objective__c
  WHERE OID__c = NULL
]) {
  String formattedOID = 'LFL-O-' + String.valueOf(i).leftPad(6, '0');
  obj.OID__c = formattedOID;
  listobj.add(obj);
  System.debug('New OID = ' + formattedOID);
  i++;
}

System.debug('Objective list: ' + listobj);
if (updateRecords) {
  update listobj;
  System.debug(listobj.size() + ' RECORDS UPDATED');
} else {
  System.debug(
    'NO RECORDS UPDATED, validation run only. Proposal is to update  ' +
      listobj.size() +
      ' Objective records'
  );
  System.debug('Re-run with updateRecords==True to do the update');
}
