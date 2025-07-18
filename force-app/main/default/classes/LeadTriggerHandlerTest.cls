@IsTest
private class LeadTriggerHandlerTest {
    @IsTest
    static void testDuplicateEmail() {
        // first lead
        Lead firstLead = new Lead(
            LastName = 'First',
            Email = 'test@example.com',
            Company = 'Test'
        );
        insert firstLead;
        
        // duplicate Lead with same email
        Lead duplicateLead = new Lead(
            LastName = 'Duplicate',
            Email = 'test@example.com',
            Company = 'Test'
        );
        
        Test.startTest();
        Database.SaveResult result = Database.insert(duplicateLead, false);
        Test.stopTest();
        
        // Verify duplicate was blocked
        System.assert(!result.isSuccess());
    }
}