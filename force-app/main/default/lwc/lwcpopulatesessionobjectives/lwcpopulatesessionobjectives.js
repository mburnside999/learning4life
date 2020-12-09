/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
import { LightningElement,api,wire,track} from 'lwc';
import getClientObjectivesForSession from '@salesforce/apex/MBSessionObjectives.getClientObjectivesForSession';
import createSessionObjectivesByArray from '@salesforce/apex/MBSessionObjectives.createSessionObjectivesByArray';
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

export default class Lwcpopulatsessionobjectives extends LightningElement {
    @wire(CurrentPageReference) pageRef;
    @api recordId = 'a3N2v000003Gr4VEAS'; //session 31 for testing
    @track allObjectives = {};
    //@wire(getObjectives, { sess: '$recordId' }) objectives;
    @track error;
    @track columns = columns;
    @track recordsProcessed = 0;
    @track objectives;

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
        let myselectedRows = event.detail.selectedRows;
        this.selectedRows = myselectedRows;
    }

    handleClickArray(event) {
        if (this.selectedRows) {
            console.log('logging JSON: ' + JSON.stringify(this.selectedRows));
            console.log('loging session: ' + this.recordId);
            console.log('Commencing imperative Call to createSessionObjectivesByArray(sessionid, jsonstr) ');
            createSessionObjectivesByArray({
                    jsonstr: JSON.stringify(this.selectedRows),
                    sess: this.recordId,

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