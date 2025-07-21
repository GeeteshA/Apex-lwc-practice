@IsTest
private class ContactTriggerHandlerTest {
    @TestSetup
    static void setup() {
        // Create accounts with different initial counts
        Account acc1 = new Account(Name = 'Account 1', Number_of_Contacts__c = 0);
        Account acc2 = new Account(Name = 'Account 2', Number_of_Contacts__c = 5);
        insert new List<Account>{acc1, acc2};
    }
    
    @IsTest
    static void testContactCountInVariousScenarios() {
        Account acc1 = [SELECT Id FROM Account WHERE Name = 'Account 1'];
        Account acc2 = [SELECT Id FROM Account WHERE Name = 'Account 2'];
        
        // Test insert
        Contact con1 = new Contact(LastName = 'Test 1', AccountId = acc1.Id);
        Contact con2 = new Contact(LastName = 'Test 2', AccountId = acc2.Id);
        
        Test.startTest();
        insert new List<Contact>{con1, con2};
        Test.stopTest();
        
        // Verify counts
        Account updatedAcc1 = [SELECT Number_of_Contacts__c FROM Account WHERE Id = :acc1.Id];
        Account updatedAcc2 = [SELECT Number_of_Contacts__c FROM Account WHERE Id = :acc2.Id];
        System.assertEquals(1, updatedAcc1.Number_of_Contacts__c, 'Account 1 should have 1 contact');
        System.assertEquals(6, updatedAcc2.Number_of_Contacts__c, 'Account 2 should have 6 contacts');
    }
    
    @IsTest
    static void testContactWithoutAccount() {
        Contact con = new Contact(LastName = 'No Account');
        
        Test.startTest();
        insert con;
        Test.stopTest();
        
        // Verify no errors and no account updates
        System.assertEquals(0, [SELECT COUNT() FROM Account WHERE Number_of_Contacts__c != 0 AND Number_of_Contacts__c != 5],
            'No account counts should change for contact without account');
    }
}