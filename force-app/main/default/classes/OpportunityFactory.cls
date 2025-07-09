public with sharing class OpportunityFactory {
    // For trigger use
    public static List<Opportunity> getOpportunitiesByCloseDates(Set<Id> accountIds, Set<Date> closeDates) {
        return [
            SELECT Id, StageName, AccountId
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND CloseDate IN :closeDates
            AND StageName IN ('Closed Won', 'Closed Lost')
        ];
    }

    // For LWC use
    public static List<Opportunity> getOpportunities() {
        return [
            SELECT Id, Name, StageName, Amount, CloseDate, Account.Name 
            FROM Opportunity 
            ORDER BY CloseDate DESC 
            LIMIT 50
        ];
    }

    public static List<AggregateResult> getClosedOpportunityDates(Set<Id> accountIds) {
        return [
            SELECT AccountId, MAX(CloseDate) maxDate
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND StageName IN ('Closed Won', 'Closed Lost')
            GROUP BY AccountId
        ];
    }
}