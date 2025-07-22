trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    if (Trigger.isInsert) {
        ClosedOpportunityTriggerHandler.onAfterInsert(Trigger.new);
    }
    if (Trigger.isUpdate) {
        ClosedOpportunityTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}
