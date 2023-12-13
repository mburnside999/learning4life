# L4LController

`SUPPRESSWARNINGS`

Main LWC controller class.

**Author** Mike Burnside

**Name** L4LController

**Date** 2022

**Group** Learning For Life

## Methods

### `public static String getSessionStatus(String recordId)`

`AURAENABLED`

Returns the status of a given session

#### Parameters

| Param      | Description    |
| ---------- | -------------- |
| `recordId` | The Session ID |

#### Returns

| Type     | Description    |
| -------- | -------------- |
| `String` | Session status |

#### Example

```apex
String status=L4LController.getSessionStatus(recordId);
```

### `public static List<Objective__c> getPopularObjectives(String clientId)`

`AURAENABLED`

Returns a list of 50 popular Client Objectives, ignoring those that have been already allocated to the client.

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client Id |

#### Returns

| Type                 | Description                       |
| -------------------- | --------------------------------- |
| `List<Objective__c>` | List of popular Client Objectives |

#### Example

```apex
List<client_objective__c> coList = L4LController.getPopularObjectives(clientId)
```

### `public static List<Behaviour_of_Concern__c> getPopularCBOC(String clientId)`

`AURAENABLED`

Returns a list of 50 popular Client BOC, ignoring those that have been already allocated to the client.

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client Id |

#### Returns

| Type                            | Description             |
| ------------------------------- | ----------------------- |
| `List<Behaviour_of_Concern__c>` | List of Client_BOC\_\_c |

#### Example

```apex
List<client_BOC__c> cbocList = L4LController.getPopularCBOC(clientId)
```

### `public static List<client_BOC__c> getActiveCBOCList(String clientId)`

`AURAENABLED`

Returns a list of active Client BOC for a Client

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client Id |

#### Returns

| Type                  | Description                    |
| --------------------- | ------------------------------ |
| `List<client_BOC__c>` | List of active Client_BOC\_\_c |

#### Example

```apex
List<client_BOC__c> cbocList = L4LController.getActiveCBOC(clientId)
```

### `public static List<Session_obj__c> getSessionObjectives(String sess)`

`AURAENABLED`

returns a list session objectives for a session.

#### Parameters

| Param  | Description    |
| ------ | -------------- |
| `sess` | The session Id |

#### Returns

| Type                   | Description              |
| ---------------------- | ------------------------ |
| `List<Session_obj__c>` | List of session_obj\_\_c |

#### Example

```apex
List<session_obj__c> soList = L4LController.getSessionObjectives(sess)
```

### `public static List<Session_BOC__c> getSessionBOC(String sess)`

`AURAENABLED`

returns a list of session BOCs for a session.

#### Parameters

| Param  | Description    |
| ------ | -------------- |
| `sess` | The session Id |

#### Returns

| Type                   | Description              |
| ---------------------- | ------------------------ |
| `List<Session_BOC__c>` | List of session_boc\_\_c |

#### Example

```apex
List<Session_BOC__c> soList = L4LController.getSessionBOC(sess)
```

### `public static List<Client_BOC__c> getClientBOCForSession(String sessionId)`

`AURAENABLED`

Returns a list of ACTIVE Client BOC for a sesssion TODO fix parameter name

#### Parameters

| Param       | Description    |
| ----------- | -------------- |
| `sessionId` | The session Id |

#### Returns

| Type                  | Description                    |
| --------------------- | ------------------------------ |
| `List<Client_BOC__c>` | List of active Client_boc\_\_c |

#### Example

```apex
List<client_boc__c> coList = L4LController.getClientBOCForSession(sessionId)
```

### `public static List<Client_Objective__c> getClientObjectivesForSession(String searchKey)`

`AURAENABLED`

Returns a list of ACTIVE Client Objectives for a sesssion ordered by Program Name TODO fix parameter name

#### Parameters

| Param       | Description    |
| ----------- | -------------- |
| `searchKey` | The session Id |

#### Returns

| Type                        | Description               |
| --------------------------- | ------------------------- |
| `List<Client_Objective__c>` | List of Client Objectives |

#### Example

```apex
List<client_objective__c> coList = L4LController.getClientObjectivesForSession(sessionId)
```

### `public static List<Client_Objective__c> getClientObjectives(String clientId)`

`AURAENABLED`

