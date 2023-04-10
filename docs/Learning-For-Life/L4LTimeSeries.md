---
layout: default
---
# L4LTimeSeries

methods for creating and querying Client_Objective_TimeSeries__c records


**Name** L4LTimeSeries


**Author** Mike Burnside


**Date** 2023


**Group** Learning For Life

## Methods
### `loadCOTimeSeries()`

creates a timeseries by copying all client_objectives__c at a point in time. Timeseries table is client_objectives_timeseries__c Logging for the run is recorded in TimeSeries_Log__c.

#### Return

**Type**

Integer

**Description**

the number of records inserted into client_objectives_timeseries__c


**Name** loadCOTimeSeries

#### Example
```apex
Integer recs = L4LTimeSeries.loadCOTimeSeries();
```


### `static generateD3COTimeSeriesJson(String clientId, String status)`

`AURAENABLED`

generate a JSON string for use by D3

#### Parameters

|Param|Description|
|---|---|
|`clientId`||
|`status`|All (actually ACQ & CIP) | status__c|

#### Return

**Type**

String

**Description**

the number of records inserted into client_objectives_timeseries__c


**Name** generateD3COTimeSeriesJson


**TODO** example of format returned

#### Example
```apex
String jsonstr  = L4LTimeSeries.generateD3COTimeSeriesJson(clientId, 'All');
```


### `static generateD3COTSJsonByProgramAndSD(String clientId, String program, String sd, String status, String periodStr)`

`AURAENABLED`

generate a JSON string for use by D3

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the client Id|
|`program`|"All" | program_name__c|
|`sd`|"All" | sd_name__c|
|`status`|"Both" (ACQ|CIP) | client_objective_timeseries__c.status__c|
|`periodStr`|"All" | 30,60,90 days etc -- LAST N Days|

#### Return

**Type**

String

**Description**

a JSON string


**Name** generateD3COTSJsonByProgramAndSD


**TODO** example of format returned

#### Example
```apex
String jsonstr  = L4LTimeSeries.generateD3COTSJsonByProgramAndSD(clientId, programName,sdName,'Both',60);
```


### `static generateD3COTimeSeriesByStatusJson(String clientId)`

`AURAENABLED`

generate a JSON string for use by D3

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the client Id|

#### Return

**Type**

String

**Description**

a JSON string


**Name** generateD3COTimeSeriesByStatusJson


**TODO** example of format returned

#### Example
```apex
String jsonstr  = L4LTimeSeries.generateD3COTimeSeriesByStatusJson(clientId);
```


### `static generateD3CORetestTimeSeriesJson(String clientId, String status)`

`AURAENABLED`

generate a JSON string for use by D3

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the client Id|
|`status`|"All" | client_objective_timeseries__c.status__c|

#### Return

**Type**

String

**Description**

a JSON string


**Name** generateD3CORetestTimeSeriesJson


**TODO** example of format returned

#### Example
```apex
String jsonstr  = L4LTimeSeries.generateD3CORetestTimeSeriesJson(clientId,'ACQ');
```


### `static generateD3COTSThresholdJson(String clientId, Integer threshold1, Integer threshold2)`

`AURAENABLED`

generate a JSON string for use by D3

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the client Id|
|`threshold1`|Integer hours of therapy -the first threshold|
|`threshold2`|Integer hours of therapy -the second threshold|

#### Return

**Type**

String

**Description**

a JSON string


**Name** generateD3COTSThresholdJson


**TODO** logging

#### Example
```apex
String jsonstr  = L4LTimeSeries.generateD3COTSThresholdJson(clientId,100,200);
```


---
