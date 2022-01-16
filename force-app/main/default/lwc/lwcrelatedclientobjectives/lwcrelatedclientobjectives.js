/* eslint-disable no-unused-vars */
/* eslint-disable no-console */
/*eslint no-console: ["error", { allow: ["warn", "error"] }] */
import { LightningElement,track,wire,api} from 'lwc';
import getClientObjectives from '@salesforce/apex/MBSessionObjectives.getClientObjectives';
import { CurrentPageReference} from 'lightning/navigation';
import {registerListener,unregisterAllListeners,fireEvent} from 'c/pubsub';
import { updateRecord} from 'lightning/uiRecordApi';
import {deleteRecord} from 'lightning/uiRecordApi';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

const COLOUR="color:magenta";
const actions = [{
        label: 'Edit details',
        name: 'edit_details'
    },
    {
        label: 'Delete',
        name: 'delete'
    },
];

const columns = [{
        label: 'Program',
        fieldName: 'Program_Name__c',
        type: 'text'
    },
    {
        label: 'SD',
        fieldName: 'SD_Name__c',
        type: 'text'
    },
    {
        label: 'Objective',
        fieldName: 'Objective_Name__c',
        type: 'text'
    },
    {
        label: 'Status',
        fieldName: 'Status__c',
        type: 'text'
    },
    {
        label: 'Frequency',
        fieldName: 'Frequency__c',
        type: 'text'
    },
    {
        label: 'Last Correct',
        fieldName: 'Last_Tested_Correct__c',
        type: 'date'
    },
    {
        label: 'Retest',
        fieldName: 'Re_Test_Recommended__c',
        type: 'boolean'
    },
    {
        label: 'Notes',
        fieldName: 'Client_Objective_Notes__c',
        type: 'text'
    },
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions
        },
    },
];

export default class lwcrelatedclientobjectives extends LightningElement {
    @track clientId = '';
    @api recordId = '0012v00002fY86nAAC';
    @track COrecordId = '';
    @track COobjectApiName = 'Client_Objective__c';
    @track columns = columns;
    @track clientobjectives;
    allObjectives = {};
    @wire(CurrentPageReference) pageRef;
    @track draftValues = [];
    @track areDetailsVisible = false;
    //@wire(getClientObjectives, { clientId: '$recordId' }) clientobjectives;

    connectedCallback() {
        console.log(`%cconnectedCallback(): subscribing to pub sub inputChangeEvent`,COLOUR);
        registerListener('inputChangeEvent', this.handleChange, this);
        console.debug(`%cconnectedCallback(): calling this.refresh() to get client objectives, recordId =  ${this.recordId}`,COLOUR);
        this.refresh();

    }

    handleRowAction(event) {
        console.info(`%chandleRowAction(): entering`,COLOUR);
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.debug(`%chandleRowAction(): row=${JSON.stringify(row)}`,COLOUR);
        switch (actionName) {
            case 'delete':
                console.log('DELETING');
                deleteRecord(row.Id)
                    .then(() => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: 'Cient Objective deleted',
                                variant: 'success'
                            })
                        );
                        this.refresh();
                    })
                    .catch(error => {
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error deleting record',
                                message: 'Error',
                                variant: 'error'
                            })
                        );
                    });
                break;
            case 'edit_details':
                this.COrecordId = row.Id;
                console.info(`%ccase edit_details`,COLOUR);
                console.debug(`%cthis.COrecordId= ${this.COrecordId}`,COLOUR);
                this.areDetailsVisible = true;
                break;
            default:
        }
    }

    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: "Success",
            message: "Client objective updated",
            variant: "success"
        });
        this.dispatchEvent(evt);
        this.areDetailsVisible = false;
        this.refresh();
    }

    refresh() {
        console.info(`%crefresh(): entering`,COLOUR);
        console.debug(`%crefresh(): calling getClientObjectives, recordId = ${this.recordId}`,COLOUR);
        getClientObjectives({
                clientId: this.recordId
            })
            .then(result => {
                console.debug(`%crefresh(): getClientObjectives returned ${JSON.stringify(result)}`,COLOUR);
                this.clientobjectives = result;
                this.allObjectives = result;
                console.debug(`%crefresh(): this.clientObjectives= ${JSON.stringify(this.clientobjectives)}`,COLOUR);

            })
            .catch(error => {
                this.error = error;
                console.log(`%cERROR ${JSON.stringify(error)}`,COLOUR);
            });



    }

    handleCancel(event) {
        console.log('Cancelling');
        this.areDetailsVisible = false;

    }
    handleSave(event) {
        console.debug(`handleSave(): ${JSON.stringify(event.detail.draftValues)}`,COLOUR);
        const recordInputs = event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return {
                fields
            };
        });

        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(contacts => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Client objectives updated',
                    variant: 'success'
                })
            );
            // Clear all draft values
            this.draftValues = [];

            // Display fresh data in the datatable
            console.log(`%cREFRESH is turned ON`,COLOUR);
            this.refresh();
        }).catch(error => {
            // Handle error
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
        console.info(`%chandleChange(): entering`,COLOUR);
        console.log('received pub sub input event');
        console.debug(`%chandleChange(): calling getClientObjectives, clientId=${this.recordId}`,COLOUR);

        getClientObjectives({
                clientId: this.recordId
            })
            .then(result => {
                console.debug(`%chandleChange(): returned result=${JSON.stringify(result)}`,COLOUR);
                this.clientobjectives = result;
                this.allObjectives = result;
                console.debug(`%chandleChange(): this.allObjectives=${JSON.stringify(this.allObjectives)}`,COLOR);

            })
            .catch(error => {
                this.error = error;
                console.log(`%c%chandleChange(): ERROR ${JSON.stringify(error)}`,COLOR);
            });
    }

    handleSearchKeyInput(event) {

        const searchKey = event.target.value.toLowerCase();
        console.debug(`%chandleSearchKeyInput(): searchKey= ${searchKey}. this.allObjectives= ${JSON.stringify(this.allObjectives)}`,COLOUR);
        this.clientobjectives = this.allObjectives.filter(
            so => so.Name.toLowerCase().includes(searchKey) || (so.Status__c != null && so.Status__c.toLowerCase().includes(searchKey) ) || so.SD_Name__c.toLowerCase().includes(searchKey) || so.Program_Name__c.toLowerCase().includes(searchKey) || so.Objective_Name__c.toLowerCase().includes(searchKey)
            );

        console.debug(`%chandleSearchKeyInput(): this.clientobjectives=${JSON.stringify(this.clientobjectives)}`,COLOR);
    }



}