public with sharing class OpportunityService {
    public static void syncStageToAccount(List<Opportunity> opps) {
        Set<Id> accountIds = new Set<Id>();

        // Collect all account IDs from the Opportunities
        for (Opportunity opp : opps) {
            if (opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }

        if (!accountIds.isEmpty()) {
            // Get the latest CloseDate per Account
            List<AggregateResult> aggResults = OpportunityFactory.getLatestOpportunityDates(accountIds);
            Map<Id, Date> maxDates = new Map<Id, Date>();
            for (AggregateResult ar : aggResults) {
                maxDates.put((Id) ar.get('AccountId'), (Date) ar.get('maxDate'));
            }

            // Get latest Opportunities by those max dates
            List<Opportunity> latestOpps = OpportunityFactory.getOpportunitiesByCloseDates(accountIds, new Set<Date>(maxDates.values()));

            // Prepare Account updates
            List<Account> accountsToUpdate = new List<Account>();
            for (Opportunity opp : latestOpps) {
                accountsToUpdate.add(new Account(
                    Id = opp.AccountId,
                    Last_Closed_Opportunity_Stage__c = opp.StageName // even if not closed
                ));
            }

            update accountsToUpdate;
        }
    }

        @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
        return OpportunityFactory.getOpportunities();
    }
    
    @AuraEnabled
    public static void saveOpportunities(List<Opportunity> opportunities) {
        update opportunities;
    }
}


