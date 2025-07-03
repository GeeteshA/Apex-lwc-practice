import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountContactController.getAccounts';
import getContactsByAccount from '@salesforce/apex/AccountContactController.getContactsByAccount';

export default class AccountContactViewer extends LightningElement {
    @track accounts;
    @track selectedContacts;
    @track modalContact;
    @track showModal = false;

    columns = [
        { label: 'Account Name', fieldName: 'Name' },
        { type: 'button', typeAttributes: { label: 'View Contacts', name: 'view' } }
    ];

    contactColumns = [
        { label: 'First Name', fieldName: 'FirstName' },
        { label: 'Last Name', fieldName: 'LastName' },
        { label: 'Email', fieldName: 'Email' },
        { label: 'Phone', fieldName: 'Phone' },
        { type: 'button', typeAttributes: { label: 'View', name: 'view_contact' } }
    ];

    @wire(getAccounts)
    wiredAccounts({ data, error }) {
        if (data) {
            this.accounts = data;
        } else {
            console.error(error);
        }
    }

    handleRowAction(event) {
        const accountId = event.detail.row.Id;
        getContactsByAccount({ accountId })
            .then(result => {
                this.selectedContacts = result;
            })
            .catch(error => {
                console.error(error);
            });
    }

    handleContactModal(event) {
        this.modalContact = event.detail.row;
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
        this.modalContact = null;
    }
}
