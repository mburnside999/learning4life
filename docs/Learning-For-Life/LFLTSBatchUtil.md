# LFLTSBatchUtil

Perform batch integrity checks on CO Timeseries.

**Implemented types**

[Database.Batchable&lt;sobject&gt;](Database.Batchable<sobject>)
,
[Database.Stateful](Database.Stateful)

**Author** Mike Burnside

**Name** LFLTSBatchUtil

**Date** 2023

**Group** Learning For Life

## Fields

### `private i` → `Integer`

### `private mapper` → `Map<Date,Set<String>>`

### `private nullStatus` → `Integer`

### `private runcounts` → `Map<String,Integer>`

### `private runidSet` → `Set<string>`

---

## Methods

### `global Database start(Database bc)`

### `global void execute(Database bc, List<client_objective_timeseries__c> listCOTS)`

### `global void finish(Database bc)`

---
