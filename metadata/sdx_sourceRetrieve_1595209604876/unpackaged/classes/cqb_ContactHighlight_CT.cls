public without sharing class cqb_ContactHighlight_CT {    
    
    @auraenabled
    public static cqb_wrapperClass getContact(String recId){
        Id myId = recId;
        Schema.SObjectType sobjectType = myId.getSObjectType();
        String contactQuery;
        
        if (String.valueOf(sobjectType) == 'MessagingSession'){
            contactQuery = 'EndUserContactId';
        } else {
            contactQuery = 'ContactId';            
        }
        
        String queryString = 'Select Id, ' + contactQuery + ' from ' + sobjectType + ' Where Id=:recId Limit 1';
        SObject myRecord = Database.query(queryString);
        String myContactId = String.valueOf(myRecord.get(contactQuery));
        User myU;
        try{
            myU = [select FullPhotoUrl from User where ContactId=:myContactId Limit 1];
        } catch(Exception ex){
            myU = null;
        }        
        Contact myC = [Select Id, Name, Title, Salutation from Contact Where Id=:myContactId];
        cqb_wrapperClass wc = new cqb_wrapperClass(myU, myC);
        return wc;
    }               
}