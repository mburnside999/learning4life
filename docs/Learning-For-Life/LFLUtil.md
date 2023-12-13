# LFLUtil

Utility class for parsing JSON

**Name** public with sharing class LFLUtil

**Author** Mike Burnside

**Date** 2023

**Group** Learning For Life

## Methods

### `public static Boolean isValidJSON(String jsonstr)`

Parse and validate JSON

#### Parameters

| Param     | Description                 |
| --------- | --------------------------- |
| `jsonStr` | JSON string to be validated |

#### Returns

| Type      | Description |
| --------- | ----------- | --------------------------------------------- |
| `Boolean` | true        | false Whether the string is valid JSON or not |

**Name** isValidJSON

**See** [TestL4LSessionStatsController](/Learning-For-Life-Testing/TestL4LSessionStatsController.md)

#### Example

```apex
Boolean isValid=LFLUtil.isValidJSON(jsonStr);
```

---
