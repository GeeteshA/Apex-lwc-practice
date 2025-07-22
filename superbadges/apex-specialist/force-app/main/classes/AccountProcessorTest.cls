@isTest
public class AccountProcessorTest {
    static List<Account> testAccounts;

    @testSetup
    static void setupTestData() {
        testAccounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Test Account 2')
        };
        insert testAccounts;

        List<Contact> contacts = new List<Contact>();
        for (Account acc : testAccounts) {
            for (Integer i = 0; i < 3; i++) {
                contacts.add(new Contact(FirstName = 'First', LastName = 'Last', AccountId = acc.Id));
            }
        }
        insert contacts;
    }

    @isTest
    static void testCountContacts() {
        Set<Id> accountIds = new Set<Id>();
        for (Account acc : [SELECT Id FROM Account]) {
            accountIds.add(acc.Id);
        }

        Test.startTest();
        AccountProcessor.countContacts(accountIds); // ✅ This must match exactly!
        Test.stopTest();

        // Verify results
        for (Account acc : [SELECT Id, Number_Of_Contacts__c FROM Account]) {
            System.assertEquals(3, acc.Number_Of_Contacts__c, 'Each account should have 3 contacts.');
        }
    }
}
