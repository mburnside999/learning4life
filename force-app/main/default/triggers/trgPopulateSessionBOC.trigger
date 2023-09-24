trigger trgPopulateSessionBOC on session__c(after insert) {
  List<session_boc__c> sbocList = new List<session_boc__c>();

  for (session__c s : Trigger.New) {
    List<client_boc__c> cbocList = L4LController.getActiveCBOCList(s.client__c);
    if (cbocList.size() > 0) {
      for (client_boc__c cboc : cbocList) {
        session_boc__c sboc = new session_boc__c(
          client_BOC__c = cboc.id,
          comments__c = 'Please complete this auto-generated comment before closing the session.',
          duration_mins__c = 0,
          occurrences__c = 0,
          intensity__c = '1',
          session__c = s.Id
        );
        sbocList.add(sboc);
      }
    }
  }

  if (sbocList.size() > 0) {
    insert sbocList;
  }

}
