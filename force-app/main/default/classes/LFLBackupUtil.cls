/**************************************************************
 * @name LFLBackupUtil
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	Methods for backups
 *
 */

public class LFLBackupUtil {
  /*******************************************************************************************************
   * @name cleanup
   * @description cleanup backups
   *
   * @return
   *
   * @example
   * Integer recs = ;
   */

  public Integer cleanupbackups() {
    List<Id> keepList = new List<Id>();

    string emailMessageBody = 'ZIP Files Retained:\n-------------------\n';

    for (ContentDocument cdkeep : [
      SELECT id, Title, ContentSize
      FROM ContentDocument
      WHERE Title LIKE '%BACKUP%' AND FileExtension = 'zip'
      ORDER BY createddate DESC
      LIMIT 7
    ]) {
      decimal size = (decimal) cdkeep.ContentSize / 1024 / 1024;
      emailMessageBody += cdkeep.Title + ' (' + size.setScale(4) + ' MB) \n';
      keepList.add(cdkeep.Id);
    }
    System.debug(emailMessageBody);
    Integer removed = 0;
    for (ContentDocument cdremove : [
      SELECT id
      FROM ContentDocument
      WHERE
        title LIKE '%BACKUP%'
        AND FileExtension = 'zip'
        AND id NOT IN :keepList
    ]) {
      removed += 1;
      delete cdremove;
    }

    LFL_Backup_Utility__mdt LFL_Backup_Utility = LFL_Backup_Utility__mdt.getInstance(
      'BackupUtilConfig'
    );

    String emailStr = LFL_Backup_Utility.Email_List__c;

    List<String> emailList = emailStr.split(',');

    String orgname = UserInfo.getOrganizationName();
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    mail.setToAddresses(emailList);
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName(orgName + ' - Backup Cleaner');
    mail.setSubject(orgName + ': ' + 'BACKUP library cleaned.');

    mail.setPlainTextBody(
      'Backup Util completed.\nRemoved: ' +
        removed +
        ' zip files\nRetained: ' +
        keepList.size() +
        ' zip files.\n' +
        emailMessageBody
    );

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    return keepList.size();
  }
}
