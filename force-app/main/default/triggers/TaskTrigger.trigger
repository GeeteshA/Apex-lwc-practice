trigger TaskTrigger on Task (after insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        TaskTriggerHandler.handleEscalationTasks(Trigger.new);
    }
}
