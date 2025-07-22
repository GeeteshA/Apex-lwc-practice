trigger RestrictContactByName on Contact (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            RestrictContactByNameHandler.validateRestrictedNames(Trigger.new);
        }
    }
}
