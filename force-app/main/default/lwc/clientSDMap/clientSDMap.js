import { LightningElement, api, wire,track } from 'lwc';
import removeDuplicates from '@salesforce/apex/L4LSDStageMap.removeDuplicates';


export default class clientSDMap extends LightningElement {
  // Obtain the Id of the current record from the page
  @api recordId;
  
  //Modal Code 
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @track isModalOpen = false;
    get inputVariables() {
      return [
          {
              name: 'clientId',
              type: 'String',
              value: this.recordId
          },
          {
              name: 'SDId',
              type: 'String',
              value: this.currentRecord
          }
      ];
  }

// set behavior after a finished flow interview
  handleStatusChange(event) {
    if (event.detail.status === 'FINISHED') {
      this.isModalOpen = false;   
    }
}
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

  // Populate the Stage Filter
  stageOptions = [
    { label: 'Stage One', value: 'Stage One' },
    { label: 'Stage Two', value: 'Stage Two' },
    { label: 'Stage Three', value: 'Stage Three' },
    { label: 'Stage Four', value: 'Stage Four' },
    { label: 'Stage Five', value: 'Stage Five' },
    { label: 'Stage Six', value: 'Stage Six' },
  ];

 

  // Declare a variable to store the filter value
  @track stageFilter = 'Stage One';

  // Declare a change handler for the filter input then return the filtered results as fsdRecords
handleFilterChange(event) {
  // Update the filter value
  this.stageFilter = event.target.value;
return this.fsdRecords = this.sdRecords.filter(record => record.Stage__c === this.stageFilter);
}

 // Declare a list to store the unique SD__c records and Stage filtered SD__c records
 sdRecords = [];
 fsdRecords = [];

  // Use the @wire decorator to call the removeDuplicates Apex method
  @wire(removeDuplicates, { clientId: '$recordId' })
wiredRemoveDuplicates({ error, data }) {
  if (data) {
    // If the Apex method returns successfully, store the unique SD__c records in the list then filter to display the default stage
    this.sdRecords = data;
    this.stageFilter = 'Stage One';
  return this.fsdRecords = this.sdRecords.filter(record => record.Stage__c === this.stageFilter);

  } else if (error) {
    // If an error occurs, log the error to the console
    console.error(error);
  }
}

}