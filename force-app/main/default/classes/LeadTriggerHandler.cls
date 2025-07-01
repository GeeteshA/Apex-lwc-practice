public class LeadTriggerHandler {
    public static void preventDuplicateEmails(List<Lead> newLeads, Boolean isInsert, Boolean isUpdate) {
        Set<String> incomingEmails = new Set<String>();

        for (Lead lead : newLeads) {
            if (lead.Email != null) {
                incomingEmails.add(lead.Email.toLowerCase());
            }
        }

        if (incomingEmails.isEmpty()) return;

        Map<String, Lead> existingLeadsByEmail = new Map<String, Lead>();
        for (Lead existing : [
            SELECT Id, Email FROM Lead
            WHERE Email IN :incomingEmails
        ]) {
            if (existing.Email != null) {
                existingLeadsByEmail.put(existing.Email.toLowerCase(), existing);
            }
        }

        for (Lead lead : newLeads) {
            if (lead.Email != null) {
                String emailKey = lead.Email.toLowerCase();

                if (existingLeadsByEmail.containsKey(emailKey)) {
                    Lead existingLead = existingLeadsByEmail.get(emailKey);

                    // Prevent insert or update into another existing lead
                    if (isInsert || (isUpdate && lead.Id != existingLead.Id)) {
                        lead.addError('A Lead with this email already exists.');
                    }
                }
            }
        }
    }
}
