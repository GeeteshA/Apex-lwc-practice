public with sharing class FileController {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getFiles(Id caseId) {
        return FileManagementService.getFiles(caseId);
    }
}