/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
/*eslint no-console: ["error", { allow: ["warn", "error"] }] */
import { LightningElement, track, wire, api } from 'lwc';
import getClientObjectives from '@salesforce/apex/MBSessionObjectives.getClientObjectives';
import { CurrentPageReference} from 'lightning/navigation';
import { registerListener, unregisterAllListeners, fireEvent } from 'c/pubsub';

const columns = [
    {label: 'Name', fieldName: 'Name', type: 'text'}, 
    {label: 'Objective', fieldName: 'Objective_Name__c', type: 'text'}, 
    {label: 'Program', fieldName: 'Program_Name__c', type: 'text'},    
    {label: 'SD', fieldName: 'SD_Name__c', type: 'text'},    
    {label: 'Status', fieldName: 'Status__c', type: 'text'},    
];


export default class lwcrelatedclientobjectives extends LightningElement {
    @track searchKey = '';
    @api recordId='0012v00002fY86nAAC';
    @track columns = columns;
    @track clientobjectives;
    allObjectives ={};
    @wire(CurrentPageReference) pageRef;

    
   //@wire(getClientObjectives, { searchKey: '$recordId' }) clientobjectives;

    connectedCallback() {
        console.log('subscribing to pub sub inputChangeEvent');
        registerListener('inputChangeEvent', this.handleChange, this);
        console.log('starting, getting client objectives, recordId = '+this.recordId);
    this.refresh();
  
  }

  refresh() {

console.log('in refactored this.refresh()');
    console.log('starting, getting client objectives, recordId = '+this.recordId);
    getClientObjectives({ searchKey: this.recordId })
        .then(result => {
            console.log('RETURNED');
            this.clientobjectives=result;
            this.allObjectives=result;
            console.log(JSON.stringify(this.clientobjectives));

        })
        .catch(error => {
            this.error = error;
            console.log('ERROR' +JSON.stringify(error));
        });    



  }

  handleClick(event) {
    //this.clientobjectives={};
    this.refresh();

    
}

disconnectedCallback() {
    // unsubscribe from inputChangeEvent event
    unregisterAllListeners(this);
  }

handleChange(inpVal) {
    console.log('received pub sub input event');
    getClientObjectives({ searchKey: this.recordId })
          .then(result => {
              console.log('RETURNED in handle change()');
              this.clientobjectives=result;
              this.allObjectives=result;
              console.log(JSON.stringify(this.clientobjectives));
  
          })
          .catch(error => {
              this.error = error;
              console.log('ERROR' +JSON.stringify(error));
          });  
  } 

handleSearchKeyInput(event) {
    
    const searchKey = event.target.value.toLowerCase();
    console.log('SEARCHKEY='+searchKey+'. this.allObjectives= '+JSON.stringify(this.allObjectives));
    
    
    this.clientobjectives = this.allObjectives.filter(
      so => so.Name.toLowerCase().includes(searchKey) || so.SD_Name__c.toLowerCase().includes(searchKey) ||so.Program_Name__c.toLowerCase().includes(searchKey)||so.Objective_Name__c.toLowerCase().includes(searchKey)
    );
 
    console.log('this.clientobjectives='+JSON.stringify(this.clientobjectives));
  }



}