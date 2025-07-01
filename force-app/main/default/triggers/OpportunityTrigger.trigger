// Trigger to sync the latest closed Opportunity stage to a custom field on Account
trigger OpportunityTrigger on Opportunity (after insert, after update) {
    
    // Collect affected Account Ids
    Set<Id> affectedAccountIds = new Set<Id>();

    for (Opportunity opp : Trigger.new) {
        if ((opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') && opp.AccountId != null) {
            affectedAccountIds.add(opp.AccountId);
        }
    }

    List<Account> accountsToUpdate = new List<Account>();

    if (!affectedAccountIds.isEmpty()) {

        // Step 1: Get the latest Closed Opportunity date per Account
        List<AggregateResult> aggResults = [
            SELECT AccountId, MAX(CreatedDate) maxDate
            FROM Opportunity
            WHERE AccountId IN :affectedAccountIds
            AND (StageName = 'Closed Won' OR StageName = 'Closed Lost')
            GROUP BY AccountId
        ];

        // Map to track latest CreatedDate for each Account
        Map<Id, DateTime> accountIdToDateMap = new Map<Id, DateTime>();
        for (AggregateResult ar : aggResults) {
            accountIdToDateMap.put((Id)ar.get('AccountId'), (DateTime)ar.get('maxDate'));
        }

        // Step 2: Get all matching Opportunities and match by CreatedDate
        List<Opportunity> latestClosedOpps = [
            SELECT Id, StageName, AccountId, CreatedDate
            FROM Opportunity
            WHERE AccountId IN :accountIdToDateMap.keySet()
            AND (StageName = 'Closed Won' OR StageName = 'Closed Lost')
        ];

        for (Opportunity opp : latestClosedOpps) {
            if (
                accountIdToDateMap.containsKey(opp.AccountId) &&
                opp.CreatedDate == accountIdToDateMap.get(opp.AccountId)
            ) {
                Account acc = new Account(
                    Id = opp.AccountId,
                    Last_Closed_Opportunity_Stage__c = opp.StageName
                );
                accountsToUpdate.add(acc);
            }
        }
    }

    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}
