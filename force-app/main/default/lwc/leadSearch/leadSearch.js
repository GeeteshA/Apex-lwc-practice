import { LightningElement, track } from 'lwc';
import searchLeads from '@salesforce/apex/LeadController.searchByEmail';

export default class LeadSearch extends LightningElement {
    @track searchTerm = '';
    @track leads = [];
    @track error;

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    handleSearch() {
        if (this.searchTerm.length < 2) {
            this.error = 'Please enter at least 2 characters';
            return;
        }

        searchLeads({ email: this.searchTerm })
            .then(result => {
                this.leads = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error.body.message;
                this.leads = [];
            });
    }
}