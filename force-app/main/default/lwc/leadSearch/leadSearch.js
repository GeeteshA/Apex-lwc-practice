import { LightningElement, track } from 'lwc';
import searchLeads from '@salesforce/apex/LeadController.searchByEmail';
import { NavigationMixin } from 'lightning/navigation';

export default class LeadSearch extends NavigationMixin(LightningElement) {
    @track searchTerm = '';
    @track leads = [];
    @track error;
    @track noResults = false;

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    handleSearch() {
        if (this.searchTerm.length < 2) {
            this.error = 'Please enter at least 2 characters';
            this.leads = [];
            this.noResults = false;
            return;
        }

        searchLeads({ email: this.searchTerm })
            .then(result => {
                this.leads = result;
                this.error = undefined;
                this.noResults = result.length === 0;
            })
            .catch(error => {
                this.error = error.body.message;
                this.leads = [];
                this.noResults = false;
            });
    }

    viewLead(event) {
        const leadId = event.target.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: leadId,
                objectApiName: 'Lead',
                actionName: 'view'
            }
        });
    }
}