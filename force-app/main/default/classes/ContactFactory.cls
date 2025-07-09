public with sharing class ContactFactory {
    public static List<AggregateResult> getContactCountsByAccountIds(Set<Id> accountIds) {
        return [
            SELECT AccountId, COUNT(Id) total 
            FROM Contact 
            WHERE AccountId IN :accountIds 
            GROUP BY AccountId
        ];
    }
}