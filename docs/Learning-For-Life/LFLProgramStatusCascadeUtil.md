---
layout: default
---
# LFLProgramStatusCascadeUtil

Util class.
Methods for pushing of Status values down the hierarchy of Programs--&lt; SD--&lt; Objectives.
Status values are Active|Inactive|Draft


**Name** LFLProgramStatusCascadeUtil


**Author** Mike Burnside


**Date** 2023


**Group** Learning For Life

## Methods
### `static updateSDStatusByMap(Map<id,string> statusMap)`

Push changed Program status values to related SDs. Invoked by Program__c trigger: trgCascadeProgramStatus.

#### Parameters

|Param|Description|
|---|---|
|`statusMap`|Map of changed Program status values|

#### Return

**Type**

void

**Description**

void


**Name** updateSDStatusByMap

#### Example
```apex
```


### `static updateObjectiveStatusByMap(Map<id,string> statusMap)`

Push changed SD status values to related Objectives Invoked by SD__c trigger: trgCascadeSDStatus

#### Parameters

|Param|Description|
|---|---|
|`statusMap`|Map of changed SD status values|

#### Return

**Type**

void

**Description**

void


**Name** updateObjectiveStatusByMap

#### Example
```apex
```


---
