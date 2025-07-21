@IsTest
private class AccountTriggerHandlerTest {
    @TestSetup
    static void setup() {
        // Create accounts with different name patterns
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account 1'),
            new Account(Name = 'Special & Account'),
            new Account(Name = 'Account with 123 numbers')
        };
        insert accounts;
    }
    
    @IsTest
    static void testContactCreationForMultipleAccounts() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        Integer accountCount = accounts.size();
        
        Test.startTest();
        // Trigger runs in setup, verify results
        Test.stopTest();
        
        List<Contact> contacts = [SELECT Id, LastName, AccountId FROM Contact];
        System.assertEquals(accountCount, contacts.size(), 
            'Should create one contact per account');
        
        // Verify special characters are handled
        Map<Id, Account> accountMap = new Map<Id, Account>(accounts);
        for(Contact c : contacts) {
            Account acc = accountMap.get(c.AccountId);
            System.assertEquals(acc.Name, c.LastName,
                'Contact last name should exactly match account name');
        }
    }
}