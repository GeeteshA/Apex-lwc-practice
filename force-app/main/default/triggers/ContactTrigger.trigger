trigger ContactTrigger on Contact (
    after insert, 
    after update, 
    after delete, 
    after undelete
) {
    if (Trigger.isAfter) {
        ContactTriggerHandler.updateContactCount(
            Trigger.isDelete ? Trigger.old : Trigger.new,
            Trigger.isInsert,
            Trigger.isDelete,
            Trigger.isUndelete
        );
    }
}

