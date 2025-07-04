public with sharing class LeadController {
    @AuraEnabled
    public static List<Lead> searchByEmail(String email) {
        String searchKey = '%' + email + '%';
        return [
            SELECT Id, Name, Email, Company, Status, Phone
            FROM Lead 
            WHERE Email LIKE :searchKey
            ORDER BY Name
            LIMIT 50
        ];
    }
}