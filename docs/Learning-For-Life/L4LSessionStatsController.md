# L4LSessionStatsController

Main session stats generator.


**Author** Mike Burnside


**Date** 2022


**Group** Learning For Life

## Methods
### `public static LFL_Stats_Boundary__mdt getHighAndLowBoundaries()`

`AURAENABLED`

Queries lfl_stats_boundary instance of LFL_Stats_Boundary__mdt metadata to obtain the High/Low parameters to control Red/Yellow UI traffic light colours Used in LWC d3HeatMap

#### Returns

|Type|Description|
|---|---|
|`LFL_Stats_Boundary__mdt`|Custom metadata record, lfl_stats_boundary|


**Name** getHighAndLowBoundaries

#### Example
```apex
LFL_Stats_Boundary__mdt highsandlows = L4LSessionStatsController.getHighAndLowBoundaries()
```


### `public static List<session_statistics__c> getD3SessionStatsHistogramData(String clientId)`

`AURAENABLED`

Returns the session statistics for a client Used by LWC d3Histogram

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client ID|

#### Returns

|Type|Description|
|---|---|
|`List<session_statistics__c>`|A list of session statistics, List<session_statistics__c>|


**Name** getD3SessionStatsHistogramData

#### Example
```apex
List<session_statistics__c> > ssList = L4LSessionStatsController.getD3SessionStatsHistogramData(clientId)
```


### `public static List<Session_Statistics__c> getSessionStats(String searchKey)`

`AURAENABLED`

Return a list of session stats Used in l4lSessionStatsDatatable

#### Parameters

|Param|Description|
|---|---|
|`searchKey`|The session ID|

#### Returns

|Type|Description|
|---|---|
|`List<Session_Statistics__c>`|A list of Session_Statistics__c|


**Name** getSessionStats


**TODO** fix the parameter naming

#### Example
```apex
List<session_statistics__c> > ssList = L4LSessionStatsController.getSessionStats(clientId)
```


### `public static List<Session_Statistics__c> getD3Stats(String clientId, Boolean showAcquired)`

`AURAENABLED`

Uses SOQL to return a session statistics for a client.

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client|
|`showAcquired`|A Boolean, should we restrict to previous_status of ACQ|

#### Returns

|Type|Description|
|---|---|
|`List<Session_Statistics__c>`|a list of session statistics|


**Name** getD3Stats


**Deprecated** 

#### Example
```apex
List<session_statistics__c> > ssList = L4LSessionStatsController.getD3Stats(clientId,true|false)
```


### `public static List<Session_Statistics__c> getD3StatsByProgram(String clientId, String programStr, Boolean showAcquired)`

`AURAENABLED`

Uses SOQL to return a list of session statistics filtered on program name, and optionally previous status

#### Parameters

|Param|Description|
|---|---|
|`clientId`|Client ID|
|`programStr`|The Program Name|
|`showAcquired`|A Boolean, should we restrict to previous status of ACQ|

#### Returns

|Type|Description|
|---|---|
|`List<Session_Statistics__c>`|a list of session statistics|


**Name** getD3StatsByProgram

#### Example
```apex
List<session_statistics__c> > ssList = L4LSessionStatsController.getD3StatsByProgram(clientId,programStr,true|false)
```


### `public static List<AggregateResult> getClientObjectivesByProgram(String clientId)`

`AURAENABLED`

Uses SOQL to return a COUNT of objectives from Client_Objectives__c GROUPed BY the program name

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|

#### Returns

|Type|Description|
|---|---|
|`List<AggregateResult>`|A list of aggregate results, List<AggregateResult>|


**Name** getClientObjectivesByProgram

#### Example
```apex
List<AggregateResult>  arl = L4LSessionStatsController.getClientObjectivesByProgram(clientId)
```


### `public static Integer getD3YAxisScale(String clientId)`

`AURAENABLED`

A helper for D3 charting to establish the scale required for the Y Axis. Uses SOQL to count the # of ACTIVE client_objectives, and # of client_objective_timeseries records for a client

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The Client ID|

#### Returns

|Type|Description|
|---|---|
|`Integer`|an Integer, the higher of the two counts|


**Name** getD3YAxisScale


**Deprecated** LWC d3COTSRetestChart


**TODO** look at the requirement for ACTIVE only

#### Example
```apex
```


### `public static Integer getD3RetestYAxisScale(String clientId)`

`AURAENABLED`

A helper for D3 charting to establish the scale required for the Retest Y Axis. Uses SOQL to count the # of ACTIVE and Re_Test_Recommended client_objectives and client_objective_timeseries records for a client Used by LWC d3COTSRetestChart

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The Client ID|

#### Returns

|Type|Description|
|---|---|
|`Integer`|an Integer, the higher of the two counts|


**Name** getD3RetestYAxisScale


**TODO** look at the requirement for ACTIVE only

