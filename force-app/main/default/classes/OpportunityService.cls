public with sharing class OpportunityService {

    private static final String STAGE_CLOSED_WON = 'Closed Won';
    private static final String STAGE_CLOSED_LOST = 'Closed Lost';
    private static final String SUCCESS_MESSAGE = 'Opportunities updated successfully';

    public static void syncStageToAccount(List<Opportunity> opps) {
        Set<Id> accountIds = new Set<Id>();
        for(Opportunity opp : opps) {
            if((opp.StageName == STAGE_CLOSED_WON || opp.StageName == STAGE_CLOSED_LOST) && 
               opp.AccountId != null) {
                accountIds.add(opp.AccountId);
            }
        }
        if(accountIds.isEmpty()) return;
        
        // Changed to match factory method
        List<AggregateResult> aggResults = OpportunityFactory.getClosedOpportunityDates(accountIds);
        Map<Id, Date> maxDates = new Map<Id, Date>();
        for(AggregateResult ar : aggResults) {
            maxDates.put((Id)ar.get('AccountId'), (Date)ar.get('maxDate'));
        }
        
        // Changed to match factory method
        List<Opportunity> latestOpps = OpportunityFactory.getOpportunitiesByCloseDates(
            accountIds, 
            new Set<Date>(maxDates.values()) // Convert to Set
        );
        
        // Update accounts
        List<Account> accountsToUpdate = new List<Account>();
        for(Opportunity opp : latestOpps) {
            accountsToUpdate.add(new Account(
                Id = opp.AccountId,
                Last_Closed_Opportunity_Stage__c = opp.StageName  
            ));
        }
        update accountsToUpdate;
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