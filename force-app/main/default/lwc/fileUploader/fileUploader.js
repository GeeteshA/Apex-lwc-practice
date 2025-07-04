import { LightningElement, api, track } from 'lwc';
import getFiles from '@salesforce/apex/FileController.getFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FileUploader extends LightningElement {
    @api recordId;
    @track files = [];

    connectedCallback() {
        this.loadFiles();
    }

    loadFiles() {
        getFiles({ caseId: this.recordId })
            .then(result => this.files = result)
            .catch(error => console.error(error));
    }

    handleUploadFinished(event) {
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Files uploaded successfully',
            variant: 'success'
        }));
        this.loadFiles();
    }
}