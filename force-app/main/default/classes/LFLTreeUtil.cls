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
  static Map<Id, Program__c> programMap;
  static Map<Id, Objective__c> objMap;

  static Map<Id, SD__c> sdMap;
  static Map<id, List<SD__c>> progToSDMap;
  static Map<id, List<Objective__c>> SDToObjMap;

  /*******************************************************************************************************
   * @name getJSONTree
   * @description  builds a complete JSON tree of the Catalog for rendering by lwc tree grid
   *
   *
   * @param reserved not used

   * @return JSON string
   * @example
   * String jsonStr = LFLTreeUtil.getJSONTree(string);
   */

  @AuraEnabled(cacheable=true)
  public static String getJSONTree(String reserved) {
    final String SCENARIO = 'Tree Util, full catalog - Apex';

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
        SELECT id, PID__c, name, status__c
        FROM Program__c
        ORDER BY name
      ]
    );

    Map<Id, SD__c> sdMap = new Map<Id, SD__c>(
      [
        SELECT id, SDID__c, program__c, name, status__c
        FROM SD__c
        ORDER BY name
      ]
    );

    Map<Id, Objective__c> objMap = new Map<Id, Objective__c>(
      [
        SELECT id, OID__c, SD__c, name, status__c
        FROM Objective__c
        ORDER BY name
      ]
    );

    progToSDMap = new Map<id, List<SD__c>>();

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

    SDToObjMap = new Map<id, List<Objective__c>>();

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
    String pIdentifier;
    for (Id key : programMap.keySet()) {
      //
      //
      pName = (String) programMap.get(key).Name;
      pIdentifier = (String) programMap.get(key).PID__c;
      pStatus = (String) programMap.get(key).Status__c;
      jsonStr += '{';
      jsonStr += '"label":"' + pName + '",';
      jsonStr += '"IdUrl":"/' + key + '",';
      jsonStr += '"name":"' + pName + '",';
      jsonStr += '"identifier":"' + pIdentifier + '",';
      jsonStr += '"status":"' + pStatus + '",';
      jsonStr += '"type":"Program",';
      if (progToSDMap.containsKey(key)) {
        jsonStr += '"_children":' + getSDJSON(key);
      } else {
        jsonStr += '"_children":' + '[]';
      }
      jsonStr += '},';
    }
    jsonStr += ']';

    String target = '},]';
    String replacement = '}]';
    jsonstr = jsonstr.replace(target, replacement);
    //System.debug(jsonstr);
    return jsonStr;
  }

  /*******************************************************************************************************
   * @name getJSONTreeFiltered
   * @description  builds a filtered JSON tree of the Catalog for rendering by lwc tree grid
   *
   *
   * @param searchStr the search string
   * @return JSON string
   * @example
   * String jsonStr = LFLTreeUtil.getJSONTreeFitered('Blue circle');
   */

  @AuraEnabled(cacheable=true)
  public static String getJSONTreeFiltered(String searchStr) {
    final String SCENARIO = 'Tree Util Filtering- Apex';

    String jsonStr = '[';

    L4LNebulaComponentController.setupCache();
    L4LNebulaComponentController.logInfo(
      null,
      'in LFLTreeUtil.getJSONTreeFiltered(), searchStr=' + searchStr,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    Map<Id, SD__c> sdMasterMap = new Map<Id, SD__c>(
      [
        SELECT id, SDID__c, program__c, name, status__c
        FROM SD__c
        ORDER BY name
      ]
    );

    Map<Id, Program__c> programMasterMap = new Map<Id, Program__c>(
      [
        SELECT id, PID__c, name, status__c
        FROM Program__c
        ORDER BY name
      ]
    );

    Map<Id, Objective__c> objectiveMasterMap = new Map<Id, Objective__c>(
      [
        SELECT id, OID__c, sd__c, name, status__c
        FROM Objective__c
        ORDER BY name
      ]
    );

    String filteredObjectiveQueryString =
      'select id,name,status__c,sd__c,sd__r.name,sd__r.status__c,sd__r.program__c,sd__r.program__r.name,sd__r.program__r.status__c from objective__c where name like \'%' +
      searchStr +
      '%\' or sd__r.name like \'%' +
      searchStr +
      '%\'' +
      'or sd__r.program__r.name like \'%' +
      searchStr +
      '%\'';

    System.debug(filteredObjectiveQueryString);
    L4LNebulaComponentController.logDebug(
      null,
      'in LFLTreeUtil.getJSONTreeFiltered(), query string=' +
      filteredObjectiveQueryString,
      SCENARIO,
      'next-gen-nebula-apex'
    );

    List<Objective__c> filteredObjectiveList = new List<Objective__c>(
      (List<Objective__c>) Database.query(filteredObjectiveQueryString)
    );

    progToSDMap = new Map<id, List<SD__c>>();

    for (Objective__c o : filteredObjectiveList) {
      Id pid = o.sd__r.program__c;
      Id sid = o.sd__c;
      if (progToSDMap.containsKey(pid)) {
        List<sd__c> sds = (List<SD__c>) progToSDMap.get(pid);
        SD__c sdtemp = sdMasterMap.get(sid);
        if (!sds.contains(sdtemp)) {
          sds.add(sdtemp);
        }
        progToSDMap.put(pid, sds);
      } else {
        List<sd__c> sds = new List<SD__c>();
        sds.add(sdMasterMap.get(sid));
        progToSDMap.put(pid, sds);
      }
    }
    System.debug('progToSDMap=' + progToSDMap);

    SDToObjMap = new Map<id, List<Objective__c>>();

    for (Objective__c o : filteredObjectiveList) {
      Id oid = o.Id;
      Id sid = o.sd__c;
      if (SDToObjMap.containsKey(sid)) {
        List<objective__c> objs = (List<objective__c>) SDToObjMap.get(sid);
        objective__c otemp = objectiveMasterMap.get(oid);
        if (!objs.contains(otemp)) {
          objs.add(otemp);
        }
        SDToObjMap.put(sid, objs);
      } else {
        List<objective__c> objs = new List<objective__c>();
        objs.add(objectiveMasterMap.get(oid));
        SDToObjMap.put(sid, objs);
      }
    }

    String pName;
    String pStatus;
    String pIdentifier;
    for (Id key : progToSDMap.keySet()) {
      //
      System.debug('key=' + key);
      pName = (String) programMasterMap.get(key).Name;
      pIdentifier = (String) programMasterMap.get(key).PID__c;
      pStatus = (String) programMasterMap.get(key).Status__c;
      jsonStr += '{';
      jsonStr += '"label":"' + pName + '",';
      jsonStr += '"IdUrl":"/' + key + '",';
      jsonStr += '"name":"' + pName + '",';
      jsonStr += '"identifier":"' + pIdentifier + '",';
      jsonStr += '"status":"' + pStatus + '",';
      jsonStr += '"type":"Program",';
      if (progToSDMap.containsKey(key)) {
        jsonStr += '"_children":' + getSDJSON(key);
      } else {
        jsonStr += '"_children":' + '[]';
      }
      jsonStr += '},';
    }
    jsonStr += ']';

    String target = '},]';
    String replacement = '}]';
    jsonstr = jsonstr.replace(target, replacement);
    //System.debug(jsonstr);
    return jsonStr;
  }

  /*******************************************************************************************************
   * @name getSDJSON
   * @description helper for attaching SDs to the Program part
   *
   * @param key the Program Id
   * @return JSON string
   */

  static String getSDJSON(Id key) {
    List<SD__c> sdlist = (List<SD__C>) progToSDMap.get(key);
    String sdjsonStr = '[';
    String sdName;
    String sdStatus;
    String sdIdentifier;
    for (SD__c s : sdlist) {
      sdName = (String) s.Name;
      sdIdentifier = (String) s.SDID__c;
      sdStatus = (String) s.Status__c;
      sdjsonStr += '{';
      sdjsonStr += '"label":"' + sdName + '",';
      sdjsonStr += '"IdUrl":"/' + s.Id + '",';
      sdjsonStr += '"name":"' + sdName + '",';
      sdjsonStr += '"identifier":"' + sdIdentifier + '",';
      sdjsonStr += '"status":"' + sdStatus + '",';
      sdjsonStr += '"type":"SD",';
      if (SDToObjMap.containsKey(s.Id)) {
        sdjsonStr += '"_children":' + getObjJSON(s.id);
      } else {
        sdjsonStr += '"_children":' + '[]';
      }
      sdjsonStr += '},';
    }

    sdjsonStr += ']';
    String target = '},]';
    String replacement = '}]';
    sdjsonstr = sdjsonstr.replace(target, replacement);
    // System.debug(sdjsonStr);
    return sdjsonStr;
  }

  /*******************************************************************************************************
   * @name getObjJSON
   * @description helper for attaching Objss to the Program part
   *
   * @param key the SD Id
   * @return JSON string
   */

  static String getObjJSON(Id key) {
    List<Objective__c> olist = SDToObjMap.get(key);
    //System.debug('=======> key=' + key);
    String ojsonStr = '[';
    String oName;
    String oStatus;
    String oIdentifier;
    for (Objective__c o : olist) {
      oName = (String) o.Name;
      oIdentifier = (String) o.OID__c;
      oStatus = (String) o.Status__c;

      ojsonStr += '{';
      ojsonStr += '"label":"' + oName + '",';
      ojsonStr += '"IdUrl":"/' + o.Id + '",';
      ojsonStr += '"name":"' + oName + '",';
      ojsonStr += '"identifier":"' + oIdentifier + '",';
      ojsonStr += '"status":"' + oStatus + '",';
      ojsonStr += '"type":"Objective",';
      ojsonStr += '"_children":[]';
      ojsonStr += '},';
    }

    ojsonStr += ']';
    String target = '},]';
    String replacement = '}]';
    ojsonstr = ojsonstr.replace(target, replacement);
    // System.debug(sdjsonStr);
    return ojsonStr;
  }
}
