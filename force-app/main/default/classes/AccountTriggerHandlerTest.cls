@IsTest
private class AccountTriggerHandlerTest {
    @TestSetup
    static void makeData() {
        List<Account> accounts = new List<Account>();
        for(Integer i = 1; i <= 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
    }
    
    @IsTest
    static void shouldCreateContactForEachAccount() {
        // Query accounts WITH the Name field
        List<Account> accounts = [SELECT Id, Name FROM Account];
        
        Test.startTest();
        // Trigger already fired in setup, so we need to query contacts
        Test.stopTest();
        
        // Query contacts and related account names
        List<Contact> contacts = [SELECT Id, AccountId, LastName, 
                                 Account.Name FROM Contact 
                                 WHERE AccountId IN :accounts];
        
        System.assertEquals(accounts.size(), contacts.size(), 
            'Number of contacts should match number of accounts');
        
        // Create map for easier verification
        Map<Id, Account> accountMap = new Map<Id, Account>(accounts);
        
        for(Contact c : contacts) {
            System.assertEquals(accountMap.get(c.AccountId).Name, c.LastName,
                'Contact last name should match account name');
        }
    }
}