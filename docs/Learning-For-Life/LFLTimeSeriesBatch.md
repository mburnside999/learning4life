---
layout: default
---

# LFLTimeSeriesBatch

Batchable class for running the CO timeseries

**Implemented types**

[Database.Batchable&lt;sObject&gt;](Database.Batchable<sObject>)
,
[Database.Stateful](Database.Stateful)

**Name** LFLTimeSeriesBatch

**Author** Mike Burnside

**Date** 2023

**Group** Learning For Life

## Fields

### `email` → `String`

### `query` → `String`

### `recs` → `integer`

### `runId` → `String`

---

## Methods

### `start(Database BC)`

Start

#### Parameters

| Param | Description |
| ----- | ----------- |
| `BC`  |             |

#### Return

**Type**

Database

**Description**

**Name** start

### `execute(Database BC, List<sObject> scope)`

Start

#### Parameters

| Param   | Description |
| ------- | ----------- |
| `BC`    |             |
| `scope` |             |

#### Return

**Type**

void

**Description**

**Name** execute

### `finish(Database BC)`

Start

#### Parameters

| Param | Description |
| ----- | ----------- |
| `BC`  |             |

#### Return

**Type**

void

**Description**

**Name** finish

---
