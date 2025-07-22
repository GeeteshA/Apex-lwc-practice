trigger AccountAddressTrigger on Account (before insert, before update) {
    AccountAddressTriggerHandler.handleBeforeInsertUpdate(Trigger.new);
}
