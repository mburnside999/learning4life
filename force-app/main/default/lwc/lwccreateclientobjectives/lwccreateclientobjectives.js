/* eslint-disable no-unused-vars */
/* eslint-disable no-console */

import { LightningElement,api,wire,track } from 'lwc';
import getUnusedObjectives from '@salesforce/apex/MBSessionObjectives.getUnusedObjectives';
import createClientObjectivesByArray from '@salesforce/apex/MBSessionObjectives.createClientObjectivesByArray';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { fireEvent } from 'c/pubsub';
import {CurrentPageReference} from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';

const columns = [
    {label: 'Name', fieldName: 'Name', type: 'text'},  
    {label: 'Program', fieldName: 'Program__c', type: 'text'},   
    {label: 'SD_Name__c', fieldName: 'SD_Name__c', type: 'text'},  
];


const selectedRows = {};

export default class Lwccreateclientobjectives extends LightningElement {

//@api recordId='a3N2v000003Gr33EAC';
@api recordId='0012v00002fY86nAAC'; //Andy

@wire(CurrentPageReference) pageRef;
@track allObjectives ={};
@wire(getUnusedObjectives, { sess: '$recordId' }) objectives;
@track error;
@track columns = columns;
@track recordsProcessed=0;
@track objectives;

connectedCallback() {
    
      console.log('starting, getting objectives, recordId = '+this.recordId);
    this.refresh();

}

refresh() {
console.log('IN REFRESH');
    getUnusedObjectives({ sess: this.recordId })
    .then(result => {
        console.log('REFRESH RETURNED');
        this.objectives=result;
        this.allObjectives=result;
        console.log(JSON.stringify(this.objectives));

    })
    .catch(error => {
        this.error = error;
        console.log('REFRESH ERROR' +JSON.stringify(error));
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


  handleClickArray(event) {
    if (this.selectedRows) {
        console.log('logging JSON: '+JSON.stringify(this.selectedRows)) ;
        console.log('loging session: '+this.recordId);
        console.log('Commencing imperative Call to getClientObejctivesForSession(sessionid) ');
        createClientObjectivesByArray({jsonstr: JSON.stringify(this.selectedRows), sess: this.recordId})
        .then(result => {
            console.log('RETURNED');
            this.recordsProcessed=result;
            console.log(this.recordsProcessed + 'records processed.');

        })
        .then(() => {
               
           
        })
        .then(() => {
            this.showNotification('Success',this.recordsProcessed+ ' records processed.','success');
            

        }) 
        .finally(() => {
            console.log('FINALLY');
            
            console.log('firing input change event');
            fireEvent(this.pageRef, 'inputChangeEvent', this.recordId);
        })
        .catch(error => {
            this.error = error;
            console.log('ERRORED' +JSON.stringify(error));
        });       
    }
}


handleSearchKeyInput(event) {
    const searchKey = event.target.value.toLowerCase();
    this.objectives = this.allObjectives.filter(
      so => so.Name.toLowerCase().includes(searchKey) || so.Program__c.toLowerCase().includes(searchKey) ||so.SD_Name__c.toLowerCase().includes(searchKey)
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