Returns a list of Client Objectives for a client, ordered by Program Name, Name TODO fix parameter name

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client Id |

#### Returns

| Type                        | Description               |
| --------------------------- | ------------------------- |
| `List<Client_Objective__c>` | List of Client Objectives |

#### Example

```apex
List<client_objective__c> coList = L4LController.getClientObjectives(clientId)
```

### `public static List<Client_Objective__c> getClientObjectivesFilteredOnActive(String clientId, boolean showActiveOnly)`

`AURAENABLED`

Returns a list of all, or active only Client Objectives for a client, ordered by Program Name, Name

#### Parameters

| Param            | Description                                                 |
| ---------------- | ----------------------------------------------------------- |
| `clientId`       | The client Id                                               |
| `showActiveOnly` | Flag to indicate whether to show the ACTIVE objectives only |

#### Returns

| Type                        | Description               |
| --------------------------- | ------------------------- |
| `List<Client_Objective__c>` | list of Client Objectives |

#### Example

```apex
List<client_objective__c> coList = L4LController.getClientObjectivesFilteredOnActive(clientId,true)
```

### `public static List<Client_BOC__c> getClientBOCFilteredOnActive(String clientId, boolean showActiveOnly)`

`AURAENABLED`

Returns a list of all, or active only Client BOC for a client

#### Parameters

| Param            | Description                                                 |
| ---------------- | ----------------------------------------------------------- |
| `clientId`       | The client Id                                               |
| `showActiveOnly` | Flag to indicate whether to show the ACTIVE objectives only |

#### Returns

| Type                  | Description        |
| --------------------- | ------------------ |
| `List<Client_BOC__c>` | list of Client_BOC |

#### Example

```apex
List<client_boc__c> cbocList = L4LController.getClientBOCFilteredOnActive(clientId,true)
```

### `public static String getCOActivationSummary(String clientId)`

`AURAENABLED`

Returns a JSON string summarising ACTIVE, INACTIVE and TOTAL Client Objectives for a client

#### Parameters

| Param      | Description   |
| ---------- | ------------- |
| `clientId` | The client Id |

#### Returns

| Type     | Description                     |
| -------- | ------------------------------- |
| `String` | JSON string summary of statuses |

#### Example

```apex
String aggStr = L4LController.getCOActivationSummary(clientId)
aggStr contains JSON string: {"active":20, "inactive":5,"total",25}
```

### `public static Client_Objective__c deactivateClientObjective(String clientObjectiveId)`

`AURAENABLED`

Deactivates a Client Objective

#### Parameters

| Param               | Description             |
| ------------------- | ----------------------- |
| `clientObjectiveId` | The Client Objective Id |

#### Returns

| Type                  | Description                      |
| --------------------- | -------------------------------- |
| `Client_Objective__c` | The deactivated client objective |

#### Example

```apex
List<client_objective__c> coList = L4LController.deactivateClientObjective(clientObjectiveId)
```

### `public static List<Objective__c> getUnusedObjectives(String clientId)`

`AURAENABLED`

Returns a list of all active objectives not yet assigned to a client

#### Parameters

| Param      | Description             |
| ---------- | ----------------------- |
| `clientId` | The Client Objective Id |

#### Returns

| Type                 | Description                                      |
| -------------------- | ------------------------------------------------ |
| `List<Objective__c>` | List of client objectives not assigned to client |

#### Example

```apex
List<objective__c> coList = L4LController.getUnusedObjectives(clientObjectiveId)
```

### `public static List<Behaviour_of_Concern__c> getUnusedBOC(String clientId)`

`AURAENABLED`

Returns a list of all active objectives not yet assigned to a client

#### Parameters

| Param      | Description             |
| ---------- | ----------------------- |
| `clientId` | The Client Objective Id |

#### Returns

| Type                            | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| `List<Behaviour_of_Concern__c>` | List of client objectives not assigned to client |

#### Example

```apex
List<objective__c> coList = L4LController.getUnusedBOC(clientId)
```

### `public static List<Objective__c> getUnusedObjectivesBySearch(String clientId, String searchstring)`

`AURAENABLED`

Returns a list of all active objectives not yet assigned to this client that have a Name like %searchString%

#### Parameters

