public with sharing class FileManagementService {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getFiles(Id caseId) {
        return FileFactory.getFiles(caseId);
    }
}
