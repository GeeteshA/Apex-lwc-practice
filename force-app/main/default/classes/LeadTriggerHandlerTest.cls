@IsTest
private class LeadTriggerHandlerTest {
    @TestSetup
    static void setup() {
        // Create existing leads with various email patterns
        List<Lead> existingLeads = new List<Lead>{
            new Lead(LastName = 'Existing 1', Email = 'test1@example.com', Company = 'Test'),
            new Lead(LastName = 'Existing 2', Email = 'TEST2@example.com', Company = 'Test'), 
            new Lead(LastName = 'Existing 3', Email = ' test3@example.com ', Company = 'Test')
        };
        insert existingLeads;
    }
    
    @IsTest
    static void testDuplicateEmailVariations() {
        
        Lead duplicate1 = new Lead(LastName = 'Dup 1', Email = 'test1@example.com', Company = 'Test');
        Lead duplicate2 = new Lead(LastName = 'Dup 2', Email = 'TEST1@EXAMPLE.COM', Company = 'Test'); 
        Lead duplicate3 = new Lead(LastName = 'Dup 3', Email = ' test1@example.com ', Company = 'Test');
        
        Test.startTest();
        Database.SaveResult[] results = Database.insert(new List<Lead>{duplicate1, duplicate2, duplicate3}, false);
        Test.stopTest();
        
        
        for(Database.SaveResult sr : results) {
            System.assert(!sr.isSuccess(), 'Duplicate lead should be blocked');
            System.assertEquals('A Lead with this email already exists.', 
                sr.getErrors()[0].getMessage());
        }
    }
    
    @IsTest
    static void testValidNewLeads() {
        // Test new emails that should pass
        Lead valid1 = new Lead(LastName = 'Valid 1', Email = 'new1@example.com', Company = 'Test');
        Lead valid2 = new Lead(LastName = 'Valid 2', Email = 'new2@example.com', Company = 'Test');
        
        Test.startTest();
        Database.SaveResult[] results = Database.insert(new List<Lead>{valid1, valid2}, false);
        Test.stopTest();
        
        // Both should succeed
        for(Database.SaveResult sr : results) {
            System.assert(sr.isSuccess(), 'New lead should be created');
        }
        
        System.assertEquals(2, [SELECT COUNT() FROM Lead WHERE Email LIKE 'new%@example.com'],
            'Should create both new leads');
    }
}