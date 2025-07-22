@isTest
public class AddPrimaryContactTest {
    
    static void createTestAccounts(String stateCode, Integer count) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < count; i++) {
            accounts.add(new Account(
                Name = 'Test Account ' + i,
                BillingCountry = 'United States',        
                BillingCountryCode = 'US',
                BillingState = getStateName(stateCode),  
                BillingStateCode = stateCode
            ));
        }
        insert accounts;
    }

    // Helper method to get full state name from code
    private static String getStateName(String code) {
        Map<String, String> stateMap = new Map<String, String>{
            'CA' => 'California',
            'NY' => 'New York'
        };
        return stateMap.containsKey(code) ? stateMap.get(code) : '';
    }

    @isTest
    static void testAddPrimaryContactQueueable() {
        // Create 50 Accounts for NY and 50 for CA
        createTestAccounts('NY', 50);
        createTestAccounts('CA', 50);

        // Create the base contact to clone
        Contact baseContact = new Contact(
            FirstName = 'Primary',
            LastName = 'Contact',
            Email = 'primary@example.com'
        );

        Test.startTest();
        AddPrimaryContact job = new AddPrimaryContact(baseContact, 'CA');
        System.enqueueJob(job);
        Test.stopTest();

        // Verify that 50 Contacts were created and linked to CA accounts
        List<Contact> insertedContacts = [
            SELECT Id, AccountId, Account.BillingStateCode
            FROM Contact
            WHERE Email = 'primary@example.com'
        ];

        System.assertEquals(50, insertedContacts.size(), 'Expected 50 Contacts for CA Accounts');

        for (Contact c : insertedContacts) {
            System.assertEquals('CA', c.Account.BillingStateCode, 'Contact should be linked to a CA Account');
        }
    }
}
