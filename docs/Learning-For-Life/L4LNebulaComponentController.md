# L4LNebulaComponentController

Utility class for Nebula logger


**Author** Mike Burnside


**Name** L4LNebulaComponentController


**Date** 2023


**Group** Learning For Life

## Fields

### `private nebulaId` → `String`


---
## Methods
### `public static void setupCache()`

`AURAENABLED`

Set up caching

#### Returns

|Type|Description|
|---|---|
|`void`|Session status|

#### Example
```apex
String status=L4LController.getSessionStatus(recordId);
```


### `public static void logWarning(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Warnings

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Returns

|Type|Description|
|---|---|
|`void`|void|

#### Example
```apex
```


### `public static void logInfo(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Info

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Returns

|Type|Description|
|---|---|
|`void`|void|

#### Example
```apex
```


### `public static void logFine(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Fine

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Returns

|Type|Description|
|---|---|
|`void`|void|

#### Example
```apex
```


### `public static void logError(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Errors

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Returns

|Type|Description|
|---|---|
|`void`|void|

#### Example
```apex
```


### `public static void logDebug(String recordId, String message, String scenario, String tag)`

`AURAENABLED`

Helper for logging Debug

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The related record|
|`message`|The message text|
|`scenario`|The logging scanario|
|`tag`|The logging tag|

#### Returns

|Type|Description|
|---|---|
|`void`|void|

#### Example
```apex
```


### `private static void saveNebulaLog()`

Save Nebula log

#### Returns

|Type|Description|
|---|---|
|`void`|void|

#### Example
```apex
```


---
