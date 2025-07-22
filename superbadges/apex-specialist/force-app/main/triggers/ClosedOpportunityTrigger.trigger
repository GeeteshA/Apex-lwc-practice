trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    OpportunityTriggerHandler.handleAfterInsertUpdate(Trigger.new, Trigger.oldMap, Trigger.isInsert);
}
