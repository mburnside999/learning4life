public with sharing class LFLLoginBannerController {
   
        @AuraEnabled(cacheable=true)  
        public static LFL_Notification_Banner__mdt getBannerDetail() {
            
            return [ 
                    SELECT Id, Start__c, End__c, Message__c,NotificationLink__c,NotificationText__c
                    FROM LFL_Notification_Banner__mdt 
                    where Published__c=true 
                    LIMIT 1
                   ];
        }
        }
