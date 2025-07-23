trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            ClosedOpportunityTriggerHandler.onAfterInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            ClosedOpportunityTriggerHandler.onAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}
