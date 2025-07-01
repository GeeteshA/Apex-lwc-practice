// Prevents duplicate Leads based on the Email field
trigger LeadTrigger on Lead (before insert, before update) {
    
    // Set to collect all emails from incoming Leads
    Set<String> incomingEmails = new Set<String>();

    for (Lead lead : Trigger.new) {
        if (lead.Email != null) {
            incomingEmails.add(lead.Email.toLowerCase());
        }
    }

    // Query existing Leads from DB with same emails
    Map<String, Lead> existingLeads = new Map<String, Lead>();
    for (Lead existing : [
        SELECT Id, Email FROM Lead
        WHERE Email IN :incomingEmails
    ]) {
        existingLeads.put(existing.Email.toLowerCase(), existing);
    }

    // Check each Lead in the trigger
    for (Lead lead : Trigger.new) {
        if (lead.Email != null) {
            String emailKey = lead.Email.toLowerCase();

            // If email already exists and it's not the same record
            if (existingLeads.containsKey(emailKey)) {
                Lead existingLead = existingLeads.get(emailKey);

                // For insert, or update to another record (not self)
                if (Trigger.isInsert || (Trigger.isUpdate && lead.Id != existingLead.Id)) {
                    lead.addError('A Lead with this email already exists.');
                }
            }
        }
    }
}
