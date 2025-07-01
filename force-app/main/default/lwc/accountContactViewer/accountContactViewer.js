import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountContactController.getAccounts';
import getContactsByAccount from '@salesforce/apex/AccountContactController.getContactsByAccount';

export default class AccountContactViewer extends LightningElement {
    @track accounts = [];
    @track contacts = [];
    @track selectedAccountName = '';
    @track selectedContact = {};
    @track showModal = false;

    accountColumns = [
        { label: 'Account Name', fieldName: 'Name' },
        {
            type: 'button',
            typeAttributes: {
                label: 'View Contacts',
                name: 'view_contacts',
                variant: 'brand'
            }
        }
    ];

    @wire(getAccounts)
    wiredAccounts({ data, error }) {
        if (data) {
            this.accounts = data;
        } else if (error) {
            console.error('Error fetching accounts:', error);
        }
    }

    handleAccountSelect(event) {
        const row = event.detail.row;
        this.selectedAccountName = row.Name;

        getContactsByAccount({ accountId: row.Id })
            .then(result => {
                this.contacts = result;
            })
            .catch(error => {
                console.error('Error fetching contacts:', error);
            });
    }

    handleContactClick(event) {
        const contactId = event.target.dataset.id;
        const contact = this.contacts.find(c => c.Id === contactId);
        this.selectedContact = contact;
        this.showModal = true;
    }

    closeModal() {
        this.showModal = false;
    }
}
