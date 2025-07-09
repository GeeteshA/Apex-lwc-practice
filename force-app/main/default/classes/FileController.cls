public with sharing class FileController {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getFiles(Id caseId) {
        return FileService.getFiles(caseId);
    }
}