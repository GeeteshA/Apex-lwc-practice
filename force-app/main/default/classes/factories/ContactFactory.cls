public class ContactFactory {
    public static Map<Id, Integer> getContactCountsByAccountIds(Set<Id> accountIds) {
        Map<Id, Integer> contactCounts = new Map<Id, Integer>();
        
        // staet all account with 0 counts
        for (Id accountId : accountIds) {
            contactCounts.put(accountId, 0);
        }
        
        // Getting counts from database
        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) total
            FROM Contact
            WHERE AccountId IN :accountIds
            AND IsDeleted = false // Exclude deleted contacts in recycle bin
            GROUP BY AccountId
        ]) {
            contactCounts.put((Id)ar.get('AccountId'), (Integer)ar.get('total'));
        }
        
        return contactCounts;
    }
}
