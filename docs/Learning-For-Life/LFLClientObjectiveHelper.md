# LFLClientObjectiveHelper

Helper methods for Report Wizard


**Name** LFLClientObjectiveHelper


**Author** Mike Burnside


**Date** 2023


**Group** Learning For Life

## Methods
### `public static String getStatusCountsBetweenDates(DateTime starttime, DateTime endtime, Id clientid)`

Helper method for the Report Wizard returns a formatted string for insertion into a long text area ..., amd inserts the string into NDIS_Report__c.NDIS_Report__c;

#### Parameters

|Param|Description|
|---|---|
|`starttime`||
|`endtime`||
|`Id`|the client id|

#### Returns

|Type|Description|
|---|---|
|`String`|a string used by the Report Wizard Flow|


**Name** getStatusCountsBetweenDates


**TODO** improve explanation

#### Example
```apex
String str = LFLClientObjectiveHelper.getStatusCountsBetweenDates(starttime, endtime, clientId);
```


---
