/**************************************************************
 * @name LFLBackupUtilScheduler
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 *
 * @description	Implements Schedulable, invokes the class to clean up backups
 *
 */

global class LFLBackupUtilScheduler implements Schedulable {
  /*******************************************************************************************************
   * @name execute
   * @description Execute method
   * @param SC
   *
   * @param void
   */

  global void execute(SchedulableContext SC) {
    LFLBackupUtil l = new LFLBackupUtil();
    Integer x = l.cleanupbackups();
    System.debug(x + 'backup files deleted');
  }
}
