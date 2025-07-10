public with sharing class AccountService {
    public static void createContactsForAccounts(List<Account> accounts) {
        // Scenario : 1 Create Contacts for Accounts
        List<Contact> contacts = new List<Contact>();
        for(Account account : accounts) {
            contacts.add(new Contact(
                LastName = account.Name,
                AccountId = account.Id
            ));
        }
        insert contacts;
    }
    // Batch: Mark accounts as inactive
    public static void markAccountsInactive(List<Account> accounts) {
        List<Account> toUpdate = new List<Account>();
        for (Account acc : accounts) {
            toUpdate.add(new Account(
                Id = acc.Id,
                Inactive__c = true // Now valid after field creation
            ));
        }
        update toUpdate;
    }
    // LWC 
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return AccountFactory.getAccounts();
    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(Id accountId) {
        return AccountFactory.getContactsByAccountId(accountId);
    }
}