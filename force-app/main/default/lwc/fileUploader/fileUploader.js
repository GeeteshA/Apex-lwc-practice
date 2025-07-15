// import { LightningElement, api, wire, track } from 'lwc';
// import getFiles from '@salesforce/apex/FileController.getFiles';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// const COLUMNS = [
//     { label: 'File Name', fieldName: 'Title', type: 'text' },
//     { label: 'Type', fieldName: 'FileType', type: 'text' },
//     { label: 'Uploaded By', fieldName: 'OwnerName', type: 'text' },
//     { label: 'Uploaded Date', fieldName: 'CreatedDate', type: 'date-local' },
//     {
//         type: 'button',
//         typeAttributes: {
//             label: 'View',
//             name: 'view',
//             title: 'View File',
//             disabled: false,
//             value: 'view'
//         }
//     }
// ];

// export default class FileUploader extends LightningElement {
//     @api recordId;
//     columns = COLUMNS;
//     @track files = [];
//     @track noFiles = false;
//     acceptedFormats = ['.pdf', '.png', '.jpg', '.jpeg', '.doc', '.docx', '.xls', '.xlsx'];

//     @wire(getFiles, { caseId: '$recordId' })
//     wiredFiles({ error, data }) {
//         if (data) {
//             this.files = data.map(file => ({
//                 Id: file.ContentDocument.Id,
//                 Title: file.ContentDocument.Title,
//                 FileType: file.ContentDocument.FileType,
//                 OwnerName: file.ContentDocument.Owner.Name,
//                 CreatedDate: file.ContentDocument.CreatedDate
//             }));
//             this.noFiles = this.files.length === 0;
//             this.error = undefined;
//         } else if (error) {
//             this.error = error;
//             this.files = [];
//             this.noFiles = true;
//         }
//     }

//     handleUploadFinished(event) {
//         const uploadedFiles = event.detail.files;
//         this.dispatchEvent(
//             new ShowToastEvent({
//                 title: 'Success',
//                 message: `${uploadedFiles.length} file(s) uploaded successfully`,
//                 variant: 'success'
//             })
//         );
        
//         // Refresh file list
//         return getFiles({ caseId: this.recordId })
//             .then(result => {
//                 this.files = result.map(file => ({
//                     Id: file.ContentDocument.Id,
//                     Title: file.ContentDocument.Title,
//                     FileType: file.ContentDocument.FileType,
//                     OwnerName: file.ContentDocument.Owner.Name,
//                     CreatedDate: file.ContentDocument.CreatedDate
//                 }));
//                 this.noFiles = this.files.length === 0;
//             });
//     }
// }

// fileUploader.js - Fixed implementation
import { LightningElement, api, wire, track } from 'lwc';
import getFiles from '@salesforce/apex/FileController.getFiles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FileUploader extends LightningElement {
    @api recordId;
    @track files = [];
    @track error;
    @track isLoading = false;
    acceptedFormats = ['.pdf', '.png', '.jpg', '.jpeg', '.doc', '.docx'];
    
    // Wire method to get files
    @wire(getFiles, { caseId: '$recordId' })
    wiredFiles({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.files = data.map(file => ({
                Id: file.ContentDocument.Id,
                Title: file.ContentDocument.Title,
                FileType: file.ContentDocument.FileType,
                Link: `/lightning/r/ContentDocument/${file.ContentDocument.Id}/view`
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.files = [];
        }
    }

    handleUploadFinished(event) {
        this.isLoading = true;
        const uploadedFiles = event.detail.files;
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: `${uploadedFiles.length} file(s) uploaded`,
                variant: 'success'
            })
        );
        
        // Refresh file list
        getFiles({ caseId: this.recordId })
            .then(result => {
                this.files = result.map(file => ({
                    Id: file.ContentDocument.Id,
                    Title: file.ContentDocument.Title,
                    FileType: file.ContentDocument.FileType,
                    Link: `/lightning/r/ContentDocument/${file.ContentDocument.Id}/view`
                }));
            })
            .catch(error => {
                this.error = error.body.message;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}