| Param          | Description                    |
| -------------- | ------------------------------ |
| `clientId`     | The Client Objective Id        |
| `searchstring` | The search string for the name |

#### Returns

| Type                 | Description                                      |
| -------------------- | ------------------------------------------------ |
| `List<Objective__c>` | list of client objectives not assigned to client |

#### Example

```apex
List<objective__c> coList = L4LController.getUnusedObjectivesBySearch(clientId,'Banana')
```

### `public static List<Behaviour_of_Concern__c> getUnusedBOCBySearch(String clientId, String searchstring)`

`AURAENABLED`

Returns a list of all active objectives not yet assigned to this client that have a Name like %searchString%

#### Parameters

| Param          | Description                    |
| -------------- | ------------------------------ |
| `clientId`     | The Client Objective Id        |
| `searchstring` | The search string for the name |

#### Returns

| Type                            | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| `List<Behaviour_of_Concern__c>` | list of client objectives not assigned to client |

#### Example

```apex
List<objective__c> coList = L4LController.getUnusedBOCBySearch(clientId,'Banana')
```

### `public static void deleteSessionObjectives(String sessionid)`

`AURAENABLED`

Delete all session objectives for the session that have a Name like %searchString%

#### Parameters

| Param       | Description    |
| ----------- | -------------- |
| `sessionid` | The Session Id |

#### Returns

| Type   | Description |
| ------ | ----------- |
| `void` | void        |

#### Example

```apex
L4LController.deleteSessionObjectives(sessionid)
```

### `public static List<Session_Obj__c> createSessionObjectivesByArrayWithOrderedResults(String jsonstr, String sess, String skillstring)`

`AURAENABLED`

For a given session, for each client objective in a list create session objectives from its list of DTD scores

#### Parameters

| Param         | Description                                          |
| ------------- | ---------------------------------------------------- |
| `jsonstr`     | A JSON string containing a list of client objectives |
| `sess`        | The session Id                                       |
| `skillstring` | A JSON string containing a list of DTD scores        |

#### Returns

| Type                   | Description                            |
| ---------------------- | -------------------------------------- |
| `List<Session_Obj__c>` | the number of session objectives added |

#### Example

```apex
Integer noOfCreatedSessionObjs = L4LController.createSessionObjectivesByArrayWithOrderedResults(jsonStr,sess,skillstring)
```

### `public static List<Session_BOC__c> createSessionBOCByArrayWithOrderedResults(String jsonstr, String sess, String skillstring)`

`AURAENABLED`

For a given session, for each client objective in a list create session objectives from its list of DTD scores

#### Parameters

| Param         | Description                                          |
| ------------- | ---------------------------------------------------- |
| `jsonstr`     | A JSON string containing a list of client objectives |
| `sess`        | The session Id                                       |
| `skillstring` | A JSON string containing a list of DTD scores        |

#### Returns

| Type                   | Description                            |
| ---------------------- | -------------------------------------- |
| `List<Session_BOC__c>` | the number of session objectives added |

#### Example

```apex
Integer noOfCreatedSessionObjs = L4LController.createSessionBOCByArrayWithOrderedResults(jsonStr,sess,skillstring)
```

### `public static Integer createClientBOCByArray(String jsonstr, String clientId)`

`AURAENABLED`

Create client BOC from a JSON list of boc

#### Parameters

| Param      | Description                                   |
| ---------- | --------------------------------------------- |
| `jsonstr`  | A JSON string containing a list of objectives |
| `clientId` | The Client Id                                 |

#### Returns

| Type      | Description                    |
| --------- | ------------------------------ |
| `Integer` | The number of client BOC added |

#### Example

```apex
Integer noOfCreatedClientBOCs = L4LController.createClientBOCByArray(jsonStr,sess)
```

### `public static Integer createClientObjectivesByArray(String jsonstr, String sess)`

`AURAENABLED`

Create client objectives from a JSON list of objectives

#### Parameters

| Param     | Description                                   |
| --------- | --------------------------------------------- |
| `jsonstr` | A JSON string containing a list of objectives |
| `sess`    | The session Id                                |

#### Returns

| Type      | Description                           |
| --------- | ------------------------------------- |
| `Integer` | The number of client objectives added |

#### Example

```apex
Integer noOfCreatedClientObjs = L4LController.createClientObjectivesByArray(jsonStr,sess)
```

