---
layout: default
---

# L4LInvocableListUnusedObj

Invocable methods used by Flow to list unused objectives

**Author** Mike Burnside

**Name**

**Date** 2022

**Group** Learning For Life

## Methods

### `static RemoveRecords(List<InputVariables> inputVariables)`

`INVOCABLEMETHOD`

Return unused objectives

#### Parameters

| Param            | Description             |
| ---------------- | ----------------------- |
| `inputVariables` | List of Input Variables |

#### Return

**Type**

List&lt;List&lt;Objective\_\_c&gt;&gt;

**Description**

#### Example

```apex
String status=L4LController.getSessionStatus(recordId);
```

---

## Classes

### InputVariables

#### Fields

##### `getClientObj` → `List&lt;Client_Objective__c&gt;`

`INVOCABLEVARIABLE`

##### `getSDObj` → `List&lt;Objective__c&gt;`

`INVOCABLEVARIABLE`

---

### ReturnVariables

#### Fields

##### `lstfilteredRecords` → `List&lt;List&lt;Objective__c&gt;&gt;`

`INVOCABLEVARIABLE`

---

---
