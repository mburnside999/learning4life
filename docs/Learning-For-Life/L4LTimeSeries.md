# L4LTimeSeries

Methods for creating and querying Client_Objective_TimeSeries\_\_c records

**Name** L4LTimeSeries

**Author** Mike Burnside

**Date** 2023

**Group** Learning For Life

## Methods

### `public Integer loadCOTimeSeries()`

Creates a timeseries by copying all client_objectives**c at a point in time. Timeseries table is client_objectives_timeseries**c Logging for the run is recorded in TimeSeries_Log\_\_c.

#### Returns

| Type      | Description                                                           |
| --------- | --------------------------------------------------------------------- |
| `Integer` | the number of records inserted into client_objectives_timeseries\_\_c |

**Name** loadCOTimeSeries

#### Example

```apex
Integer recs = L4LTimeSeries.loadCOTimeSeries();
```

### `public static Boolean previousCOTSLoad(Date d)`

check for previous COTS load

#### Parameters

| Param | Description       |
| ----- | ----------------- |
| `d`   | the date to check |

#### Returns

| Type      | Description                              |
| --------- | ---------------------------------------- |
| `Boolean` | true - Yes, there was another load today |

**Name** previousCOTSLoad

#### Example

```apex
Boolean anotherloadToday = L4LTimeSeries.previousSameDayCOTSLoad(Date);
```

### `public static String generateD3COTimeSeriesJson(String clientId, String status)`

`AURAENABLED`

Generate a JSON string for use by D3

#### Parameters

| Param      | Description              |
| ---------- | ------------------------ | ----------- |
| `clientId` |                          |
| `status`   | All (actually ACQ & CIP) | status\_\_c |

#### Returns

| Type     | Description                                                           |
| -------- | --------------------------------------------------------------------- |
| `String` | the number of records inserted into client_objectives_timeseries\_\_c |

**Name** generateD3COTimeSeriesJson

**Deprecated** No longer used

**TODO** example of format returned

#### Example

```apex
String jsonstr  = L4LTimeSeries.generateD3COTimeSeriesJson(clientId, 'All');
[{"rundate":"2022-11-27","val":2},{"rundate":"2022-12-4","val":2}]
```

### `public static String generateD3COTSJsonByProgramAndSD(String clientId, String program, String sd, String status, String periodStr)`

`AURAENABLED`

Generate a JSON string for use by D3 Used by LWC d3COTSCombinedLineChart- the combined Client Objective line chart

#### Parameters

| Param       | Description   |
| ----------- | ------------- | -------------------------------- | ---------------------------------------- |
| `clientId`  | the client Id |
| `program`   | "All"         | program_name\_\_c                |
| `sd`        | "All"         | sd_name\_\_c                     |
| `status`    | "Both" (ACQ   | CIP)                             | client_objective_timeseries**c.status**c |
| `periodStr` | "All"         | 30,60,90 days etc -- LAST N Days |

#### Returns

| Type     | Description   |
| -------- | ------------- |
| `String` | a JSON string |

**Name** generateD3COTSJsonByProgramAndSD

**TODO** example of format returned

#### Example

```apex
String jsonstr  = L4LTimeSeries.generateD3COTSJsonByProgramAndSD(clientId, programName,sdName,'Both','60');
jsonStr example: [{"rundate":"2023-2-12","val":8},{"rundate":"2023-2-19","val":9},...]
```

### `public static String generateD3COTimeSeriesByStatusJson(String clientId)`

`AURAENABLED`

Generate a JSON string for use by D3 Used by LWC d3MiniBars to plot Client Objectives TS as separate status charts

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | the client Id |

#### Returns

| Type     | Description   |
| -------- | ------------- |
| `String` | a JSON string |

**Name** generateD3COTimeSeriesByStatusJson

**TODO** example of format returned

#### Example

```apex
String jsonstr  = L4LTimeSeries.generateD3COTimeSeriesByStatusJson(clientId);
jsonStr example: [{"rundate":"2022-12-25","val":3,"status":"CIP"},
{"rundate":"2023-1-1","val":3,"status":"CIP"},{"rundate":"2023-1-8","val":3,"status":"CIP"},
{"rundate":"2023-1-15","val":6,"status":"ACQ"},{"rundate":"2023-1-22","val":4,"status":"ACQ"}
...]
```

### `public static String generateD3CORetestTimeSeriesJson(String clientId, String status)`

`AURAENABLED`

Generate a JSON string for use by D3 chart in d3COTSRetestChart

#### Parameters

| Param      | Description   |
| ---------- | ------------- | ---------------------------------------- |
| `clientId` | the client Id |
| `status`   | "All"         | client_objective_timeseries**c.status**c |

#### Returns

| Type     | Description   |
| -------- | ------------- |
| `String` | a JSON string |

**Name** generateD3CORetestTimeSeriesJson

**TODO** example of format returned

#### Example

```apex
String jsonstr  = L4LTimeSeries.generateD3CORetestTimeSeriesJson(clientId,'ACQ');
jsonStr example: [{"rundate":"2023-1-15","val":2},{"rundate":"2023-1-29","val":1},{"rundate":"2023-2-12","val":2},
{"rundate":"2023-2-19","val":1},{"rundate":"2023-2-26","val":3},{"rundate":"2023-3-5","val":4},
...]
```

### `public static String generateD3COTSThresholdJson(String clientId, Integer threshold1, Integer threshold2)`

`AURAENABLED`

Generate a JSON string for use by D3 Used by LWC l4lACQThresholdSummary

#### Parameters

| Param        | Description                                    |
| ------------ | ---------------------------------------------- |
| `clientId`   | the client Id                                  |
| `threshold1` | Integer hours of therapy -the first threshold  |
| `threshold2` | Integer hours of therapy -the second threshold |

#### Returns

| Type     | Description   |
| -------- | ------------- |
| `String` | a JSON string |

**Name** generateD3COTSThresholdJson

**TODO** logging

#### Example

```apex
String jsonstr  = L4LTimeSeries.generateD3COTSThresholdJson(clientId,100,200);
{"reserved1":1,"reserved2":2,
"sessiondata":[
{"thresholdHrs":100,"thresholdReached":false,"actualHrsAtThreshold":69.5,"runId":"TSL-2023-04-000042","runDate":"2023-04-23","dateAtThreshold":"2023-04-21 00:00:00",
"data":[
{"key":0,"programName":"Arts and Crafts","acquiredCount":1},
{"key":1,"programName":"Behaviour Vocabulary","acquiredCount":1},
...
{"key":6,"programName":"Conversation","acquiredCount":2},
...
{"key":16,"programName":"Why/because","acquiredCount":4}],
"acquiredTotal":55}
]}
```

---
