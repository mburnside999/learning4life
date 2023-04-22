---
layout: default
---
# L4LNebulaComponentController

Utility class for Nebula logger


**Author** Mike Burnside


**Name** L4LNebulaComponentController


**Date** 2023


**Group** Learning For Life

## Fields

### `nebulaId` → `String`


---
## Methods
### `static setupCache()`

`AURAENABLED`

Set up caching

#### Return

**Type**

void

**Description**

Session status

#### Example
```apex
String status=L4LController.getSessionStatus(recordId);
```


### `static logWarning(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Warnings

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Return

**Type**

void

**Description**

void

#### Example
```apex
```


### `static logInfo(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Info

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Return

**Type**

void

**Description**

void

#### Example
```apex
```


### `static logFine(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Fine

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Return

**Type**

void

**Description**

void

#### Example
```apex
```


### `static logError(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Errors

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Return

**Type**

void

**Description**

void

#### Example
```apex
```


### `static logDebug(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Debug

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Return

**Type**

void

**Description**

void

#### Example
```apex
```


### `static saveNebulaLog()`

Save Nebula log

#### Return

**Type**

void

**Description**

void

#### Example
```apex
```


---
