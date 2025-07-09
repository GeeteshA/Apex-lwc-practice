public with sharing class FileService {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getFiles(Id caseId) {
        return FileFactory.getFiles(caseId);
    }
}