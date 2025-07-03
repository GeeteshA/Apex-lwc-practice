public with sharing class AccountContactController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name FROM Account];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByAccount(Id accountId) {
        return [
            SELECT Id, FirstName, LastName, Email, Phone
            FROM Contact
            WHERE AccountId = :accountId
        ];
    }
}
