public with sharing class OpportunityService {
    // Constants
    private static final String STAGE_CLOSED_WON = 'Closed Won';
    private static final String STAGE_CLOSED_LOST = 'Closed Lost';
    private static final String SUCCESS_MESSAGE = 'Opportunities updated successfully';

    public static void syncStageToAccount(List<Opportunity> opps, Map<Id, Opportunity> oldMap) {
        Set<Id> accountIds = new Set<Id>();
        Set<Id> reopenedAccountIds = new Set<Id>();
        
        // Identify accounts to update
        for(Opportunity opp : opps) {
            if(opp.AccountId != null) {
                // Check for closed opportunities
                if(opp.StageName == STAGE_CLOSED_WON || opp.StageName == STAGE_CLOSED_LOST) {
                    accountIds.add(opp.AccountId);
                }
                // Check for reopened opportunities
                else if(oldMap != null && 
                        (oldMap.get(opp.Id).StageName == STAGE_CLOSED_WON || 
                         oldMap.get(opp.Id).StageName == STAGE_CLOSED_LOST)) {
                    reopenedAccountIds.add(opp.AccountId);
                }
            }
        }
        
        // Process closed opportunities
        if(!accountIds.isEmpty()) {
            List<AggregateResult> aggResults = OpportunityFactory.getClosedOpportunityDates(accountIds);
            Map<Id, Date> maxDates = new Map<Id, Date>();
            for(AggregateResult ar : aggResults) {
                maxDates.put((Id)ar.get('AccountId'), (Date)ar.get('maxDate'));
            }
            
            List<Opportunity> latestOpps = OpportunityFactory.getOpportunitiesByCloseDates(
                accountIds, 
                new Set<Date>(maxDates.values())
            );
            
            List<Account> accountsToUpdate = new List<Account>();
            for(Opportunity opp : latestOpps) {
                accountsToUpdate.add(new Account(
                    Id = opp.AccountId,
                    Last_Closed_Opportunity_Stage__c = opp.StageName  
                ));
            }
            update accountsToUpdate;
        }
        
        // Clear field for reopened opportunities
        if(!reopenedAccountIds.isEmpty()) {
            List<Account> accountsToClear = new List<Account>();
            for(Id accId : reopenedAccountIds) {
                accountsToClear.add(new Account(
                    Id = accId,
                    Last_Closed_Opportunity_Stage__c = null
                ));
            }
            update accountsToClear;
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


// public with sharing class OpportunityService {

//     private static final String STAGE_CLOSED_WON = 'Closed Won';
//     private static final String STAGE_CLOSED_LOST = 'Closed Lost';
//     private static final String SUCCESS_MESSAGE = 'Opportunities updated successfully';

//     public static void syncStageToAccount(List<Opportunity> opps) {
//         Set<Id> accountIds = new Set<Id>();
//         for(Opportunity opp : opps) {
//             if((opp.StageName == STAGE_CLOSED_WON || opp.StageName == STAGE_CLOSED_LOST) && 
//                opp.AccountId != null) {
//                 accountIds.add(opp.AccountId);
//             }
//         }
//         if(accountIds.isEmpty()) return;
        
//         // Changed to match factory method
//         List<AggregateResult> aggResults = OpportunityFactory.getClosedOpportunityDates(accountIds);
//         Map<Id, Date> maxDates = new Map<Id, Date>();
//         for(AggregateResult ar : aggResults) {
//             maxDates.put((Id)ar.get('AccountId'), (Date)ar.get('maxDate'));
//         }
        
//         // Changed to match factory method
//         List<Opportunity> latestOpps = OpportunityFactory.getOpportunitiesByCloseDates(
//             accountIds, 
//             new Set<Date>(maxDates.values()) // Convert to Set
//         );
        
//         // Update accounts
//         List<Account> accountsToUpdate = new List<Account>();
//         for(Opportunity opp : latestOpps) {
//             accountsToUpdate.add(new Account(
//                 Id = opp.AccountId,
//                 Last_Closed_Opportunity_Stage__c = opp.StageName  
//             ));
//         }
//         update accountsToUpdate;
//     }

//     @AuraEnabled(cacheable=true)
//     public static List<Opportunity> getOpportunities() {
//         return OpportunityFactory.getOpportunities();
//     }
    
//     @AuraEnabled
//     public static void saveOpportunities(List<Opportunity> opportunities) {
//         update opportunities;
//     }
// }