---
layout: default
---

# LFLClientObjectiveHelper

helper methods for Report Wizard

**Name** LFLClientObjectiveHelper

**Author** Mike Burnside

**Date** 2023

**Group** Learning For Life

## Methods

### `static getStatusCountsBetweenDates(DateTime starttime, DateTime endtime, Id clientid)`

helper method for the Report Wizard returns a formatted string for insertion into a long text area ..., amd inserts the string into NDIS_Report**c.NDIS_Report**c;

#### Parameters

| Param       | Description   |
| ----------- | ------------- |
| `starttime` |               |
| `endtime`   |               |
| `Id`        | the client id |

#### Return

**Type**

String

**Description**

a string used by the Report Wizard Flow

**Name** getStatusCountsBetweenDates

**TODO** improve explanation

#### Example

```apex
String str = LFLClientObjectiveHelper.getStatusCountsBetweenDates(starttime, endtime, clientId);
```

---
