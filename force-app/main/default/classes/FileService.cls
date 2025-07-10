// public with sharing class FileService {
//     @AuraEnabled(cacheable=true)
//     public static List<ContentDocumentLink> getFiles(Id caseId) {
//         return FileFactory.getFiles(caseId);
//     }
// }
public with sharing class FileController {
    @AuraEnabled(cacheable=true)
    public static List<ContentDocumentLink> getFiles(Id caseId) {
        return FileService.getFiles(caseId);
    }
}