public with sharing class LeadTriggerHandler {
    // Prevents duplicate Leads by email
    // Throw error if email exists
    public static void onBeforeInsert(List<Lead> newLeads) {
        LeadService.preventDuplicateEmails(newLeads, null);
    }
    
    public static void onBeforeUpdate(List<Lead> updatedLeads, Map<Id, Lead> oldMap) {
        LeadService.preventDuplicateEmails(updatedLeads, oldMap);
    }
}
