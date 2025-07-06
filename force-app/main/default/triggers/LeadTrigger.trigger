trigger LeadTrigger on Lead (before insert, before update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) LeadTriggerHandler.onBeforeInsert(Trigger.new);
        if(Trigger.isUpdate) LeadTriggerHandler.onBeforeUpdate(Trigger.new, Trigger.oldMap);
    }
}

