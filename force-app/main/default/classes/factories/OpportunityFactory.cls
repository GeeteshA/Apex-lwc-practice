public class OpportunityFactory {
    public static Map<Id, DateTime> getLatestClosedDates(Set<Id> accountIds) {
        Map<Id, DateTime> results = new Map<Id, DateTime>();
        
        for (AggregateResult ar : [
            SELECT AccountId, MAX(CreatedDate) maxDate
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND StageName IN ('Closed Won', 'Closed Lost')
            GROUP BY AccountId
        ]) {
            results.put((Id) ar.get('AccountId'), (DateTime) ar.get('maxDate'));
        }
        
        return results;
    }
    
    public static List<Opportunity> getOpportunitiesByCloseDates(
        Set<Id> accountIds, 
        Map<Id, DateTime> closeDates
    ) {
        return [
            SELECT Id, StageName, AccountId, CreatedDate
            FROM Opportunity
            WHERE AccountId IN :accountIds
            AND CreatedDate IN :closeDates.values()
            AND StageName IN ('Closed Won', 'Closed Lost')
        ];
    }
}