public class AccountTriggerHandler {
    public static void handleAfterInsert(List<Account> newAccounts) {
        List<Contact> contactList = new List<Contact>();

        for (Account account : newAccounts) {
            if (account.Name != null) {
                Contact newContact = new Contact(
                    LastName = account.Name,
                    AccountId = account.Id
                );
                contactList.add(newContact);
            }
        }

        if (!contactList.isEmpty()) {
            insert contactList;
        }
    }
}
