// LeadTriggerHandler.cls
public class LeadTriggerHandler {
    public static void preventDuplicateEmails(List<Lead> newLeads, Boolean isInsert, Boolean isUpdate) {
        Set<String> emails = new Set<String>();
        
        for (Lead lead : newLeads) {
            if (lead.Email != null) {
                emails.add(lead.Email.toLowerCase());
            }
        }
        
        if (emails.isEmpty()) return;
        
        Map<String, Lead> existingLeads = LeadFactory.getLeadsByEmails(emails);
        
        for (Lead lead : newLeads) {
            if (lead.Email != null) {
                String emailKey = lead.Email.toLowerCase();
                
                if (existingLeads.containsKey(emailKey)) {
                    Lead existing = existingLeads.get(emailKey);
                    
                    if (isInsert || (isUpdate && lead.Id != existing.Id)) {
                        lead.addError('A Lead with this email already exists.');
                    }
                }
            }
        }
    }
}

