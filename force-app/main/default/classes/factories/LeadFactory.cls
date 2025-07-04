public class LeadFactory {
    public static Map<String, Lead> getLeadsByEmails(Set<String> emails) {
        Map<String, Lead> leadMap = new Map<String, Lead>();
        
        for (Lead l : [
            SELECT Id, Email 
            FROM Lead 
            WHERE Email IN :emails
        ]) {
            if (l.Email != null) {
                leadMap.put(l.Email.toLowerCase(), l);
            }
        }
        
        return leadMap;
    }
}