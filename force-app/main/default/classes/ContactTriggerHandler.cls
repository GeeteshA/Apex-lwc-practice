public with sharing class ContactTriggerHandler {
    private static Boolean isAlreadyProcessed = false;
    
    public static void onAfterInsert(List<Contact> newContacts) {
        if(!isAlreadyProcessed) {
            isAlreadyProcessed = true;
            ContactService.updateContactCounts(newContacts);
        }
    }
    
    public static void onAfterDelete(List<Contact> deletedContacts) {
        if(!isAlreadyProcessed) {
            isAlreadyProcessed = true;
            ContactService.updateContactCounts(deletedContacts);
        }
    }
    
    public static void onAfterUndelete(List<Contact> undeletedContacts) {
        if(!isAlreadyProcessed) {
            isAlreadyProcessed = true;
            ContactService.updateContactCounts(undeletedContacts);
        }
    }
}
// public with sharing class ContactTriggerHandler {
//     // Handles contact insert event
//     public static void onAfterInsert(List<Contact> newContacts) {
//         ContactService.updateContactCounts(newContacts);
//     }
//     // Handles contact delete event
//     public static void onAfterDelete(List<Contact> deletedContacts) {
//         ContactService.updateContactCounts(deletedContacts);
//     }
//     // Handles contact undelete event
//     public static void onAfterUndelete(List<Contact> undeletedContacts) {
//         ContactService.updateContactCounts(undeletedContacts);
//     }
// }

