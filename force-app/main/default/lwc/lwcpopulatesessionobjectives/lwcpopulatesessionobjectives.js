/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement,api,wire,track } from 'lwc';
import getClientObjectivesForSession from '@salesforce/apex/MBSessionObjectives.getClientObjectivesForSession';
import createSessionObjectivesByArray from '@salesforce/apex/MBSessionObjectives.createSessionObjectivesByArray';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { fireEvent } from 'c/pubsub';
import {CurrentPageReference} from 'lightning/navigation';

import { refreshApex } from '@salesforce/apex';

const columns = [
    {label: 'Program', fieldName: 'Program_Name__c', type: 'text'},   
    {label: 'SD Name', fieldName: 'SD_Name__c', type: 'text'}, 
    {label: 'Objective', fieldName: 'Objective_Name__c', type: 'text'}, 
    {label: 'Status', fieldName: 'Status__c', type: 'text'}, 
    {label: 'Days', fieldName: 'Days_Since_Tested_Correct__c', type: 'number'},  
    {label: 'Retest Due', fieldName: 'Re_Test_Recommended__c', type: 'boolean'},  
 
];


const selectedRows = {};

export default class Lwcpopulatsessionobjectives extends LightningElement {
@wire(CurrentPageReference) pageRef;
@api recordId='a3N2v000003GqRzEAK';
@track allObjectives ={};
//@wire(getObjectives, { sess: '$recordId' }) objectives;
@track error;
@track columns = columns;
@track recordsProcessed=0;
@track objectives;

connectedCallback() {
    
   console.log('in connetedCallback calling refresh()');
   this.refresh();

}

refresh() {

    console.log('in refactored refresh()');
    getClientObjectivesForSession({ searchKey: this.recordId })
    .then(result => {
        console.log('RETURNED');
        this.objectives=result;
        this.allObjectives=result;
        console.log(JSON.stringify(this.objectives));

    })
    .catch(error => {
        this.error = error;
        console.log('ERROR' +JSON.stringify(error));
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

/* DEPRECATED
handleClickCreate(event) {
      if (this.selectedRows) {
      for (let i = 0; i < this.selectedRows.length; i++){
          //alert("BUTTON PRESS  You selected: " + this.selectedRows[i].Id+' '+this.selectedRows[i].Name);  
          console.log('Commencing imperative Call to createSessionObjectives(sessionid, objective) ');
          createSessionObjectives({sessionid: this.recordId, objective: this.selectedRows[i].Id})
          .then(result => {
              console.log('RETURNED');
              
          })
          .then(() => {
              console.log('Refreshing');
              return refreshApex(this.objectives);
          })
          .catch(error => {
              this.error = error;
              console.log('ERRORED' +JSON.stringify(error));
          });       
      }
  }
}
*/
  handleClickArray(event) {
    if (this.selectedRows) {
        console.log('logging JSON: '+JSON.stringify(this.selectedRows)) ;
        console.log('loging session: '+this.recordId);
        console.log('Commencing imperative Call to createSessionObjectivesByArray(sessionid, jsonstr) ');
        createSessionObjectivesByArray({jsonstr: JSON.stringify(this.selectedRows), sess: this.recordId})
        .then(result => {
            console.log('RETURNED');
            this.recordsProcessed=result;
            console.log(this.recordsProcessed + 'records processed.');

        })
        .then(() => {
            console.log('Refreshing');
           
        })
        .then(() => {
            this.showNotification('Success',this.recordsProcessed+ ' records processed.','success');
        }) 
        .finally(() => {
            console.log('firing event to notify listeners that the sesion objectives have been saved');
            fireEvent(this.pageRef, 'inputChangeEvent', this.recordId);  
        }) 
        .catch(error => {
            this.error = error;
            console.log('ERRORED' +JSON.stringify(error));
        });       
    }
}

/*  DEPRECATED
handleClickArrayOld(event) {
    if (this.selectedRows) {
        console.log('logging JSON: '+JSON.stringify(this.selectedRows)) ;
        console.log('loging session: '+this.recordId);
        console.log('Commencing imperative Call to createSessionObjectivesByArray(sessionid, jsonstr) ');
        createSessionObjectivesByArray({jsonstr: JSON.stringify(this.selectedRows), sess: this.recordId})
        .then(result => {
            console.log('RETURNED');
            this.recordsProcessed=result;
            console.log(this.recordsProcessed + 'records processed.');

        })
        .then(() => {
            console.log('Refreshing');
           
        })
        .then(() => {
            this.showNotification('Success',this.recordsProcessed+ ' records processed.','success');
            

        }) 
        .catch(error => {
            this.error = error;
            console.log('ERRORED' +JSON.stringify(error));
        });       
    }
}
*/



handleSearchKeyInput(event) {
    const searchKey = event.target.value.toLowerCase();
   this.objectives = this.allObjectives.filter(
      so => so.Program_Name__c.toLowerCase().includes(searchKey) ||so.SD_Name__c.toLowerCase().includes(searchKey)||so.Objective_Name__c.toLowerCase().includes(searchKey)
    );
  }



  showNotification(t,m,v) {
    console.log('Toast...');

    const evt = new ShowToastEvent({
        title: t,
        message: m,
        variant: v,
    });
    this.dispatchEvent(evt);
}
  

  handleClickCancel(event) {
    console.log('Cancelled'); 
  }

}