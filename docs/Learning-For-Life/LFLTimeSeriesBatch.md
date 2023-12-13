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

### `public email` → `String`

### `public query` → `String`

### `public recs` → `integer`

### `public runId` → `String`

---

## Methods

### `public Database start(Database bc)`

Start

#### Parameters

| Param | Description |
| ----- | ----------- |
| `bc`  |             |

#### Returns

| Type       | Description |
| ---------- | ----------- |
| `Database` |             |

**Name** start

### `public void execute(Database bc, List<sObject> scope)`

Start

#### Parameters

| Param   | Description       |
| ------- | ----------------- |
| `bc`    | batchable context |
| `scope` | scope             |

**Name** execute

### `public void finish(Database bc)`

Start

#### Parameters

| Param | Description       |
| ----- | ----------------- |
| `bc`  | batchable context |

**Name** finish

---
