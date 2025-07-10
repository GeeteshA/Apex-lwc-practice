public with sharing class OpportunityTriggerHandler {
    public static void onAfterInsert(List<Opportunity> newOpps) {
        OpportunityService.syncStageToAccount(newOpps, null);
    }
    
    public static void onAfterUpdate(List<Opportunity> updatedOpps, Map<Id, Opportunity> oldMap) {
        OpportunityService.syncStageToAccount(updatedOpps, oldMap);
    }
}
