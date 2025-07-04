import { LightningElement, track } from 'lwc';
import createCase from '@salesforce/apex/CaseController.createCase';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CaseCreator extends LightningElement {
    @track subject = '';
    @track description = '';
    @track type = '';
    typeOptions = [
        { label: 'Electrical', value: 'Electrical' },
        { label: 'Mechanical', value: 'Mechanical' },
        { label: 'Electronic', value: 'Electronic' }
    ];

    handleChange(event) {
        this[event.target.name] = event.target.value;
    }

    handleSubmit() {
        createCase({
            subject: this.subject,
            description: this.description,
            type: this.type
        })
        .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Case created successfully',
                variant: 'success'
            }));
            this.resetForm();
        })
        .catch(error => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: error.body.message,
                variant: 'error'
            }));
        });
    }

    resetForm() {
        this.subject = '';
        this.description = '';
        this.type = '';
    }
}