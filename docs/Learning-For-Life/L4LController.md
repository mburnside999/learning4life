---
layout: default
---
# L4LController

Main LWC controller class.


**Author** Mike Burnside


**Name** L4LController


**Date** 2022


**Group** Learning For Life

## Methods
### `static getSessionStatus(String recordId)`

`AURAENABLED`

Returns the status of a given session

#### Parameters

|Param|Description|
|---|---|
|`recordId`|The Session ID|

#### Return

**Type**

String

**Description**

Session status

#### Example
```apex
String status=L4LController.getSessionStatus(recordId);
```


### `static getPopularObjectives(String clientId)`

`AURAENABLED`

Returns a list of 50 popular Client Objectives, ignoring those that have been already allocated to the client.

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|

#### Return

**Type**

List&lt;Objective__c&gt;

**Description**

List of popular Client Objectives

#### Example
```apex
List<client_objective__c> coList = L4LController.getPopularObjectives(clientId)
```


### `static getSessionObjectives(String sess)`

`AURAENABLED`

returns a list session objectives for a session.

#### Parameters

|Param|Description|
|---|---|
|`sess`|The session Id|

#### Return

**Type**

List&lt;Session_obj__c&gt;

**Description**

List of session objectives

#### Example
```apex
List<session_obj__c> soList = L4LController.getSessionObjectives(sess)
```


### `static getClientObjectivesForSession(String searchKey)`

`AURAENABLED`

Returns a list of ACTIVE Client Objectives for a sesssion ordered by Program Name TODO fix parameter name

#### Parameters

|Param|Description|
|---|---|
|`searchKey`|The session Id|

#### Return

**Type**

List&lt;Client_Objective__c&gt;

**Description**

List of Client Objectives

#### Example
```apex
List<client_objective__c> coList = L4LController.getClientObjectivesForSession(sessionId)
```


### `static getClientObjectives(String clientId)`

`AURAENABLED`

Returns a list of Client Objectives for a client, ordered by Program Name, Name TODO fix parameter name

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|

#### Return

**Type**

List&lt;Client_Objective__c&gt;

**Description**

List of Client Objectives

#### Example
```apex
List<client_objective__c> coList = L4LController.getClientObjectives(clientId)
```


### `static getClientObjectivesFilteredOnActive(String clientId, boolean showActiveOnly)`

`AURAENABLED`

Returns a list of all, or active only Client Objectives for a client, ordered by Program Name, Name

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|
|`showActiveOnly`|Flag to indicate whether to show the ACTIVE objectives only|

#### Return

**Type**

List&lt;Client_Objective__c&gt;

**Description**

list of Client Objectives

#### Example
```apex
List<client_objective__c> coList = L4LController.getClientObjectivesFilteredOnActive(clientId,true)
```


### `static getCOActivationSummary(String clientId)`

`AURAENABLED`

Returns a JSON  string summarising ACTIVE, INACTIVE and TOTAL Client Objectives for a client

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The client Id|

#### Return

**Type**

String

**Description**

JSON string summary of statuses

#### Example
```apex
String aggStr = L4LController.getCOActivationSummary(clientId)
aggStr contains JSON string: {"active":20, "inactive":5,"total",25}
```


### `static deactivateClientObjective(String clientObjectiveId)`

`AURAENABLED`

Deactivates a Client Objective

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The Client Objective Id|

#### Return

**Type**

Client_Objective__c

**Description**

The deactivated client objective

#### Example
```apex
List<client_objective__c> coList = L4LController.deactivateClientObjective(clientObjectiveId)
```


### `static getUnusedObjectives(String clientId)`

`AURAENABLED`

Returns a list of all active objectives not yet assigned to a client

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The Client Objective Id|

#### Return

**Type**

List&lt;Objective__c&gt;

**Description**

List of client objectives not assigned to client

#### Example
```apex
List<objective__c> coList = L4LController.getUnusedObjectives(clientObjectiveId)
```


