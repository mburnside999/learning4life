# LFLDTDRates

The main skill acquisition Rate calcs


**Name** LFLDTDRates


**Author** Mike Burnside


**Date** 2023


**Group** Learning For Life


**See** [LFLDTDRateMaster](/Learning-For-Life/LFLDTDRateMaster.md)

## Methods
### `public static String getAcquisitionRate(String clientId, Integer retro)`

`AURAENABLED`

Sets up a retrospective set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a combined JSON string

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the clientId|
|`retro`||

#### Returns

|Type|Description|
|---|---|
|`String`|JSON string|


**Name** getAcquisitionRate


**TODO** is this deprecated?

#### Example
```apex
String jsonStr = LFLDTDRateMaster.getDTDRateArray(clientId, 4);
```


### `public static String getAcquisitionRateByDates(String clientId, DateTime dt1, DateTime dt2)`

`AURAENABLED`

Sets up a retrospecitve set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a combined JSON string Used by LWC lflDTDAcquisitionRate

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the clientId|
|`dt1`|the starting datetime|
|`dt2`|the ending datetime|

#### Returns

|Type|Description|
|---|---|
|`String`|JSON string|


**Name** getAcquisitionRateByDates

#### Example
```apex
String jsonStr = LFLDTDRates.getAcquisitionRateByDates(clientId,s,e);
```


### `private static String buildJson(String clientId, list<aggregateresult> limitDatesList)`

Helper to do the grunt work of building JSON

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the clientId|
|`limitDatesList`|List<AggregateResult>|

#### Returns

|Type|Description|
|---|---|
|`String`|JSON string|


**Name** buildJson

#### Example
```apex
String jsonStr = LFLDTDRates.getAcquisitionRateByDates(clientId,s,e);
```


### `public static String getAcquisitionRateforClientTurbo(String clientId)`

`AURAENABLED`

Turbo rate calculator -- hardly any SOQL

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the clientId|

#### Returns

|Type|Description|
|---|---|
|`String`|JSON string|


**Name** getAcquisitionRateforClientTurbo

#### Example
```apex
String jsonStr = LFLDTDRates.getAcquisitionRateforClientTurbo(clientId);
```


---
