public with sharing class OpportunityFactory {
    // Gets latest closed dates for Opportunities per Account
    // Scenario: Sync Opportunity stage to Account

    public static Map<Id, Date> getLatestClosedDates(Set<Id> accountIds) {
        Map<Id, Date> results = new Map<Id, Date>();
        for(AggregateResult ar : [
            SELECT AccountId, MAX(CloseDate) maxDate
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND StageName IN ('Closed Won', 'Closed Lost')
            GROUP BY AccountId
        ]) {
            results.put((Id) ar.get('AccountId'), (Date) ar.get('maxDate'));
        }
        return results;
    }

    // Gets Opportunities matching latest close dates

    public static List<Opportunity> getOpportunitiesByCloseDates(Set<Id> accountIds, Map<Id, Date> closeDates) {
        return [
            SELECT Id, StageName, AccountId
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND CloseDate IN :closeDates.values()  
            AND StageName IN ('Closed Won', 'Closed Lost')
        ];
    }
}