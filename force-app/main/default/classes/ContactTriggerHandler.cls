public with sharing class ContactTriggerHandler {
    // Handles contact insert event
    public static void onAfterInsert(List<Contact> newContacts) {
        ContactService.updateContactCounts(newContacts);
    }
    // Handles contact delete event
    public static void onAfterDelete(List<Contact> deletedContacts) {
        ContactService.updateContactCounts(deletedContacts);
    }
    // Handles contact undelete event
    public static void onAfterUndelete(List<Contact> undeletedContacts) {
        ContactService.updateContactCounts(undeletedContacts);
    }
}

