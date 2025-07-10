import { LightningElement, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
import saveOpportunities from '@salesforce/apex/OpportunityController.saveOpportunities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Account', fieldName: 'AccountName', type: 'text' },
    { label: 'Stage', fieldName: 'StageName', type: 'text' },
    { label: 'Amount', fieldName: 'Amount', type: 'currency', editable: true },
    { 
        label: 'Close Date', 
        fieldName: 'CloseDate', 
        type: 'date-local', 
        editable: true,
        typeAttributes: {
            year: 'numeric',
            month: 'numeric',
            day: 'numeric'
        }
    }
];

export default class OpportunityEditor extends LightningElement {
    columns = COLUMNS;
    @track opportunities = [];
    @track draftValues = [];
    @track error;

    @wire(getOpportunities)
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunities = data.map(opp => ({
                ...opp,
                AccountName: opp.Account ? opp.Account.Name : ''
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.opportunities = [];
        }
    }
    handleSave(event) {
    this.draftValues = event.detail.draftValues;
    
    // Create array of fields to update
    const records = this.draftValues.map(draft => {
        return {
            fields: {
                Id: draft.Id,
                Amount: draft.Amount,
                CloseDate: draft.CloseDate
            }
        };
    });

    saveOpportunities({ opportunities: records })
        .then(() => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Opportunities updated successfully',
                    variant: 'success'
                })
            );
            this.draftValues = [];
            
            // Refresh data
            return getOpportunities();
        })
        .then(result => {
            this.opportunities = result.map(opp => ({
                ...opp,
                AccountName: opp.Account ? opp.Account.Name : ''
            }));
        })
        .catch(error => {
            this.error = error.body.message;
        });
}

    // handleSave(event) {
    //     this.draftValues = event.detail.draftValues;
        
    //     // Prepare data for saving
    //     const records = this.draftValues.map(draft => {
    //         const fields = Object.assign({}, draft);
    //         return { fields };
    //     });

    //     saveOpportunities({ opportunities: records })
    //         .then(() => {
    //             this.dispatchEvent(
    //                 new ShowToastEvent({
    //                     title: 'Success',
    //                     message: 'Opportunities updated successfully',
    //                     variant: 'success'
    //                 })
    //             );
    //             this.draftValues = [];
    //             return getOpportunities();
    //         })
    //         .then(result => {
    //             this.opportunities = result.map(opp => ({
    //                 ...opp,
    //                 AccountName: opp.Account ? opp.Account.Name : ''
    //             }));
    //         })
    //         .catch(error => {
    //             this.error = error.body.message;
    //         });
    // }
}