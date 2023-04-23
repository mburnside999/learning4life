---
layout: default
---

# LFLDTDRateMaster

Methods to support the acquisition Rate calculations

**Name** LFLDTDRateMaster

**Author** Mike Burnside

**Date** 2023

**Group** Learning For Life

**See** [LFLDTDRates](./LFLDTDRates.md)

## Methods

### `static getDTDRateArray(String clientId, Integer iters)`

`AURAENABLED`

Sets up a retrospective set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a combined JSON string

#### Parameters

| Param      | Description                                                                  |
| ---------- | ---------------------------------------------------------------------------- |
| `clientId` | the clientId                                                                 |
| `iters`    | the integer number of iterations (weeks) - so "4" means 4 weeks up until now |

#### Return

**Type**

String

**Description**

JSON string

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

##### `acquiredPerSession` → `Decimal`

##### `elapsed` → `Decimal`

##### `endAcquiredCount` → `Integer`

##### `endd` → `Date`

##### `numberAcquiredInPeriod` → `Integer`

##### `rate` → `Decimal`

##### `sessionCount` → `Integer`

##### `startAcquiredCount` → `Integer`

##### `startd` → `Date`

##### `totalSessionDurationHrs` → `Decimal`

##### `weeks` → `Decimal`

---

---
