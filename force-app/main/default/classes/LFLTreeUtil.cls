/**************************************************************
 * @author	Mike Burnside
 * @name LFLTreeUtil
 * @date	2024
 * @group Learning For Life
 *
 * @description	Tree viewer support
 *
 */
public with sharing class LFLTreeUtil {
  @AuraEnabled(cacheable=true)
  public static String getJSONTree(String reserved) {
    final String SCENARIO = 'Tree Util - Apex';

    String jsonStr = '[';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'in LFLTreeUtil.getJSONTree()',
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Map<Id, Program__c> programMap = new Map<Id, Program__c>(
      [
        SELECT id, name
        FROM Program__c
        ORDER BY name
      ]
    );
    Set<id> p = new Set<id>();
    p = programMap.keySet();

    Map<Id, SD__c> sdMap = new Map<Id, SD__c>(
      [
        SELECT id, program__c, name
        FROM SD__c
        WHERE program__c IN :p
        ORDER BY name
      ]
    );

    Set<id> s = new Set<id>();
    s = sdMap.keySet();

    Map<Id, Objective__c> objMap = new Map<Id, Objective__c>(
      [
        SELECT id, SD__c, name
        FROM Objective__c
        ORDER BY name
      ]
    );
    System.debug('zzzzzz ' + objMap);

    Map<id, List<SD__c>> progToSDMap = new Map<id, List<SD__c>>();

    for (Id key : sdMap.keySet()) {
      Id pid = sdMap.get(key).program__c;

      if (progToSDMap.containsKey(pid)) {
        List<sd__c> sds = (List<SD__c>) progToSDMap.get(pid);
        sds.add(sdMap.get(key));
        progToSDMap.put(pid, sds);
      } else {
        List<sd__c> sds = new List<SD__c>();
        sds.add(sdMap.get(key));
        progToSDMap.put(pid, sds);
      }
    }

    Map<id, List<Objective__c>> SDToObjMap = new Map<id, List<Objective__c>>();

    for (Id key : objMap.keySet()) {
      Id sid = objMap.get(key).sd__c;

      if (SDToObjMap.containsKey(sid)) {
        List<objective__c> objs = (List<Objective__c>) SDToObjMap.get(sid);
        objs.add(objMap.get(key));
        SDToObjMap.put(sid, objs);
      } else {
        List<objective__c> objs = new List<Objective__c>();
        objs.add(objMap.get(key));
        SDToObjMap.put(sid, objs);
      }
    }

    //System.debug(SDToObjMap);

    String pName;
    for (Id key : programMap.keySet()) {
      //
      //
      pName = (String) programMap.get(key).Name;
      jsonStr += '{';
      jsonStr += '"label":"' + pName + '",';
      jsonStr += '"name":"' + pName + '",';
      jsonStr += '"expanded":"true",';
      jsonStr += '"items":' + getSDJSON(key, progToSDMap, SDToObjMap);
      jsonStr += '},';
    }
    jsonStr += ']';

    String target = '},]';
    String replacement = '}]';
    jsonstr = jsonstr.replace(target, replacement);
    //System.debug(jsonstr);
    return jsonStr;
  }

  static String getSDJSON(
    Id key,
    Map<id, List<SD__c>> progToSDMap,
    Map<id, List<Objective__c>> SDToObjMap
  ) {
    if (!progToSDMap.containsKey(key)) {
      System.debug('xxxxxxxxx ' + key);
    }
    List<SD__c> sdlist = progToSDMap.get(key);
    String sdjsonStr = '[';
    String sdName;
    for (SD__c s : sdlist) {
      sdName = (String) s.Name;
      sdjsonStr += '{';
      sdjsonStr += '"label":"' + sdName + '",';
      sdjsonStr += '"name":"' + sdName + '",';
      sdjsonStr += '"expanded":"false",';
      sdjsonStr += '"items":' + getObjJSON(s.id, SDToObjMap);
      sdjsonStr += '},';
    }

    sdjsonStr += ']';
    String target = '},]';
    String replacement = '}]';
    sdjsonstr = sdjsonstr.replace(target, replacement);
    // System.debug(sdjsonStr);
    return sdjsonStr;
  }

  static String getObjJSON(Id key, Map<Id, List<Objective__c>> SDToObjMap) {
    List<Objective__c> olist = SDToObjMap.get(key);
    System.debug('=======> key=' + key);
    String ojsonStr = '[';
    String oName;
    if (olist != null) {
      for (Objective__c o : olist) {
        oName = (String) o.Name;
        ojsonStr += '{';
        ojsonStr += '"label":"' + oName + '",';
        ojsonStr += '"name":"' + oName + '",';
        ojsonStr += '"expanded":"false",';
        ojsonStr += '"items":[]';
        ojsonStr += '},';
      }
    }

    ojsonStr += ']';
    String target = '},]';
    String replacement = '}]';
    ojsonstr = ojsonstr.replace(target, replacement);
    // System.debug(sdjsonStr);
    return ojsonStr;
  }
}
