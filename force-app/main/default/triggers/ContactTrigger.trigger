// Trigger to update Number_of_Contacts__c on Account when a Contact is inserted, deleted, or undeleted
trigger ContactTrigger on Contact (after insert, after delete, after undelete) {

    // Set to store all affected Account IDs
    Set<Id> accountIds = new Set<Id>();

    // For Insert and Undelete, use Trigger.new
    if (Trigger.isInsert || Trigger.isUndelete) {
        for (Contact contactRecord : Trigger.new) {
            if (contactRecord.AccountId != null) {
                accountIds.add(contactRecord.AccountId);
            }
        }
    }

    // For Delete, use Trigger.old
    if (Trigger.isDelete) {
        for (Contact contactRecord : Trigger.old) {
            if (contactRecord.AccountId != null) {
                accountIds.add(contactRecord.AccountId);
            }
        }
    }

    // Prepare list to update affected Accounts
    List<Account> accountsToUpdate = new List<Account>();

    // Aggregate count of contacts for each Account
    for (AggregateResult result : [
        SELECT AccountId, COUNT(Id) total
        FROM Contact
        WHERE AccountId IN :accountIds
        GROUP BY AccountId
    ]) {
        Id accId = (Id) result.get('AccountId');
        Integer totalContacts = (Integer) result.get('total');

        Account acc = new Account(
            Id = accId,
            Number_of_Contacts__c = totalContacts
        );
        accountsToUpdate.add(acc);
    }

    // Update all affected accounts
    if (!accountsToUpdate.isEmpty()) {
        update accountsToUpdate;
    }
}
