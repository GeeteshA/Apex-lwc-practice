trigger TaskTrigger on Task (after insert) {
    TaskTriggerHandler.onAfterInsert(Trigger.new);
}

