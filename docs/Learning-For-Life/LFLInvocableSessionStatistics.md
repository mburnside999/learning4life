---
layout: default
---

# LFLInvocableSessionStatistics

Invocable methods, called from Flow to support session closure

**Name** LFLInvocableSessionStatistics

**Author** Mike Burnside

**Date** 2023

**Group** Learning For Life

## Methods

### `static computeSessionStats(List<Id> sessions)`

`INVOCABLEMETHOD`

computes statistics for a session. Inserts session_statistics\_\_c records. This method is an InvocableMethod and is called from Flow when a Session is closed. Flow uses the returned String to update the session with a rich text summary.

#### Parameters

| Param      | Description     |
| ---------- | --------------- |
| `sessions` | , a list of Ids |

#### Return

**Type**

List&lt;Response&gt;

**Description**

a list of responses List&lt;Response&gt; (i.e. a single String response to Flow)

**Name** computeSessionStats

#### Example

```apex

```

---

## Classes

### Response

#### Fields

##### `outputString` → `String`

`INVOCABLEVARIABLE`

---

---
