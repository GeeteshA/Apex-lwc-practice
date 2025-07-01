public class ContactTriggerHandler {
    public static void updateContactCountOnAccount(
        List<Contact> newList,
        List<Contact> oldList,
        Boolean isInsert,
        Boolean isDelete,
        Boolean isUndelete
    ) {
        Set<Id> accountIds = new Set<Id>();

        // Collect AccountIds from Trigger.new and Trigger.old
        if (isInsert || isUndelete) {
            for (Contact c : newList) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }
        }

        if (isDelete) {
            for (Contact c : oldList) {
                if (c.AccountId != null) {
                    accountIds.add(c.AccountId);
                }
            }
        }

        if (accountIds.isEmpty()) return;

        // Query contact counts for affected accounts
        List<AggregateResult> contactCounts = [
            SELECT AccountId, COUNT(Id) total
            FROM Contact
            WHERE AccountId IN :accountIds
            GROUP BY AccountId
        ];

        List<Account> accountsToUpdate = new List<Account>();

        for (AggregateResult result : contactCounts) {
            Account acc = new Account(
                Id = (Id) result.get('AccountId'),
                Number_of_Contacts__c = (Integer) result.get('total')
            );
            accountsToUpdate.add(acc);
        }

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}
