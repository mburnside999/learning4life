import { track,LightningElement } from 'lwc';
import {
    APPLICATION_SCOPE,
    createMessageContext,
    MessageContext,
    publish,
    releaseMessageContext,
    subscribe,
    unsubscribe,
} from 'lightning/messageService';
import recordSelected from '@salesforce/messageChannel/SampleMessageChannel';
export default class Testlwc extends LightningElement {

    @track x='Hello';



}