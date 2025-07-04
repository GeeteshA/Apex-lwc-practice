import { LightningElement, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
import saveOpportunities from '@salesforce/apex/OpportunityController.saveOpportunities';

const columns = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency', editable: true },
    { label: 'Close Date', fieldName: 'CloseDate', type: 'date', editable: true }
];

export default class OpportunityEditor extends LightningElement {
    @track opportunities = [];
    @track columns = columns;
    @track draftValues = [];

    @wire(getOpportunities)
    wiredOpps({ error, data }) {
        if (data) this.opportunities = data;
        else if (error) console.error(error);
    }

    handleSave(event) {
        this.draftValues = event.detail.draftValues;
        saveOpportunities({ opps: this.draftValues })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Opportunities updated',
                    variant: 'success'
                }));
                this.draftValues = [];
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error',
                    message: error.body.message,
                    variant: 'error'
                }));
            });
    }
}