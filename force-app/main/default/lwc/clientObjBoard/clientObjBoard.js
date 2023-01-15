import { LightningElement, api, wire, track } from 'lwc';
import getClientObjectives from '@salesforce/apex/ClientObjectiveList.getClientObjectives';


export default class ClientObjBoard extends LightningElement {
    @track objectives;
    @track error;
    @api recordId;

    @wire(getClientObjectives, {clientId: '$recordId'}) 
    WireObjectiveRecords({error, data}){
        if(data){
            this.objectives = data;
            this.error = undefined;
            this.stageFilter = 'Stage One';


       // Update Status__c field if it is 1IP to lIP to work with css
      this.objectives = this.objectives.map((obj) => {
        if (obj.Status__c === '1IP') {
          return { ...obj, Status__c: 'lIP' };
        }
        return obj;
      });
      // Update Status__c field if it is null
      this.objectives = this.objectives.map((obj) => {
        if (obj.Status__c == null || obj.Status__c == '') {
          return { ...obj, Status__c: 'Blank' };
        }
        return obj;
      });

      // This sets the array fobjectives to pass to the HTML for display- with the default filter set to Stage One 
            this.fobjectives = this.objectives.filter(record => record.Stage__c === this.stageFilter);

            // returning values for Program Filter
            this.programOptions = this.objectives.map(option => ({
                 label: option.Program_Name__c, value: option.Program_Name__c             
        }));
        
        return;
    }

        else{
            this.error = error;
            this.objectives = undefined;
        } 
            }


// Populate the Stage Filter
stageOptions = [
    { label: 'Stage One', value: 'Stage One' },
    { label: 'Stage Two', value: 'Stage Two' },
    { label: 'Stage Three', value: 'Stage Three' },
    { label: 'Stage Four', value: 'Stage Four' },
    { label: 'Stage Five', value: 'Stage Five' },
    { label: 'Stage Six', value: 'Stage Six' },
  ];


  // All the Filters are belwo here
  // Declare a variable to store the filter value
  @track stageFilter = 'Stage One';

  // Declare a change handler for the filter input then return the filtered results as fsdRecords
handleFilterChange(event) {
  // Update the filter value- set the value of the other filter to null to avoid confusion
  this.statusFilter =""
  this.programFilter =""
  this.stageFilter = event.target.value;
return this.fobjectives = this.objectives.filter(record => record.Stage__c === this.stageFilter);
}

// Populate the Status Filter Options
statusOptions = [
    { label: 'OBJ', value: 'OBJ' },
    { label: 'ACQ', value: 'ACQ' },
    { label: 'ABS', value: 'ABS' },
    { label: '1IP', value: 'lIP' },
    { label: 'DNC', value: 'DNC' },
    { label: 'HLD', value: 'HLD' },
    { label: 'CIP', value: 'CIP' },
    { label: 'Blank', value: 'Blank' },
  ];

  // Declare a variable to store the status filter value
  @track statusFilter = '';

  // Declare a change handler for the filter input then return the filtered results as fsobjectives
handleObjStatusChange(event) {
  // Update the filter value and set the other filter to null to avoid UI confusion
  this.stageFilter =""
  this.programFilter =""
  this.statusFilter = event.target.value;
return this.fobjectives = this.objectives.filter(record => record.Status__c === this.statusFilter);
}

// Declare a variable to store the Program filter value and populate the options
@track programFilter;
  programOptions = [];

  
// Update the program filter value and set the other filter to null to avoid UI confusion
  handleProgramChange(event) {
    this.programFilter = event.target.value;
    this.stageFilter =""
    this.statusFilter =""

    return this.fobjectives = this.objectives.filter(record => record.Program_Name__c === this.programFilter);
  }


 // Refresh button
 
 refresh() {
  this.stageFilter ="Stage One"
  this.statusFilter =""
  this.programFilter =""

  // Re-invoke the Apex method and update the component's properties
  getClientObjectives({ clientId: this.recordId })
    .then(result => {
      this.objectives = result;
      this.fobjectives = result.filter(record => record.Stage__c === this.stageFilter);
      this.programOptions = result.map(option => ({
        label: option.Program_Name__c,
        value: option.Program_Name__c
      }));
      
    })
    .catch(error => {
      this.error = error;
      this.objectives = undefined;
    });
}
handleRefresh() {
  this.refresh();
}

//   Functions for the Modal 


    @track isModalOpen = false;
    
    openModal(event) {
        // to open modal set isModalOpen track value as true
        this.currentRecord = event.target.getAttribute('data-id');
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }



  }