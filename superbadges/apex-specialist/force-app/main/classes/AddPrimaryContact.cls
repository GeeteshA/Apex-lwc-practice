public class AddPrimaryContact implements Queueable {
    private Contact contactToAdd;
    private String stateCode;

    public AddPrimaryContact(Contact contactToAdd, String stateCode) {
        this.contactToAdd = contactToAdd;
        this.stateCode = stateCode;
    }

    public void execute(QueueableContext context) {
        // Get up to 200 accounts in the given state
        List<Account> accountsInState = [
            SELECT Id, Name 
            FROM Account 
            WHERE BillingStateCode = :stateCode 
            LIMIT 200
        ];

        List<Contact> contactsToInsert = new List<Contact>();
        for (Account acc : accountsInState) {
            Contact clonedContact = contactToAdd.clone(false, true, false, false);
            clonedContact.AccountId = acc.Id;
            contactsToInsert.add(clonedContact);
        }

        if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
        }
    }
}
