public with sharing class FileFactory {
    public static List<ContentDocumentLink> getFiles(Id caseId) {
        return [
            SELECT ContentDocument.Id, ContentDocument.Title, 
                   ContentDocument.FileType, ContentDocument.Owner.Name,
                   ContentDocument.CreatedDate 
            FROM ContentDocumentLink 
            WHERE LinkedEntityId = :caseId
        ];
    }
}