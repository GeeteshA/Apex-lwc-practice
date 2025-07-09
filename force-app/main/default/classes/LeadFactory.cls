public with sharing class LeadFactory {
    // For trigger use (returns Map)
    public static Map<String, Lead> getLeadsByEmailsMap(Set<String> emails) {
        Map<String, Lead> leadMap = new Map<String, Lead>();
        for(Lead l : [
            SELECT Id, Email 
            FROM Lead 
            WHERE Email IN :emails
        ]) {
            if(l.Email != null) {
                leadMap.put(l.Email.toLowerCase(), l);
            }
        }
        return leadMap;
    }

    // For LWC use (returns List)
    public static List<Lead> getLeadsByEmail(String email) {
        return [
            SELECT Id, Name, Email, Company, Status, Phone
            FROM Lead 
            WHERE Email = :email
            ORDER BY Name
            LIMIT 50
        ];
    }
}