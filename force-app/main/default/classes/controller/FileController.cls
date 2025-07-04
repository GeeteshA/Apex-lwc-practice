public with sharing class FileController {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getFiles(Id caseId) {
        return [
            SELECT ContentDocument.Id, ContentDocument.Title, 
                   ContentDocument.FileType, ContentDocument.CreatedDate,
                   ContentDocument.Owner.Name
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :caseId
            ORDER BY ContentDocument.CreatedDate DESC
        ];
    }
}