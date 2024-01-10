/**************************************************************
 * @name L4LTimeSeries
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

    for (ContentDocument cdkeep : [
      SELECT id
      FROM ContentDocument
      WHERE title LIKE '%BACKUP%' AND FileExtension = 'zip'
      ORDER BY createddate
      LIMIT 5
    ]) {
      keepList.add(cdkeep.Id);
    }

    for (ContentDocument cdremove : [
      SELECT id
      FROM ContentDocument
      WHERE
        title LIKE '%BACKUP%'
        AND FileExtension = 'zip'
        AND id NOT IN :keepList
    ]) {
      delete cdremove;
    }

    String email = 'mburnside@salesforce.com';
    String orgname = UserInfo.getOrganizationName();
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    mail.setToAddresses(new List<String>{ email });
    mail.setReplyTo('batch@acme.com');
    mail.setSenderDisplayName('Backup Cleaner');
    mail.setSubject(orgName + ': ' + 'BACKUP library cleaned');

    mail.setPlainTextBody(keepList.size() + 'backup ZIP files retained.');

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
    return keepList.size();
  }
}
