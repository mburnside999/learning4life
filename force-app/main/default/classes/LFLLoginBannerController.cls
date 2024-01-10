public with sharing class LFLLoginBannerController {
  @AuraEnabled(cacheable=true)
  public static LFL_Notification_Banner__mdt getBannerDetail(Boolean hide) {
    if (!Cache.Session.contains('HideNotification')) {
      System.debug(
        'session DOES NOT contains a cache entry for HideNotification, initialise by putting false value - DO NOT HIDE'
      );
      Cache.Session.put('HideNotification', false);
    } else {
      Boolean currval = (Boolean) Cache.Session.get('HideNotification');
      System.debug(
        'session DOES contains a cache entry for HideNotification, it has a value of ' +
        currval
      );
      if (!currval) {
        System.debug(
          'well, its already set to false, DO NOT HIDE, respect the parameter because change is allowed'
        );
        Cache.Session.put('HideNotification', hide);
      } else {
        System.debug(
          'its already set to true, HIDE, lets keep it that way for the entire session'
        );
      }
    }
    Boolean hideflag = (Boolean) Cache.Session.get('HideNotification');

    if (hideflag) {
      return null;
    } else {
      return [
        SELECT
          Id,
          Start__c,
          End__c,
          Message__c,
          NotificationLink__c,
          NotificationText__c
        FROM LFL_Notification_Banner__mdt
        WHERE Published__c = TRUE
        LIMIT 1
      ];
    }
  }
}
