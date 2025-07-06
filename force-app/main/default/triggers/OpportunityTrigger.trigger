trigger OpportunityTrigger on Opportunity (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) OpportunityTriggerHandler.onAfterInsert(Trigger.new);
        if(Trigger.isUpdate) OpportunityTriggerHandler.onAfterUpdate(Trigger.new, Trigger.oldMap);
    }
}

