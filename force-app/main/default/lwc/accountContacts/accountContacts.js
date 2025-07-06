import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import getContacts from '@salesforce/apex/AccountController.getContacts';
import contactModal from 'c/contactModal';  // Correct import

const ACCOUNT_COLUMNS = [
    { label: 'Name', fieldName: 'Name', type: 'text' },
    { label: 'Industry', fieldName: 'Industry', type: 'text' },
    { label: 'Phone', fieldName: 'Phone', type: 'phone' },
    { 
        type: 'button', 
        typeAttributes: {
            label: 'View Contacts',
            name: 'view_contacts',
            title: 'View Contacts',
            disabled: false,
            value: 'view'
        }
    }
];

export default class AccountContacts extends LightningElement {
    accountColumns = ACCOUNT_COLUMNS;
    @track accounts = [];
    @track contacts = [];
    @track selectedAccountId;
    @track showModal = false;
    @track selectedContact;
    error;

    @wire(getAccounts)
    wiredAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = [];
        }
    }

    handleAccountSelect(event) {
        this.selectedAccountId = event.detail.row.Id;
        getContacts({ accountId: this.selectedAccountId })
            .then(result => {
                this.contacts = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.contacts = [];
            });
    }

    openModal(event) {
        this.selectedContact = this.contacts.find(
            contact => contact.Id === event.currentTarget.dataset.id
        );
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
    }
}