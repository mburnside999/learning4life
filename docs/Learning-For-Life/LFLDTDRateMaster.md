# LFLDTDRateMaster

Methods to support the acquisition Rate calculations


**Name** LFLDTDRateMaster


**Author** Mike Burnside


**Date** 2023


**Group** Learning For Life


**See** [LFLDTDRates](/Learning-For-Life/LFLDTDRates.md)

## Methods
### `public static String getDTDRateArray(String clientId, Integer iters)`

`AURAENABLED`

Sets up a retrospective set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a combined JSON string

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the clientId|
|`iters`|the integer number of iterations (weeks) - so "4" means 4 weeks up until now|

#### Returns

|Type|Description|
|---|---|
|`String`|JSON string|


**Name** getDTDRateArray

#### Example
```apex
String jsonStr = LFLDTDRateMaster.getDTDRateArray(clientId, 4);
```


---
## Classes
### RateStats

inner class to represent the structure of the returned JSON


**Name** LFLDTDSRateMAster.RateStats


**Author** Mike Burnside


**Date** 2023


**Group** Learning For Life

#### Properties

##### `public acquiredPerSession` → `Decimal`


##### `public elapsed` → `Decimal`


##### `public endAcquiredCount` → `Integer`


##### `public endd` → `Date`


##### `public numberAcquiredInPeriod` → `Integer`


##### `public rate` → `Decimal`


##### `public sessionCount` → `Integer`


##### `public startAcquiredCount` → `Integer`


##### `public startd` → `Date`


##### `public totalSessionDurationHrs` → `Decimal`


##### `public weeks` → `Decimal`


---

---