### `static getUnusedObjectivesBySearch(String clientId, String searchstring)`

`AURAENABLED`

Returns a list of all active objectives not yet assigned to this client that have a Name like %searchString%

#### Parameters

|Param|Description|
|---|---|
|`clientId`|The Client Objective Id|
|`searchstring`|The search string for the name|

#### Return

**Type**

List&lt;Objective__c&gt;

**Description**

list of client objectives not assigned to client

#### Example
```apex
List<objective__c> coList = L4LController.getUnusedObjectivesBySearch(clientId,'Banana')
```


### `static deleteSessionObjectives(String sessionid)`

`AURAENABLED`

Delete all session objectives for the session that have a Name like %searchString%

#### Parameters

|Param|Description|
|---|---|
|`sessionId`|The Session Id|

#### Return

**Type**

void

**Description**

void

#### Example
```apex
L4LController.deleteSessionObjectives(sessionId)
```


### `static createSessionObjectivesByArrayWithOrderedResults(String jsonstr, String sess, String skillstring)`

`AURAENABLED`

For a given session, for each client objective in a list create session objectives from its list of DTD scores

#### Parameters

|Param|Description|
|---|---|
|`jsonStr`|A JSON string containing a list of client objectives|
|`sess`|The session Id|
|`skillstring`|A JSON string containing a list of DTD scores|

#### Return

**Type**

List&lt;Session_Obj__c&gt;

**Description**

the number of session objectives added

#### Example
```apex
Integer noOfCreatedSessionObjs = L4LController.createSessionObjectivesByArrayWithOrderedResults(jsonStr,sess,skillstring)
```


### `static createClientObjectivesByArray(String jsonstr, String sess)`

`AURAENABLED`

Create client objectives from a JSON list of objectives

#### Parameters

|Param|Description|
|---|---|
|`jsonStr`|A JSON string containing a list of objectives|
|`sess`|The session Id|

#### Return

**Type**

Integer

**Description**

The number of client objectives added

#### Example
```apex
Integer noOfCreatedClientObjs = L4LController.createClientObjectivesByArray(jsonStr,sess)
```


### `static setSessionObjectivesByArray(String jsonstr, String val)`

`AURAENABLED`

Update session objective scores from a JSON list

#### Parameters

|Param|Description|
|---|---|
|`jsonStr`|A JSON string containing a list of session objectives to update|
|`Val`|The score - "Correct" or "Incorrect" ...etc|

#### Return

**Type**

Integer

**Description**

The number of session objectives updated

#### Example
```apex
Integer noOfSessionObjsUpdated = L4LController.setSessionObjectivesByArray(jsonStr,'Correct')
```


### `static setClientObjectivesByArray(String jsonstr, String val)`

`AURAENABLED`

For a list of client objectives, update to a common status or activate/deactivate

#### Parameters

|Param|Description|
|---|---|
|`jsonStr`|A JSON string containing a list of client objectives to update|
|`val`|"ACQ" or "OBJ" or "Activate" or "Deactivate"|

#### Return

**Type**

Integer

**Description**

The number of client objectives updated

#### Example
```apex
Integer noOfClientObjsUpdated = L4LController.setClientObjectivesByArray(jsonStr,'ACQ')
Integer noOfClientObjsActivated = L4LController.setClientObjectivesByArray(jsonStr,'Activater')
```


### `static updateSessionObjectiveWithLG(String sessObjId)`

`AURAENABLED`

Updates Session Objective comment to "LG"

#### Parameters

|Param|Description|
|---|---|
|`sessObjId`|Session Objective id|

#### Return

**Type**

String

**Description**

Summary of change to Session Objective

#### Example
```apex
String str = L4LController.updateSessionObjectiveWithLG(sessObjId)
```


---
## Classes
### SessionResult
#### Properties

##### `skill` → `String`


---

---
