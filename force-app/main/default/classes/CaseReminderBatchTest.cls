@IsTest
private class CaseReminderBatchTest {
    @TestSetup
    static void setupTestData() {
        
        Profile stdProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            Alias = 'testusr',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'TestUser',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = stdProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'testuser@example.com.testclass'
        );
        insert testUser;

        
        EmailTemplate template = new EmailTemplate(
            DeveloperName = 'Case_Reminder',
            Name = 'Case Reminder',
            FolderId = UserInfo.getUserId(),
            TemplateType = 'text',
            Subject = 'Reminder',
            Body = 'Test'
        );
        insert template;

        
        System.runAs(testUser) {
            Case newCase = new Case(
                Subject = 'New Case', 
                Status = 'New'
            );
            
            Case staleCase = new Case(
                Subject = 'Stale Case', 
                Status = 'New'
            );
            insert new List<Case>{newCase, staleCase};
            
            
            Test.setCreatedDate(staleCase.Id, DateTime.now().addDays(-8));
        }
    }

    @IsTest
    static void testCaseReminderEmails() {
        
        Case staleCase = [SELECT Id FROM Case WHERE Subject = 'Stale Case' LIMIT 1];

        Test.startTest();
        Database.executeBatch(new CaseReminderBatch());
        Test.stopTest();

        
        System.assertEquals(1, Limits.getEmailInvocations(), 'Should send 1 email for stale case');
    }

    @IsTest
    static void testNoEmailForNewCases() {
        
        Case newCase = [SELECT Id FROM Case WHERE Subject = 'New Case' LIMIT 1];

        Test.startTest();
        Database.executeBatch(new CaseReminderBatch());
        Test.stopTest();

        
        System.assertEquals(0, Limits.getEmailInvocations(), 'Should not send email for new case');
    }
}