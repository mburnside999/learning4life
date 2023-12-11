# L4LInvocableReportWizard

Invocable methods


**Author** Mike Burnside


**Name** L4LInvocableReportWizard


**Date** 2022


**Group** Learning For Life

## Methods
### `public static List<String> getStatusCountsBetweenDates(List<Requests> requests)`

`INVOCABLEMETHOD`

returns the status of a given session

#### Parameters

|Param|Description|
|---|---|
|`requests`|List<Request>|

#### Returns

|Type|Description|
|---|---|
|`List<String>`|result List<String>|

#### Example
```apex
```


### `private static Integer countAllTimeAcquired(Id clientId, String pname)`
### `private static Integer getAllTimeAcquired(String pname, Map<String,Integer> projAcqMap)`
### `private static List<Client_Objective__c> getObjectiveList(Id clientId, String pname, Datetime starttime, Datetime endtime, String status, List<Client_Objective__c> allcoList)`
---
## Classes
### Requests

Inner class to combine clientid, strttime, emdtime


**Author** Mike Burnside


**Name** L4LInvocableReportWizard.Requests


**Date** 2022


**Group** Learning For Life

#### Fields

##### `global clientId` → `Id`

`INVOCABLEVARIABLE` 

##### `global endtime` → `DateTime`

`INVOCABLEVARIABLE` 

##### `global starttime` → `DateTime`

`INVOCABLEVARIABLE` 

---

---
