public with sharing class LeadService {
    public static void preventDuplicateEmails(List<Lead> leads, Map<Id, Lead> oldMap) {
        Set<String> emails = new Set<String>();
        for(Lead lead : leads) {
            if(lead.Email != null && (oldMap == null || lead.Email != oldMap.get(lead.Id).Email)) {
                emails.add(lead.Email.toLowerCase());
            }
        }
        if(emails.isEmpty()) return;
        // Check for existing Leads
        Map<String, Lead> existingLeads = LeadFactory.getLeadsByEmails(emails);
        // Add error if duplicate found
        for(Lead lead : leads) {
            if(lead.Email != null) {
                String emailKey = lead.Email.toLowerCase();
                if(existingLeads.containsKey(emailKey) && 
                   (oldMap == null || lead.Id != existingLeads.get(emailKey).Id)) {
                    lead.addError('A Lead with this email already exists.');
                }
            }
        }
    }
}