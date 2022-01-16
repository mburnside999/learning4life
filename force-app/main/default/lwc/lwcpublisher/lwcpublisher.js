// publisherComponent.js
import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import SAMPLEMC from '@salesforce/messageChannel/L4LMessageChannel__c';

export default class Lwcpublisher extends LightningElement {
    @wire(MessageContext)
    messageContext;
          
    handleClick() {
        const message = {
            recordId: '',
            message : "This is simple L4L message",
            source: "LWC",
            recordData: {}
        };
        publish(this.messageContext, SAMPLEMC, message);
    }
}