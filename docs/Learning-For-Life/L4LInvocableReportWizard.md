---
layout: default
---
# L4LInvocableReportWizard

As of January 19, 2022 this is the controller for MDH's Report Wizard flow


**Author** Mike Burnside


**Name** L4LInvocableReportWizard #description Invocable methods used by the Report Wizard flow


**Date** 2022


**Group** Learning For Life

## Methods
### `static getStatusCountsBetweenDates(List<Requests> requests)`

`INVOCABLEMETHOD`

returns the status of a given session

#### Parameters

|Param|Description|
|---|---|
|`requests`|List<Request>|

#### Return

**Type**

List&lt;String&gt;

**Description**

result List&lt;String&gt;

#### Example
```apex
```


### `static countAllTimeAcquired(Id clientId, String pname)`
### `static getObjectiveList(Id clientId, String pname, Datetime starttime, Datetime endtime, String status)`
---
## Classes
### Requests



**Author** Mike Burnside


**Name** L4LInvocableReportWizard.Requests


**Date** 2022


**Group** Learning For Life

#### Fields

##### `clientId` → `Id`

`INVOCABLEVARIABLE` 

##### `endtime` → `DateTime`

`INVOCABLEVARIABLE` 

##### `starttime` → `DateTime`

`INVOCABLEVARIABLE` 

---

---
