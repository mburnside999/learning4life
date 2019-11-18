/* eslint-disable no-console */
import { LightningElement,api,wire,track } from 'lwc';
import getSessionObjectives from '@salesforce/apex/MBSessionObjectives.getSessionObjectives';
import setSessionObjectives from '@salesforce/apex/MBSessionObjectives.setSessionObjectives';
import setSessionObjectivesByArray from '@salesforce/apex/MBSessionObjectives.setSessionObjectivesByArray';

import deleteSessionObjectives from '@salesforce/apex/MBSessionObjectives.deleteSessionObjectives';

import { refreshApex } from '@salesforce/apex';

const columns = [
    {label: 'Name', fieldName: 'Name', type: 'text'},      
    {label: 'Objective', fieldName: 'Objective_Name__c', type:'text'}, 
    {label: 'SD', fieldName: 'SD__c', type:'text'},
    {label: 'Correct', fieldName: 'Correct__c',type:'boolean'}, 
    {label: 'Incorrect', fieldName: 'Incorrect__c',type:'boolean'}, 
    {label: 'Prompted', fieldName: 'Prompted__c',type:'boolean'}, 
   
];
const selectedRows = {};



export default class Lwcsessionobjective extends LightningElement {

@api recordId='a3N2v000003GqRzEAK';
@wire(getSessionObjectives, { sess: '$recordId' }) sessionObjectives;
@track error;
@track columns = columns;
@track recordsProcessed=0;


handleClickCorrect(event) {
  console.log('=====> sessionObjectives: '+JSON.stringify(this.sessionObjectives.data));
  console.log('ZZZZZZZZZZZ '+event.target.label);

  if (this.selectedRows) {
    for (let i = 0; i < this.selectedRows.length; i++){
        //alert("BUTTON PRESS  You selected: " + this.selectedRows[i].Id+' '+this.selectedRows[i].Name);  
        console.log('Commencing imperative Call to setSessionObjectivesCorrect(key) ');
        setSessionObjectives({key: this.selectedRows[i].Id, val:'Correct'})
        .then(result => {
            console.log('RETURNED');
            
        })
        .then(() => {
            console.log('Refreshing');
            return refreshApex(this.sessionObjectives);
        })
        .catch(error => {
            this.error = error;
            console.log('ERRORED' +JSON.stringify(error));
        });       
    }
}
}

handleClickIncorrect(event) {
    if (this.selectedRows) {
        console.log('SELECTED ROWS = '+JSON.stringify(this.selectedRows));
    for (let i = 0; i < this.selectedRows.length; i++){
        //alert("BUTTON PRESS  You selected: " + this.selectedRows[i].Id+' '+this.selectedRows[i].Name);  
        console.log('Commencing imperative Call to setSessionObjectivesCorrect(key) ');
        setSessionObjectives({key: this.selectedRows[i].Id, val:'Incorrect'})
        .then(result => {
            console.log('RETURNED');
            
        })
        .then(() => {
            console.log('Refreshing');
            return refreshApex(this.sessionObjectives);
        })
        .catch(error => {
            this.error = error;
            console.log('ERRORED' +JSON.stringify(error));
        });       
    }
}
}

handleClickPrompted(event) {
    if (this.selectedRows) {
    for (let i = 0; i < this.selectedRows.length; i++){
        //alert("BUTTON PRESS  You selected: " + this.selectedRows[i].Id+' '+this.selectedRows[i].Name);  
        console.log('Commencing imperative Call to setSessionObjectivesCorrect(key) ');
        setSessionObjectives({key: this.selectedRows[i].Id, val:'Prompted'})
        .then(result => {
            console.log('RETURNED');
            
        })
        .then(() => {
            console.log('Refreshing');
            return refreshApex(this.sessionObjectives);
        })
        .catch(error => {
            this.error = error;
            console.log('ERRORED' +JSON.stringify(error));
        });       
    }
}
}



handleClickPromptedArray(event) {
    console.log('ZZZZZZZZZZZ '+event.target.label);
    if (this.selectedRows) {
   
        //alert("BUTTON PRESS  You selected: " + this.selectedRows[i].Id+' '+this.selectedRows[i].Name);  
        console.log('Commencing imperative Call to setSessionObjectivesCorrectByArray(key) ');
        setSessionObjectivesByArray({jsonstr: JSON.stringify(this.selectedRows), val:'Prompted'})
        .then(result => {
            console.log('RETURNED');
            this.test=result;
            console.log('xxxxxxxxxxxx '+this.test);
            
        })
        .then(() => {
            console.log('Refreshing');
            return refreshApex(this.sessionObjectives);
        })
        .catch(error => {
            this.error = error;
            console.log('ERRORED' +JSON.stringify(error));
        });       
    }
}


handleClickArray(event) {
    console.log('Received event from button '+event.target.label);
    let mode='';
    let label=event.target.label;

    switch(label) {
        case 'Mark Correct':
          mode='Correct';
          break;
        case 'Mark Incorrect':
            mode='Incorrect';
          break;
          case 'Mark Prompted':
            mode='Prompted';
          break;
          case 'Experimental':
            mode='Correct';
          break;
        default:
          // code block
      }
    
    if (this.selectedRows) {
   
        //alert("BUTTON PRESS  You selected: " + this.selectedRows[i].Id+' '+this.selectedRows[i].Name);  
        console.log('Commencing imperative Call to setSessionObjectivesCorrectByArray(key) ');
        setSessionObjectivesByArray({jsonstr: JSON.stringify(this.selectedRows), val:mode})
        .then(result => {
            console.log('RETURNED');
            this.recordsProcessed=result;
            console.log(this.recordsProcessed + 'records processed.');
            
        })
        .then(() => {
            console.log('Refreshing');
            return refreshApex(this.sessionObjectives);
        })
        .catch(error => {
            this.error = error;
            console.log('ERRORED' +JSON.stringify(error));
        });       
    }
}

handleClickDelete(event) {
   
    
    console.log('Commencing imperative Call to deleteSessionObjectives(session) ');
    deleteSessionObjectives({sessionid: this.recordId})
    .then(result => {
        console.log('RETURNED');
        
    })
    .then(() => {
        console.log('Refreshing');
        return refreshApex(this.sessionObjectives);
    })
    .catch(error => {
        this.error = error;
        console.log('ERRORED' +JSON.stringify(error));
    });       


}
getSelectedName(event) {
    let myselectedRows=event.detail.selectedRows;
    this.selectedRows=myselectedRows;
    // Display that fieldName of the selected rows
    //for (let i = 0; i < selectedRows.length; i++){
        //alert("You selected: " + selectedRows[i].Name);
    //}
}

}