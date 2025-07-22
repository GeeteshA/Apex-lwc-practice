public with sharing class OpportunityTriggerHandler {
    public static void handleAfterInsertUpdate(List<Opportunity> newList, Map<Id, Opportunity> oldMap, Boolean isInsert) {
        OpportunityService.createFollowUpTasks(newList, oldMap, isInsert);
    }
}
