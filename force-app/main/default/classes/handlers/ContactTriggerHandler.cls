public class ContactTriggerHandler {
    public static void updateContactCount(
        List<Contact> contacts, 
        Boolean isInsert,
        Boolean isDelete,
        Boolean isUndelete
    ) {
        Set<Id> accountIds = new Set<Id>();
        
        for (Contact con : contacts) {
            if (con.AccountId != null) {
                accountIds.add(con.AccountId);
            }
        }
        
        if (accountIds.isEmpty()) return;
        
        Map<Id, Integer> contactCounts = ContactFactory.getContactCountsByAccountIds(accountIds);
        
        List<Account> accountsToUpdate = new List<Account>();
        for (Id accountId : contactCounts.keySet()) {
            accountsToUpdate.add(new Account(
                Id = accountId,
                Number_of_Contacts__c = contactCounts.get(accountId)
            ));
        }
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}