### `public static Integer setSessionObjectivesByArray(String jsonstr, String val)`

`AURAENABLED`

Update session objective scores from a JSON list

#### Parameters

| Param     | Description                                                     |
| --------- | --------------------------------------------------------------- |
| `jsonstr` | A JSON string containing a list of session objectives to update |
| `val`     | The score - "Correct" or "Incorrect" ...etc                     |

#### Returns

| Type      | Description                              |
| --------- | ---------------------------------------- |
| `Integer` | The number of session objectives updated |

#### Example

```apex
Integer noOfSessionObjsUpdated = L4LController.setSessionObjectivesByArray(jsonStr,'Correct')
```

### `public static Integer createSessionBOC(String clientBOCId, String sessionId, String intensity, Decimal mins, Decimal occurrences, String sboctime, String comments)`

`AURAENABLED`

Simple minded create a Session BOC -- for testing clone idea

#### Parameters

| Param         | Description                         |
| ------------- | ----------------------------------- |
| `clientBOCId` | the clientBOC recordId              |
| `sessionId`   | the sessionId                       |
| `intensity`   | intensity 1-5                       |
| `mins`        | no of minutes recorded for this BOC |
| `occurrences` | the no of minutes                   |
| `comments`    | comments for the clientBOC          |

#### Returns

| Type      | Description                           |
| --------- | ------------------------------------- |
| `Integer` | The number of session BOC created (1) |

#### Example

```apex
Integer i = L4LController.createSessionBOC(...)
```

### `public static Integer setSessionBOCByArray(String jsonstr, String val)`

`AURAENABLED`

Update session objective scores from a JSON list

#### Parameters

| Param     | Description                                                     |
| --------- | --------------------------------------------------------------- |
| `jsonstr` | A JSON string containing a list of session objectives to update |
| `val`     | The score - "Correct" or "Incorrect" ...etc                     |

#### Returns

| Type      | Description                              |
| --------- | ---------------------------------------- |
| `Integer` | The number of session objectives updated |

#### Example

```apex
Integer noOfSessionObjsUpdated = L4LController.setSessionBOCByArray(jsonStr,'Correct')
```

### `public static Integer setClientObjectivesByArray(String jsonstr, String val)`

`AURAENABLED`

For a list of client objectives, update to a common status or activate/deactivate

#### Parameters

| Param     | Description                                                               |
| --------- | ------------------------------------------------------------------------- |
| `jsonstr` | A JSON string containing a list of client objectives to update            |
| `val`     | "ACQ" or "OBJ" or "WEEKLY" or "FORTNIGHTLY" or "Activate" or "Deactivate" |

#### Returns

| Type      | Description                             |
| --------- | --------------------------------------- |
| `Integer` | The number of client objectives updated |

#### Example

```apex
Integer noOfClientObjsUpdated = L4LController.setClientObjectivesByArray(jsonStr,'ACQ')
Integer noOfClientObjsActivated = L4LController.setClientObjectivesByArray(jsonStr,'Activate')
```

### `public static String updateSessionObjectiveWithLG(String sessObjId)`

`AURAENABLED`

Updates Session Objective comment to "LG"

#### Parameters

| Param       | Description          |
| ----------- | -------------------- |
| `sessObjId` | Session Objective id |

#### Returns

| Type     | Description                            |
| -------- | -------------------------------------- |
| `String` | Summary of change to Session Objective |

#### Example

```apex
String str = L4LController.updateSessionObjectiveWithLG(sessObjId)
```

### `public static String updateSessionObjectiveWithComment(String sessObjId, String comment)`

`AURAENABLED`

Updates Session Objective comment

#### Parameters

| Param       | Description          |
| ----------- | -------------------- |
| `sessObjId` | Session Objective id |
| `comment`   | comment              |

#### Returns

| Type     | Description                            |
| -------- | -------------------------------------- |
| `String` | Summary of change to Session Objective |

#### Example

```apex
String str = L4LController.updateSessionObjectiveWithComment(sessObjId,comment)
```

---

## Classes

### SessionResult

Helper.

**Author** Mike Burnside

**Name** SessionResult

**Date** 2022

**Group** Learning For Life

#### Properties

##### `public skill` → `String`

getter/setter

---

---
