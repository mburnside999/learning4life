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
        SELECT id, name, status__c
        FROM Program__c
        WHERE id IN (SELECT program__c FROM sd__c)
        ORDER BY name
      ]
    );
    Set<id> p = new Set<id>();
    p = programMap.keySet();

    Map<Id, SD__c> sdMap = new Map<Id, SD__c>(
      [
        SELECT id, program__c, name, status__c
        FROM SD__c
        WHERE program__c IN :p
        ORDER BY name
      ]
    );

    Set<id> s = new Set<id>();
    s = sdMap.keySet();

    Map<Id, Objective__c> objMap = new Map<Id, Objective__c>(
      [
        SELECT id, SD__c, name, status__c
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
    String pStatus;
    for (Id key : programMap.keySet()) {
      //
      //
      pName = (String) programMap.get(key).Name;
      pStatus = (String) programMap.get(key).Status__c;
      jsonStr += '{';
      jsonStr += '"label":"' + pName + '",';
      jsonStr += '"IdUrl":"/' + key + '",';
      jsonStr += '"name":"' + pName + '",';
      jsonStr += '"status":"' + pStatus + '",';
      jsonStr += '"type":"Program",';

      jsonStr += '"_children":' + getSDJSON(key, progToSDMap, SDToObjMap);
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
    String sdStatus;
    if (sdList != null) {
      for (SD__c s : sdlist) {
        sdName = (String) s.Name;
        sdStatus = (String) s.Status__c;
        sdjsonStr += '{';
        sdjsonStr += '"label":"' + sdName + '",';
        sdjsonStr += '"IdUrl":"/' + s.Id + '",';
        sdjsonStr += '"name":"' + sdName + '",';
        sdjsonStr += '"status":"' + sdStatus + '",';
        sdjsonStr += '"type":"SD",';

        sdjsonStr += '"_children":' + getObjJSON(s.id, SDToObjMap);
        sdjsonStr += '},';
      }
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
    String oStatus;
    if (olist != null) {
      for (Objective__c o : olist) {
        oName = (String) o.Name;
        oStatus = (String) o.Status__c;

        ojsonStr += '{';
        ojsonStr += '"label":"' + oName + '",';
        ojsonStr += '"IdUrl":"/' + o.Id + '",';
        ojsonStr += '"name":"' + oName + '",';
        ojsonStr += '"status":"' + oStatus + '",';
        ojsonStr += '"type":"Objective",';
        ojsonStr += '"_children":[]';
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
