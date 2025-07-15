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
//     // Batch: Mark accounts as inactive
//  public static void markAccountsInactive(List<Account> accounts) {
//         for (Account acc : accounts) {
//             acc.Inactive__c = true;
//         }
//         update accounts;
//     }
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