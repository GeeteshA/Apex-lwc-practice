public with sharing class LeadService {
    private static final String DUPLICATE_EMAIL_ERROR = 'A Lead with this email already exists.';

    public static void preventDuplicateEmails(List<Lead> leads, Map<Id, Lead> oldMap) {
        Set<String> emails = new Set<String>();
        for(Lead lead : leads) {
            if(lead.Email != null && (oldMap == null || lead.Email != oldMap.get(lead.Id).Email)) {
                emails.add(lead.Email.toLowerCase());
            }
        }
        if(emails.isEmpty()) return;
        
        // Now using the Map version
        Map<String, Lead> existingLeads = LeadFactory.getLeadsByEmailsMap(emails);

        for(Lead lead : leads) {
            if(lead.Email != null) {
                String emailKey = lead.Email.toLowerCase();
                if(existingLeads.containsKey(emailKey) && 
                   (oldMap == null || lead.Id != existingLeads.get(emailKey).Id)) {
                    lead.addError(DUPLICATE_EMAIL_ERROR);
                }
            }
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Lead> searchByEmail(String email) {
        return LeadFactory.getLeadsByEmail(email);
    }
}