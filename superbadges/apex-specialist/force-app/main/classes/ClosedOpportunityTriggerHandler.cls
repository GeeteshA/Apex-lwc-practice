public with sharing class ClosedOpportunityTriggerHandler {
    public static void onAfterInsert(List<Opportunity> newList) {
        ClosedOpportunityService.createFollowUpTasks(newList, null, true);
    }

    public static void onAfterUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap) {
        ClosedOpportunityService.createFollowUpTasks(newList, oldMap, false);
    }
}
