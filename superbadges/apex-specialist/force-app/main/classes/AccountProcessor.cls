public class AccountProcessor {
    @future
    public static void countContacts(Set<Id> accountIds) {
        Map<Id, Integer> contactCounts = new Map<Id, Integer>();

        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) contactCount
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ]) {
            contactCounts.put((Id)ar.get('AccountId'), (Integer)ar.get('contactCount'));
        }

        List<Account> accountsToUpdate = new List<Account>();
        for (Id accId : contactCounts.keySet()) {
            accountsToUpdate.add(new Account(
                Id = accId,
                Number_Of_Contacts__c = contactCounts.get(accId)
            ));
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
