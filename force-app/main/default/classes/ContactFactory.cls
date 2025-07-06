public with sharing class ContactFactory {
    public static Map<Id, Integer> getContactCountsByAccountIds(Set<Id> accountIds) {
        Map<Id, Integer> counts = new Map<Id, Integer>();
        for(Id accId : accountIds) counts.put(accId, 0);
        
        for(AggregateResult ar : [
            SELECT AccountId, COUNT(Id) total 
            FROM Contact 
            WHERE AccountId IN :accountIds 
            GROUP BY AccountId
        ]) {
            counts.put((Id)ar.get('AccountId'), (Integer)ar.get('total'));
        }
        return counts;
    }
}

