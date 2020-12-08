declare module "@salesforce/apex/MBSessionObjectives.getSessionObjectives" {
  export default function getSessionObjectives(param: {sess: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.getClientObjectivesForSession" {
  export default function getClientObjectivesForSession(param: {searchKey: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.getClientObjectives" {
  export default function getClientObjectives(param: {searchKey: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.getObjectives" {
  export default function getObjectives(param: {sess: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.getUnusedObjectives" {
  export default function getUnusedObjectives(param: {sess: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.deleteSessionObjectives" {
  export default function deleteSessionObjectives(param: {sessionid: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.createSessionObjectives" {
  export default function createSessionObjectives(param: {sessionid: any, objective: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.setSessionObjectives" {
  export default function setSessionObjectives(param: {key: any, val: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.createSessionObjectivesByArrayOld" {
  export default function createSessionObjectivesByArrayOld(param: {jsonstr: any, sess: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.createSessionObjectivesByArray" {
  export default function createSessionObjectivesByArray(param: {jsonstr: any, sess: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.createClientObjectivesByArray" {
  export default function createClientObjectivesByArray(param: {jsonstr: any, sess: any}): Promise<any>;
}
declare module "@salesforce/apex/MBSessionObjectives.setSessionObjectivesByArray" {
  export default function setSessionObjectivesByArray(param: {jsonstr: any, val: any}): Promise<any>;
}
