import { LightningElement, api } from 'lwc';

export default class ContactModal extends LightningElement {
    @api contact;

    closeModal() {
        this.dispatchEvent(new CustomEvent('close'));
    }
}