#### Example
```apex
```


### `public static Integer getD3StatusYAxisScale(String clientId)`

`AURAENABLED`

A helper for D3 charting to establish the scale for the Y Axis. Uses SOQL to return the maximum count for any status for all runs of client_objective_timeseries records for a client

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client ID|

#### Returns

|Type|Description|
|---|---|
|`Integer`|an Integer - maximum status count for any run for the client|


**Name** getD3StatusYAxisScale


**Deprecated** 

#### Example
```apex
```


### `public static List<Session_Statistics__c> getD3StatsByProgramAndSD(String clientId, String programStr, String sdStr, Boolean showAcquired, String periodStr, String stageStr, String therapistStr)`

`AURAENABLED`

Use SOQL to create a list of session_statistics__c for a client according to filter parameters Used by LWC d3HeatMap in support of D3 charting

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|
|`programStr`|"All" | program_name__c|
|`sdStr`|"All"  sd_name__c|
|`showAcquired`|True | False, restrict to ACQ only or not|
|`periodStr`|"All" | 30,60,90 days etc|
|`stageStr`|"All" | objective__r.sd__r.Stage__c|
|`therapistStr`|"All" | session__r.therapy_name__c|

#### Returns

|Type|Description|
|---|---|
|`List<Session_Statistics__c>`|a list of session_Statistics__c|


**Name** getD3StatsByProgramAndSD

#### Example
```apex
```


### `public static List<Program__c> getProgramsAndSds(String stageStr)`

`AURAENABLED`

Use SOQL to create a list of Programs filtered by Stage Used by LWC d3Nest

#### Parameters

|Param|Description|
|---|---|
|`stageStr`||

#### Returns

|Type|Description|
|---|---|
|`List<Program__c>`|a list of session_Statistics__c|


**Name** getProgramsAndSds

#### Example
```apex
```


### `public static List<AggregateResult> getClientObjectivesSDCount(String clientId)`

`AURAENABLED`

Returns as a List&lt;AggregateResult&gt; the count of client_objectives__c for a client, grouped by program, sd Used by LWC d3Nest

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client ID|

#### Returns

|Type|Description|
|---|---|
|`List<AggregateResult>`|An AggregateResult list|


**Name** getClientObjectivesSDCount

#### Example
```apex
```


### `public static String generateD3ProgramAreaSDJson(String clientId, String stageStr)`

`AURAENABLED`

Generates a JSON string  for use by D3 charting Used by LWC d3NestExperiment

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|
|`stageStr`|"All" | sd__c.stage__c|

#### Returns

|Type|Description|
|---|---|
|`String`|a JSON string|


**Name** generateD3ProgramAreaSDJson


**TODO** deprecated?


**TODO** work on the explanation and provide an example

#### Example
```apex
```


### `public static String generateD3AreaSDJson(String clientId, String stageStr)`

`AURAENABLED`

Generates a JSON string  for use by D3 charting. Used by LWC d3NestExperiment Sorts list of SDs by Name using a custom sorter comparison method in LFLSDWrapper

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|
|`stageStr`|"All" | sd__c.stage__c|

#### Returns

|Type|Description|
|---|---|
|`String`|a JSON string|


**Name** generateD3AreaSDJson


**See** [LFLSDWrapper](/Learning-For-Life/LFLSDWrapper.md)


**TODO** work on the explanation and provide an example

#### Example
```apex
```


### `public static String generateD3BOCJson(String clientId, String periodStr)`

`AURAENABLED`

Generates a JSON string  for use by D3 charting. Used by LWC d3BOCHeatmap

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|
|`periodStr`|the period for returning sessions|

#### Returns

|Type|Description|
|---|---|
|`String`|jsnStr a JSON string|


**Name** generateD3BOCJson


**TODO** work on the explanation and provide an example

#### Example
```apex
```


### `public static List<String> getProgramSetFromCO(String clientId)`

`AURAENABLED`

Generates a set (well actually a Set coerced into a List because LWC can't accept Sets) of Programs currently used in this client's client objectives. Used in pull down filters on D3 charts Used in LWC d3HorizontalLollipopChart

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|

#### Returns

|Type|Description|
|---|---|
|`List<String>`|A set of Program names as List<String>|


**Name** getProgramSetFromCO


**TODO** logging

#### Example
```apex
```


### `public static List<String> getSDSetFromCO(String clientId)`

`AURAENABLED`

Generates a set (well actually a Set coerced into a List because LWC can't accept Sets) of SDs currently used in this client's client objectives. Used in pull down filters on D3 charts

#### Parameters

|Param|Description|
|---|---|
|`clientId`|the client Id|

#### Returns

|Type|Description|
|---|---|
|`List<String>`|a set of SD names as  List<String>|


**Name** getSDSetFromCO


**TODO** logging

#### Example
```apex
```


---
