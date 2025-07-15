// import { LightningElement, wire, track } from 'lwc';
// import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
// import saveOpportunities from '@salesforce/apex/OpportunityController.saveOpportunities';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// const COLUMNS = [
//     { label: 'Name', fieldName: 'Name', type: 'text' },
//     { label: 'Account', fieldName: 'AccountName', type: 'text' },
//     { label: 'Stage', fieldName: 'StageName', type: 'text' },
//     { label: 'Amount', fieldName: 'Amount', type: 'currency', editable: true },
//     { 
//         label: 'Close Date', 
//         fieldName: 'CloseDate', 
//         type: 'date-local', 
//         editable: true,
//         typeAttributes: {
//             year: 'numeric',
//             month: 'numeric',
//             day: 'numeric'
//         }
//     }
// ];

// export default class OpportunityEditor extends LightningElement {
//     columns = COLUMNS;
//     @track opportunities = [];
//     @track draftValues = [];
//     @track error;

//     @wire(getOpportunities)
//     wiredOpportunities({ error, data }) {
//         if (data) {
//             this.opportunities = data.map(opp => ({
//                 ...opp,
//                 AccountName: opp.Account ? opp.Account.Name : ''
//             }));
//             this.error = undefined;
//         } else if (error) {
//             this.error = error;
//             this.opportunities = [];
//         }
//     }
//     handleSave(event) {
//     this.draftValues = event.detail.draftValues;
    
//     // Create array of fields to update
//     const records = this.draftValues.map(draft => {
//         return {
//             fields: {
//                 Id: draft.Id,
//                 Amount: draft.Amount,
//                 CloseDate: draft.CloseDate
//             }
//         };
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
            
//             // Refresh data
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

// }
import { LightningElement, wire, track } from 'lwc';
import getOpportunities from '@salesforce/apex/OpportunityController.getOpportunities';
import saveOpportunities from '@salesforce/apex/OpportunityController.saveOpportunities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class OpportunityInlineEdit extends LightningElement {
    @track opportunities = [];
    @track draftValues = [];
    wiredOpportunitiesResult;

    columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Stage', fieldName: 'StageName', type: 'text' },
        { label: 'Amount', fieldName: 'Amount', type: 'currency', editable: true },
        { label: 'Close Date', fieldName: 'CloseDate', type: 'date', editable: true },
        { label: 'Account', fieldName: 'AccountName', type: 'text' }
    ];

    @wire(getOpportunities)
    wiredOpportunities(result) {
        this.wiredOpportunitiesResult = result;
        if (result.data) {
            this.opportunities = result.data.map(opp => ({
                ...opp,
                AccountName: opp.Account?.Name || ''
            }));
        } else if (result.error) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error loading Opportunities',
                message: result.error.body.message,
                variant: 'error'
            }));
        }
    }

    handleSave(event) {
        console.log('Save triggered');
        const updatedFields = event.detail.draftValues;
        console.log('Updated Fields:', JSON.stringify(updatedFields)); 

        saveOpportunities({ opportunities: updatedFields })
            .then(() => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Opportunities updated successfully',
                    variant: 'success'
                }));

                this.draftValues = [];

                return refreshApex(this.wiredOpportunitiesResult);
            })
            .catch(error => {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Error updating Opportunities',
                    message: error.body.message,
                    variant: 'error'
                }));
            });
    }
}
