/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement,api,wire,track} from 'lwc';
import getClientObjectivesForSession from '@salesforce/apex/MBSessionObjectives.getClientObjectivesForSession';
import createSessionObjectivesByArrayWithResults from '@salesforce/apex/MBSessionObjectives.createSessionObjectivesByArrayWithResults';
import { ShowToastEvent} from 'lightning/platformShowToastEvent';
import {fireEvent} from 'c/pubsub';
import {CurrentPageReference} from 'lightning/navigation';

const columns = [{
        label: 'Prog',
        fieldName: 'Program_Name__c',
        type: 'text'
    },
    {
        label: 'SD',
        fieldName: 'SD_Name__c',
        type: 'text'
    },
    {
        label: 'Obj',
        fieldName: 'Objective_Name__c',
        type: 'text'
    },
    {
        label: 'Status',
        fieldName: 'Status__c',
        type: 'text'
    },   
    {
        label: 'Re-Test Due',
        fieldName: 'Re_Test_Recommended__c',
        type: 'boolean'
    },

];

export default class Lwcpopulatsessionobjectivesnew extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    @api recordId = 'a3N2v000003Gr4VEAS'; //session 31 for testing
    @track allObjectives = {};
    //@wire(getObjectives, { sess: '$recordId' }) objectives;
    @track error;
    @track columns = columns;
    @track recordsProcessed = 0;
    @track objectives;
 
    @track correctCount=0;
    @track incorrectCount=0;
    @track promptedCount=0;
    @track selectCount=0;

    
    isButtonDisabled=true;


    connectedCallback() {

        console.log('in connetedCallback calling refresh()');
        this.refresh();

    }

    refresh() {

        console.log('in refactored refresh()');
        getClientObjectivesForSession({
                searchKey: this.recordId
            })
            .then(result => {
                console.log('RETURNED');
                this.objectives = result;
                this.allObjectives = result;
                console.log(JSON.stringify(this.objectives));

            })
            .catch(error => {
                this.error = error;
                console.log('ERROR' + JSON.stringify(error));
            });



    }

    getSelectedName(event) {
        console.log(JSON.stringify(event));
        let myselectedRows = event.detail.selectedRows;
        this.selectedRows = myselectedRows;
        this.selectCount=this.selectedRows.length;
        if (this.selectCount==0) this.resetCounters();
    }

    
    
    handleIncrCorrect(event){
        if (this.selectedRows) {
            this.correctCount+=1;
            isButtonDisabled=false;

        }
        console.log('correctCount '+this.correctCount);
    }

   resetCounters(event){
        this.correctCount=0;
        this.incorrectCount=0;
        this.promptedCount=0;
    }


    handleDecrCorrect(event){
        if (this.selectedRows) {
            if (this.correctCount==0) {
                this.correctCount=0;
        } else {this.correctCount -= 1}
        console.log('correctCount '+this.correctCount);
    }
}

handleIncrIncorrect(event){
    if (this.selectedRows) {
        this.incorrectCount+=1;
    }
    console.log('incorrectCount '+this.incorrectCount);
}

handleDecrIncorrect(event){
    if (this.selectedRows) {
        if (this.incorrectCount==0) {
            this.incorrectCount=0;
    } else {this.incorrectCount -= 1}
    console.log('incorrectCount '+this.incorrectCount);
}
}

handleIncrPrompted(event){
    if (this.selectedRows) {
        this.promptedCount+=1;
    }
    console.log('promptedCount: '+this.promptedCount);
}

handleDecrPrompted(event){
    if (this.selectedRows) {
        if (this.promptedCount==0) {
            this.promptedCount=0;
    } else {this.promptedCount -= 1}
    console.log('promptedCount: '+this.promptedCount);
}
}
    
get sumOfCounts(){
    //parseInt Converts a string to an integer.
        return (parseInt(this.correctCount)+parseInt(this.incorrectCount)+parseInt(this.promptedCount))*this.selectCount;
} 

get buttonDisabled(){
     return parseInt(this.correctCount)+parseInt(this.incorrectCount)+parseInt(this.promptedCount)==0;
} 

    handleClickArray(event) {
        if (this.selectedRows) {
            console.log('logging JSON: ' + JSON.stringify(this.selectedRows));
            console.log('loging session: ' + this.recordId);
            console.log('Commencing imperative Call to createSessionObjectivesByArrayWithResults(sessionid, jsonstr) ');
            console.log('correctcount='+this.correctCount);
            createSessionObjectivesByArrayWithResults({
                    jsonstr: JSON.stringify(this.selectedRows),
                    sess: this.recordId,
                    correctcount:this.correctCount,
                    incorrectcount:this.incorrectCount,
                    promptedcount:this.promptedCount
                })
                .then(result => {
                    console.log('RETURNED');
                    this.recordsProcessed = result;
                    console.log(this.recordsProcessed + 'records processed.');

                })
                .then(() => {
                    console.log('Refreshing');
                    
                    

                })
                .then(() => {
                   this.showNotification('Success', this.recordsProcessed + ' records processed.', 'success');
                   this.objectives=[];
                   this.refresh();
                   this.resetCounters(null);
                   this.selectCount=0;
                    

                    
                })
                .finally(() => {
                    console.log('firing event to notify listeners that the sesion objectives have been saved');
                    fireEvent(this.pageRef, 'inputChangeEvent', this.recordId);
                    
                })
                .catch(error => {
                    this.error = error;
                    console.log('ERRORED' + JSON.stringify(error));
                });
        }
    }

    handleSearchKeyInput(event) {
        const searchKey = event.target.value.toLowerCase();
        this.objectives = this.allObjectives.filter(
            so => so.Program_Name__c.toLowerCase().includes(searchKey) || so.SD_Name__c.toLowerCase().includes(searchKey) || so.Objective_Name__c.toLowerCase().includes(searchKey)
        );
    }


    showNotification(t, m, v) {
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