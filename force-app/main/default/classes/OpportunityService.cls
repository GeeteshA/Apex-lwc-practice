public with sharing class OpportunityService {
    // Syncs latest closed stage to Account

    public static void syncStageToAccount(List<Opportunity> opps) {
        Set<Id> accountIds = new Set<Id>();

        for(Opportunity opp : opps) {
            if((opp.StageName == 'Closed Won' || opp.StageName == 'Closed Lost') && opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        if(accountIds.isEmpty()) return;
        
        Map<Id, Date> maxDates = OpportunityFactory.getLatestClosedDates(accountIds);
        
        List<Opportunity> latestOpps = OpportunityFactory.getOpportunitiesByCloseDates(accountIds, maxDates);
        
        
        List<Account> accountsToUpdate = new List<Account>();
        for(Opportunity opp : latestOpps) {
            accountsToUpdate.add(new Account(
                Id = opp.AccountId,
                Last_Closed_Opportunity_Stage__c = opp.StageName  
            ));
        }
        update accountsToUpdate;
    }
}