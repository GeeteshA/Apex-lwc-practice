import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import getContacts from '@salesforce/apex/AccountController.getContacts';
import contactModal from 'c/contactModal';

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
    @track contacts;
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
        this.loadContacts();
    }

    async loadContacts() {
        try {
            this.contacts = await getContacts({ accountId: this.selectedAccountId });
            this.error = undefined;
        } catch (error) {
            this.error = error.body.message;
            this.contacts = undefined;
        }
    }

    openModal(event) {
        const contactId = event.currentTarget.dataset.contactid;
        this.selectedContact = this.contacts.find(
            contact => contact.Id === contactId
        );
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
    }
}