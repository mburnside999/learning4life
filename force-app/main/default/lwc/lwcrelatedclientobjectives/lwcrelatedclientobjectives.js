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

const COLOR="color:magenta";
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
    filterableObjectives = {};
    @wire(CurrentPageReference) pageRef;
    @track draftValues = [];
    @track areDetailsVisible = false;
    //@wire(getClientObjectives, { clientId: '$recordId' }) clientobjectives;

    connectedCallback() {
        console.info(`%cconnectedCallback(): entering`,COLOR);
        console.debug(`%cconnectedCallback(): subscribing to pub sub inputChangeEvent`,COLOR);
        console.debug(`%cconnectedCallback(): registering listener inputChangeEvent`,COLOR);
        registerListener('inputChangeEvent', this.handleChange, this);
        console.debug(`%cconnectedCallback(): calling this.refresh() to get client objectives, recordId =  ${this.recordId}`,COLOR);
        this.refresh();

    }

    handleRowAction(event) {
        console.info(`%chandleRowAction(): entering`,COLOR);
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        console.debug(`%chandleRowAction(): row=${JSON.stringify(row)}`,COLOR);
        switch (actionName) {
            case 'delete':
                console.debug(`%chandleRowAction: case delete`,COLOR);
                console.debug(`%chandleRowAction: calling deleteRecord row.Id=${row.Id}`,COLOR);

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
                        console.error(`%chandleRowAction: error in deleteRecord row.Id=${row.Id}`,COLOR);

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
                console.debug(`%chandleRowAction: case edit_details`,COLOR);
                console.debug(`%chandleRowAction: setting this.COrecordId=${row.Id}`,COLOR);
                this.COrecordId = row.Id;
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
        console.info(`%crefresh(): entering`,COLOR);
        console.debug(`%crefresh(): calling getClientObjectives, recordId = ${this.recordId}`,COLOR);
        getClientObjectives({
                clientId: this.recordId
            })
            .then(result => {
                console.debug(`%crefresh(): getClientObjectives returned ${JSON.stringify(result)}`,COLOR);
                this.clientobjectives = result;
                this.filterableObjectives = result;
                console.debug(`%crefresh(): this.clientObjectives= ${JSON.stringify(this.clientobjectives)}`,COLOR);

            })
            .catch(error => {
                this.error = error;
                console.log(`%cERROR ${JSON.stringify(error)}`,COLOR);
            });



    }

    handleCancel(event) {
        console.log('Cancelling');
        this.areDetailsVisible = false;

    }
    handleSave(event) {
        console.debug(`%chandleSave(): ${JSON.stringify(event.detail.draftValues)}`,COLOR);
        const recordInputs = event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return {
                fields
            };
        });
        console.debug(`%chandleSave(): calling Promise.all to updateRecord`,COLOR);
        const promises = recordInputs.map(recordInput => updateRecord(recordInput));
        Promise.all(promises).then(contacts => {
            console.debug(`%chandleSave(): Promise.all resolved`,COLOR);
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
            console.debug(`%chandleSave(): calling refresh()`,COLOR);
            this.refresh();
        }).catch(error => {
            console.error(`%chandleSave(): Promise.all rejected`,COLOR);
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
        console.info(`%chandleChange(): entering, received inpVal=${inpVal}`,COLOR);
        console.log('received pub sub input event');
        console.debug(`%chandleChange(): calling getClientObjectives, clientId=${this.recordId}`,COLOR);

        getClientObjectives({
                clientId: this.recordId
            })
            .then(result => {
                console.debug(`%chandleChange(): returned result=${JSON.stringify(result)}`,COLOR);
                this.clientobjectives = result;
                this.filterableObjectives = result;
                console.debug(`%chandleChange(): this.filterableObjectives=${JSON.stringify(this.filterableObjectives)}`,COLOR);

            })
            .catch(error => {
                this.error = error;
                console.log(`%c%chandleChange(): ERROR ${JSON.stringify(error)}`,COLOR);
            });
    }

    handleSearchKeyInput(event) {

        const searchKey = event.target.value.toLowerCase();
        console.debug(`%chandleSearchKeyInput(): searchKey= ${searchKey}. this.filterableObjectives= ${JSON.stringify(this.filterableObjectives)}`,COLOR);
        this.clientobjectives = this.filterableObjectives.filter(
            so => so.Name.toLowerCase().includes(searchKey) || (so.Status__c != null && so.Status__c.toLowerCase().includes(searchKey) ) || so.SD_Name__c.toLowerCase().includes(searchKey) || so.Program_Name__c.toLowerCase().includes(searchKey) || so.Objective_Name__c.toLowerCase().includes(searchKey)
            );

        console.debug(`%chandleSearchKeyInput(): this.clientobjectives=${JSON.stringify(this.clientobjectives)}`,COLOR);
    }



}