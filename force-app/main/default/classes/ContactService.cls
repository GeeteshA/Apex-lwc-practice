public with sharing class ContactService {
    // Updates contact counts on Accounts
    // Scenario: Maintain Number_of_Contacts__c field
    public static void updateContactCounts(List<Contact> contacts) {
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : contacts) {
            if(con.AccountId != null) accountIds.add(con.AccountId);
        }
        if(accountIds.isEmpty()) return;
        
        Map<Id, Integer> counts = ContactFactory.getContactCountsByAccountIds(accountIds);
        
        // Update Accounts
        List<Account> accountsToUpdate = new List<Account>();
        for(Id accountId : counts.keySet()) {
            accountsToUpdate.add(new Account(
                Id = accountId,
                Number_of_Contacts__c = counts.get(accountId) // Update the custom field
            ));
        }
        update accountsToUpdate;
    }
}