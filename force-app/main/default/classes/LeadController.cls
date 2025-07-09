public with sharing class LeadController {
    @AuraEnabled(cacheable=true)
    public static List<Lead> searchByEmail(String email) {
        return LeadService.searchByEmail(email);
    }
}