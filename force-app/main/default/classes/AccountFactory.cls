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
}