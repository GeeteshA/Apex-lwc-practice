public with sharing class OpportunityTriggerHandler {
    // recursion prevention
    private static Boolean alreadyProcessed = false;
    
    public static void onAfterInsert(List<Opportunity> newOpps) {
        if (!alreadyProcessed) {
            alreadyProcessed = true;
            OpportunityService.syncStageToAccount(newOpps);
        }
    }

    public static void onAfterUpdate(List<Opportunity> updatedOpps) {
        if (!alreadyProcessed) {
            alreadyProcessed = true;
            OpportunityService.syncStageToAccount(updatedOpps);
        }
    }
}
