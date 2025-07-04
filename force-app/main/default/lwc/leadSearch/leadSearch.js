import { LightningElement, track } from 'lwc';
import searchLeads from '@salesforce/apex/LeadController.searchByEmail';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LeadSearch extends NavigationMixin(LightningElement) {
    @track searchTerm = '';
    @track leads = [];
    @track error;
    @track noResults = false;
    
    // Computed property for button disabled state
    get isSearchDisabled() {
        return !this.searchTerm || this.searchTerm.length < 2;
    }
    
    // Computed property for button tooltip
    get searchButtonTitle() {
        if (!this.searchTerm) return "Please enter an email address";
        if (this.searchTerm.length < 2) return "Enter at least 2 characters";
        return "Search leads";
    }
    
    // Handle input changes
    handleSearchChange(event) {
        this.searchTerm = event.target.value;
        this.error = undefined;
    }
    
    // Perform search
    handleSearch() {
        // Validate email format
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(this.searchTerm)) {
            this.error = 'Please enter a valid email address';
            this.leads = [];
            this.noResults = false;
            return;
        }
        
        // Execute search
        searchLeads({ email: this.searchTerm })
            .then(result => {
                this.leads = result;
                this.error = undefined;
                this.noResults = result.length === 0;
                
                if (this.noResults) {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'No Results',
                        message: 'No leads found with that email address',
                        variant: 'info'
                    }));
                }
            })
            .catch(error => {
                this.error = this.reduceErrors(error);
                this.leads = [];
                this.noResults = false;
            });
    }
    
    // Navigate to lead record
    viewLead(event) {
        const leadId = event.currentTarget.dataset.id;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: leadId,
                objectApiName: 'Lead',
                actionName: 'view'
            }
        });
    }
    
    // Helper to reduce Apex errors
    reduceErrors(error) {
        const body = error.body;
        if (body.exceptionType) {
            return `${body.exceptionType}: ${body.message}`;
        } else if (body.fieldErrors) {
            return Object.values(body.fieldErrors).map(e => e.message).join(', ');
        } else if (body.pageErrors) {
            return body.pageErrors.map(e => e.message).join(', ');
        }
        return error.message || 'Unknown error';
    }
}