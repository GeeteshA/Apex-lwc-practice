public class OpportunityTriggerHandler {
    public static void handleAfterInsertOrUpdate(List<Opportunity> newOpps) {
        Set<Id> affectedAccountIds = new Set<Id>();

        for (Opportunity opp : newOpps) {
            if ((opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') && opp.AccountId != null) {
                affectedAccountIds.add(opp.AccountId);
            }
        }

        if (affectedAccountIds.isEmpty()) return;

        // Step 1: Get latest closed opportunity date for each account
        Map<Id, DateTime> accountIdToMaxDateMap = new Map<Id, DateTime>();
        List<AggregateResult> aggResults = [
            SELECT AccountId, MAX(CreatedDate) maxDate
            FROM Opportunity
            WHERE AccountId IN :affectedAccountIds
            AND (StageName = 'Closed Won' OR StageName = 'Closed Lost')
            GROUP BY AccountId
        ];

        for (AggregateResult ar : aggResults) {
            accountIdToMaxDateMap.put(
                (Id) ar.get('AccountId'),
                (DateTime) ar.get('maxDate')
            );
        }

        // Step 2: Fetch latest Opportunities based on max created date
        List<Opportunity> matchingOpps = [
            SELECT Id, StageName, AccountId, CreatedDate
            FROM Opportunity
            WHERE AccountId IN :accountIdToMaxDateMap.keySet()
            AND (StageName = 'Closed Won' OR StageName = 'Closed Lost')
        ];

        List<Account> accountsToUpdate = new List<Account>();
        for (Opportunity opp : matchingOpps) {
            if (
                accountIdToMaxDateMap.containsKey(opp.AccountId) &&
                opp.CreatedDate == accountIdToMaxDateMap.get(opp.AccountId)
            ) {
                Account acc = new Account(
                    Id = opp.AccountId,
                    Last_Closed_Opportunity_Stage__c = opp.StageName
                );
                accountsToUpdate.add(acc);
            }
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
