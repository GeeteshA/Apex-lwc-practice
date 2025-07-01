trigger ContactTrigger on Contact (after insert, after delete, after undelete) {
    if (Trigger.isAfter && (Trigger.isInsert || Trigger.isDelete || Trigger.isUndelete)) {
        ContactTriggerHandler.updateContactCountOnAccount(Trigger.new, Trigger.old, Trigger.isInsert, Trigger.isDelete, Trigger.isUndelete);
    }
}
