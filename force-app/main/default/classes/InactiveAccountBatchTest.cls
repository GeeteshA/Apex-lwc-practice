@IsTest
private class InactiveAccountBatchTest {
    @IsTest
    static void testInactiveAccountMarking() {
        // Create test data
        Account activeAccount = new Account(
            Name = 'Active Account',
            Last_Modified_Custom__c = Date.today().addMonths(-1), // Recently modified
            Inactive__c = false
        );
        
        Account inactiveAccount = new Account(
            Name = 'Inactive Account',
            Last_Modified_Custom__c = Date.today().addYears(-3), // Old modification
            Inactive__c = false
        );
        insert new List<Account>{activeAccount, inactiveAccount};

        Test.startTest();
        Database.executeBatch(new InactiveAccountBatch());
        Test.stopTest();

        // Verify results
        Account updatedActiveAcc = [SELECT Inactive__c FROM Account WHERE Id = :activeAccount.Id];
        System.assertEquals(false, updatedActiveAcc.Inactive__c, 'Active account should remain active');

        Account updatedInactiveAcc = [SELECT Inactive__c FROM Account WHERE Id = :inactiveAccount.Id];
        System.assertEquals(true, updatedInactiveAcc.Inactive__c, 'Inactive account should be marked');
    }
}