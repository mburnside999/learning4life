/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement,api,wire,track } from 'lwc';
import getSessionObjectives from '@salesforce/apex/MBSessionObjectives.getSessionObjectives';
import setSessionObjectivesByArray from '@salesforce/apex/MBSessionObjectives.setSessionObjectivesByArray';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteSessionObjectives from '@salesforce/apex/MBSessionObjectives.deleteSessionObjectives';

import { refreshApex } from '@salesforce/apex';

const columns = [
    {label: 'Name', fieldName: 'Name', type: 'text'},      
    {label: 'Program', fieldName: 'Program__c', type:'text'},
    {label: 'Objective', fieldName: 'Objective_Name__c', type:'text'}, 
    {label: 'SD', fieldName: 'SD__c', type:'text'},
    {label: 'Correct', fieldName: 'Correct__c',type:'boolean'}, 
    {label: 'Incorrect', fieldName: 'Incorrect__c',type:'boolean'}, 
    {label: 'Prompted', fieldName: 'Prompted__c',type:'boolean'}, 
   
];
const selectedRows = {};

export default class Lwcsessionobjective extends LightningElement {

@track allObjectives ={};
@api recordId='a3N2v000003GqRzEAK';
@wire(getSessionObjectives, { sess: '$recordId' }) sessionObjectives;
@track error;
@track columns = columns;
@track recordsProcessed=0;
@track sessionObjectives;

handleSearchKeyInput(event) {
    const searchKey = event.target.value.toLowerCase();
    this.sessionObjectives = this.allObjectives.filter(
      so => so.Name.toLowerCase().includes(searchKey) 
    );
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
          case 'Delete':
            mode='Delete';
          break;
        default:
          // code block
      }
    
    if (this.selectedRows) {
        
        console.log('Commencing imperative Call to setSessionObjectivesCorrectByArray(key) ');
        console.log('mode='+mode);
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
        .then (() => {
           
           this.showNotification('Success!','Marked '+this.recordsProcessed+ ' records as '+mode+'.','success');
            
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
    .then(() => {
        console.log('Toasty');
        this.showNotification('Success!','Deleted all Session Objective records for this session.','success');
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

showNotification(t,m,v) {
    console.log('Toast...');

    const evt = new ShowToastEvent({
        title: t,
        message: m,
        variant: v,
    });
    this.dispatchEvent(evt);
}

}