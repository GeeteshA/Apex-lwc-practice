@IsTest
private class InactiveAccountBatchTest {
    @TestSetup
    static void setup() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Active 1', Last_Modified_Custom__c = Date.today().addMonths(-1), Inactive__c = false),
            new Account(Name = 'Active 2', Last_Modified_Custom__c = Date.today().addDays(-10), Inactive__c = false),
            new Account(Name = 'Inactive 1', Last_Modified_Custom__c = Date.today().addYears(-3), Inactive__c = false),
            new Account(Name = 'Inactive 2', Last_Modified_Custom__c = Date.today().addDays(-800), Inactive__c = false),
            new Account(Name = 'Already Inactive', Last_Modified_Custom__c = Date.today().addYears(-5), Inactive__c = true)
        };
        insert accounts;
    }
    
    @IsTest
    static void testBatchMarkingLogic() {
        Test.startTest();
        Database.executeBatch(new InactiveAccountBatch(), 200);
        Test.stopTest();
        
        // Verify results
        Map<String, Account> accountsByName = new Map<String, Account>();
        for(Account a : [SELECT Name, Inactive__c FROM Account]) {
            accountsByName.put(a.Name, a);
        }
        
        // Active accounts should remain active
        System.assertEquals(false, accountsByName.get('Active 1').Inactive__c);
        System.assertEquals(false, accountsByName.get('Active 2').Inactive__c);
        
        // Inactive accounts should be marked
        System.assertEquals(true, accountsByName.get('Inactive 1').Inactive__c);
        System.assertEquals(true, accountsByName.get('Inactive 2').Inactive__c);
        
        // Already inactive should remain unchanged
        System.assertEquals(true, accountsByName.get('Already Inactive').Inactive__c);
    }
    
    @IsTest
    static void testBatchScopeSize() {
        Test.startTest();
        Database.executeBatch(new InactiveAccountBatch(), 1); 
        Test.stopTest();
        
        System.assertEquals(2, [SELECT COUNT() FROM Account WHERE Inactive__c = true AND Name LIKE 'Inactive%'],
            'Should mark all inactive accounts regardless of batch size');
    }
}