---
layout: default
---

# LFLDTDRates

The main skill acquisition Rate calcs

**Name** LFLDTDRates

**Author** Mike Burnside

**Date** 2023

**Group** Learning For Life

**See** [LFLDTDRateMaster](./LFLDTDRateMaster.md)

## Methods

### `static getAcquisitionRate(String clientId, Integer retro)`

`AURAENABLED`

Sets up a retrospective set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a combined JSON string

#### Parameters

| Param      | Description  |
| ---------- | ------------ |
| `clientId` | the clientId |
| `retro`    |              |

#### Return

**Type**

String

**Description**

JSON string

**Name** getAcquisitionRate

**TODO** is this deprecated?

#### Example

```apex
String jsonStr = LFLDTDRateMaster.getDTDRateArray(clientId, 4);
```

### `static getAcquisitionRateByDates(String clientId, DateTime dt1, DateTime dt2)`

`AURAENABLED`

Sets up a retrospecitve set of weekly periods, relative to today(), iterates calls to the LFLDTDRates class and returns a combined JSON string

#### Parameters

| Param      | Description           |
| ---------- | --------------------- |
| `clientId` | the clientId          |
| `dt1`      | the starting datetime |
| `dt2`      | the ending datetime   |

#### Return

**Type**

String

**Description**

JSON string

**Name** getAcquisitionRateByDates

#### Example

```apex
String jsonStr = LFLDTDRates.getAcquisitionRateByDates(clientId,s,e);
```

### `static buildJson(String clientId, list<aggregateresult> limitDatesList)`

Helper to do the grunt work of building JSON

#### Parameters

| Param            | Description           |
| ---------------- | --------------------- |
| `clientId`       | the clientId          |
| `limitDatesList` | List<AggregateResult> |

#### Return

**Type**

String

**Description**

JSON string

**Name** buildJson

#### Example

```apex
String jsonStr = LFLDTDRates.getAcquisitionRateByDates(clientId,s,e);
```

---
