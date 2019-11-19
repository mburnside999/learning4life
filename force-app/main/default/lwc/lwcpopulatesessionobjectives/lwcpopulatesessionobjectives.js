/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement,api,wire,track } from 'lwc';
import getObjectives from '@salesforce/apex/MBSessionObjectives.getObjectives';
import createSessionObjectives from '@salesforce/apex/MBSessionObjectives.createSessionObjectives';

import { refreshApex } from '@salesforce/apex';

const columns = [
    {label: 'Name', fieldName: 'Name', type: 'text'},  
    {label: 'Program', fieldName: 'Program__c', type: 'text'},   
    {label: 'SD Name', fieldName: 'SD_Name__c', type: 'text'},  
];
const selectedRows = {};

export default class Lwcpopulatesessionobjectives extends LightningElement {

@api recordId='a3N2v000003GqRzEAK';

@wire(getObjectives, { sess: '$recordId' }) objectives;

@track error;
@track columns = columns;

getSelectedName(event) {
    let myselectedRows=event.detail.selectedRows;
    this.selectedRows=myselectedRows;
    // Display that fieldName of the selected rows
    //for (let i = 0; i < selectedRows.length; i++){
        //alert("You selected: " + selectedRows[i].Name);
    //}
}

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


  

  handleClickCancel(event) {
    console.log('Cancelled'); 
  }

}