// public with sharing class ContactService {
//     // Constants
//     private static final String CONTACT_COUNT_FIELD = 'Number_of_Contacts__c';

//     public static void updateContactCounts(List<Contact> contacts) {
//         Set<Id> accountIds = new Set<Id>();
//         for(Contact con : contacts) {
//             if(con.AccountId != null) accountIds.add(con.AccountId);
//         }
//         if(accountIds.isEmpty()) return;
        
//         // Get contact counts
//         List<AggregateResult> aggResults = ContactFactory.getContactCountsByAccountIds(accountIds);
//         Map<Id, Integer> counts = new Map<Id, Integer>();
//         for(Id accId : accountIds) counts.put(accId, 0);
//         for(AggregateResult ar : aggResults) {
//             counts.put((Id)ar.get('AccountId'), (Integer)ar.get('total'));
//         }
        
//         // Update accounts
//         List<Account> accountsToUpdate = new List<Account>();
//         for(Id accountId : counts.keySet()) {
//             accountsToUpdate.add(new Account(
//                 Id = accountId,
//                 Number_of_Contacts__c = counts.get(accountId)
//             ));
//         }
//         update accountsToUpdate;
//     }
// }
public with sharing class ContactService {
    private static final String CONTACT_COUNT_FIELD = 'Number_of_Contacts__c';

    public static void updateContactCounts(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : contacts) {
            if(con.AccountId != null) accountIds.add(con.AccountId);
        }
        if(accountIds.isEmpty()) return;
        
        // Get counts from Factory
        Map<Id, Integer> accountToCount = getCurrentCounts(accountIds);
        
        // Update accounts
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accountId : accountIds) {
            accountsToUpdate.add(new Account(
                Id = accountId,
                Number_of_Contacts__c = accountToCount.getOrDefault(accountId, 0)
            ));
        }
        
        if(!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
    private static Map<Id, Integer> getCurrentCounts(Set<Id> accountIds) {
        Map<Id, Integer> counts = new Map<Id, Integer>();
        for(AggregateResult ar : ContactFactory.getContactCountsByAccountIds(accountIds)) {
            counts.put((Id)ar.get('AccountId'), (Integer)ar.get('total'));
        }
        return counts;
    }
}