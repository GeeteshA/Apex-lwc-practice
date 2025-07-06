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

}