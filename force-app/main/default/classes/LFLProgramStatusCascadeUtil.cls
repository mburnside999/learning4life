/**************************************************************
 * @name LFLProgramStatusCascadeUtil
 * @author	Mike Burnside
 * @date	2023
 * @group Learning For Life
 * @description	
 *
 */

public class LFLProgramStatusCascadeUtil {
  /*******************************************************************************************************
   * @name updateSDStatusByMap
   * @description 
   *
   * @param statusMap
   * @return void
   * @example
   */

  public static void updateSDStatusByMap(Map<id, string> statusMap) {
    Logger.debug('Apex:LFLProgramStatusCascadeUtil')
      .addTag('LFLProgramStatusCascadeUtil.updateSDStatusByMap()')
      .addTag('logit()');

    Logger.fine('statusMap=' + statusMap).addTag('logit()');
    Logger.saveLog();

    List<sd__c> sdlist = new List<sd__c>();
    List<sd__c> sdupdatelist = new List<sd__c>();

    sdlist = [
      SELECT id, status__c, program__c
      FROM sd__C
      WHERE program__c IN :statusMap.keySet()
    ];

    Logger.fine('Apex:LFLProgramStatusCascadeUtil sdlist=' + sdlist)
      .addTag('logit()');
    Logger.saveLog();

    for (sd__c sd : sdlist) {
      String status = statusMap.get(sd.program__c);
      sd.status__c = status;
      sdupdatelist.add(sd);
    }
    update sdupdatelist;
  }

  /*******************************************************************************************************
   * @name updateObjectiveStatusByMap
   * @description 
   *
   * @param statusMap
   * @return void
   * @example
   */
  public static void updateObjectiveStatusByMap(Map<id, string> statusMap) {
    Logger.debug('Apex:LFLProgramStatusCascadeUtil')
      .addTag('LFLProgramStatusCascadeUtil.updateObjectiveStatusByMap()')
      .addTag('logit()');

    Logger.fine('statusMap=' + statusMap).addTag('logit()');
    Logger.saveLog();

    List<objective__c> olist = new List<objective__c>();
    List<objective__c> oupdatelist = new List<objective__c>();

    olist = [
      SELECT id, status__c, sd__c
      FROM objective__C
      WHERE sd__c IN :statusMap.keySet()
    ];
    Logger.fine('Apex:LFLProgramStatusCascadeUtil olist=' + olist)
      .addTag('logit()');
    Logger.saveLog();

    for (objective__c o : olist) {
      String status = statusMap.get(o.sd__c);
      o.status__c = status;
      oupdatelist.add(o);
    }
    update oupdatelist;
  }
}
