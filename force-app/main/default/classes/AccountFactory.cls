public with sharing class AccountFactory {
    public static List<Account> getAccounts() {
        return [
            SELECT Id, Name, Industry, Phone 
            FROM Account 
            ORDER BY LastModifiedDate DESC 
            LIMIT 50
        ];
    }

    public static List<Contact> getContactsByAccountId(Id accountId) {
        return [
            SELECT Id, Name, Email, Phone, Title, Account.Name, CreatedDate 
            FROM Contact 
            WHERE AccountId = :accountId 
            ORDER BY Name
        ];
    }
    
    public static List<AggregateResult> getContactCounts(Set<Id> accountIds) {
        return [
            SELECT AccountId, COUNT(Id) total 
            FROM Contact 
            WHERE AccountId IN :accountIds 
            GROUP BY AccountId
        ];
    }
    

    // For Batch: Returns QueryLocator
    public static Database.QueryLocator getInactiveAccountsQueryLocator(Date cutoffDate) {
        System.debug('🔍 Cutoff date used: ' + cutoffDate);
        return Database.getQueryLocator([
            SELECT Id, Name, Last_Modified_Custom__c, Inactive__c
            FROM Account
            WHERE Last_Modified_Custom__c <= :cutoffDate
            AND Inactive__c = false
        ]);
    }

}