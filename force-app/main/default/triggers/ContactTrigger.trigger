trigger ContactTrigger on Contact (after insert, after delete, after undelete) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) ContactTriggerHandler.onAfterInsert(Trigger.new);
        if(Trigger.isDelete) ContactTriggerHandler.onAfterDelete(Trigger.old);
        if(Trigger.isUndelete) ContactTriggerHandler.onAfterUndelete(Trigger.new);
    }
}


