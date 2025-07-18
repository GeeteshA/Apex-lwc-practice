@IsTest
private class ContactTriggerHandlerTest {
    @TestSetup
    static void setup() {
        // Initialize account with explicit 0 count
        Account acc = new Account(
            Name = 'Test Account',
            Number_of_Contacts__c = 0 // Explicitly set to 0
        );
        insert acc;
    }

    @IsTest
    static void testSingleContactInsert() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        // Verify initial count
        System.assertEquals(0, [SELECT Number_of_Contacts__c FROM Account WHERE Id = :acc.Id].Number_of_Contacts__c,
            'Initial count should be 0');
        
        Test.startTest();
        Contact con = new Contact(
            LastName = 'Test',
            AccountId = acc.Id
        );
        insert con;
        Test.stopTest();
        
        // Verify count after insert
        System.assertEquals(1, [SELECT Number_of_Contacts__c FROM Account WHERE Id = :acc.Id].Number_of_Contacts__c,
            'Should be 1 after inserting one contact');
    }

    @IsTest
    static void testDeleteUndeleteFlow() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Contact con = new Contact(LastName = 'Test', AccountId = acc.Id);
        insert con;
        
        Test.startTest();
        delete con;
        undelete con;
        Test.stopTest();
        
        System.assertEquals(1, [SELECT Number_of_Contacts__c FROM Account WHERE Id = :acc.Id].Number_of_Contacts__c,
            'Should be 1 after undelete');
    }
}