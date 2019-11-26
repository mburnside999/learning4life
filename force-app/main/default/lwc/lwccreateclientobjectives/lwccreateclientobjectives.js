import { LightningElement,api,wire,track } from 'lwc';
import getObjectives from '@salesforce/apex/MBSessionObjectives.getObjectives';
import createClientObjectivesByArray from '@salesforce/apex/MBSessionObjectives.createClientObjectivesByArray';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';


import { refreshApex } from '@salesforce/apex';

const columns = [
    {label: 'Name', fieldName: 'Name', type: 'text'},  
    {label: 'Program', fieldName: 'Program__c', type: 'text'},   
    {label: 'SD Name', fieldName: 'SD_Name__c', type: 'text'},  
];
const selectedRows = {};

export default class Lwccreateclientobjectives extends LightningElement {

//@api recordId='a3N2v000003GqRzEAK';
@api recordId='0012v00002fY86nAAC'; 


@track allObjectives ={};
//@wire(getObjectives, { sess: '$recordId' }) objectives;
@track error;
@track columns = columns;
@track recordsProcessed=0;
@track objectives;

connectedCallback() {
    
      console.log('starting');
    getObjectives({ sess: '$recordId' })
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
  handleClickArray(event) {
    if (this.selectedRows) {
        console.log('logging JSON: '+JSON.stringify(this.selectedRows)) ;
        console.log('loging session: '+this.recordId);
        console.log('Commencing imperative Call to createClientObjectivesByArray(sessionid, jsonstr) ');
        createClientObjectivesByArray({jsonstr: JSON.stringify(this.selectedRows), sess: this.recordId})
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
            console.log('attempting to refresh client record');

            updateRecord({ fields: { Id: this.recordId } });

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