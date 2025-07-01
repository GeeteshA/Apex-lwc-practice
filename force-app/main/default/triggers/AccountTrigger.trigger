// Trigger to auto-create a Contact when an Account is created
trigger AccountTrigger on Account (after insert) {

    // Create a list to hold new Contacts
    List<Contact> contactList = new List<Contact>();

    // Loop through each new Account
    for (Account account : Trigger.new) {
        // Create a new Contact with LastName same as Account Name
        Contact newContact = new Contact();
        newContact.LastName = account.Name;
        newContact.AccountId = account.Id;

        contactList.add(newContact);
    }

    if (!contactList.isEmpty()) {
        insert contactList;
    }
}
