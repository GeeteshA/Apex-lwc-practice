import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseCreator extends LightningElement {
    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Case created: ' + event.detail.id,
                variant: 'success'
            })
        );
        
        // Reset form
        this.template.querySelector('lightning-record-edit-form').reset();
    }
}