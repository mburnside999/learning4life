global class EinsteinChatbotsCreateCase {
    @InvocableMethod(label='Einstein Chatbots - Create Case')
    global static List<Case> createChatCase(List<ChatbotCaseRequest> requests)
    {
        for (ChatbotCaseRequest request : requests){
            Case caseObj = new Case();
            if (request.caseSubject == null){
                caseObj.Subject = 'Einstein Bot Case';
            } else {
                caseObj.subject = request.caseSubject;
            }
            if (request.objContact != null){
                caseObj.ContactId = request.objContact.Id;
            }
            if (request.objChat != null){ 
                caseObj.Origin = 'Chat';
            } else if (request.objMessage != null){
                caseObj.Origin = 'SMS';
            }
            insert caseObj;
            
            //TODO Check if this is the best way to update the Case ID on the Chat
            if (request.objChat != null){            
                LiveChatTranscript chat = request.objChat;
                chat.CaseId = caseObj.Id;
                update chat;
            } else if (request.objMessage != null){
                MessagingSession msg = request.objMessage;
                msg.CaseId = caseObj.Id;
                update msg;
            }          
            return new List<Case>{caseObj};                
        }
        return new List<Case>{new Case()};
    }
    
    global class ChatbotCaseRequest
    {
        @InvocableVariable
        global string caseSubject;
        @InvocableVariable
        global LiveChatTranscript objChat;
        @InvocableVariable
        global MessagingSession objMessage;
        @InvocableVariable
        global Contact objContact;
        
    }
}