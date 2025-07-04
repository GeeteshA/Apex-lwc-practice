public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        return [SELECT Id, Name, Industry, Phone FROM Account ORDER BY Name LIMIT 50];
    }

    @AuraEnabled
    public static List<Contact> getContacts(Id accountId) {
        return [
            SELECT Id, Name, Email, Phone, Title, Account.Name, CreatedDate
            FROM Contact 
            WHERE AccountId = :accountId
            ORDER BY Name
        ];
    }
}