@IsTest
private class CaseReminderBatchTest {
    @IsTest
    static void testCaseReminderEmails() {
        // Create test cases
        Case newCase = new Case(Subject = 'New Case', Status = 'New'); // Recent case
        Case staleCase = new Case(Subject = 'Stale Case', Status = 'New'); // Old case
        insert new List<Case>{newCase, staleCase};
        
        // Set created date for stale case (7+ days old)
        Test.setCreatedDate(staleCase.Id, DateTime.now().addDays(-8));
        
        // Create email template
        EmailTemplate template = new EmailTemplate(
            DeveloperName = 'Case_Reminder',
            Name = 'Case Reminder',
            FolderId = UserInfo.getUserId(),
            TemplateType = 'text',
            Subject = 'Reminder',
            Body = 'Test'
        );
        insert template;

        Test.startTest();
        Database.executeBatch(new CaseReminderBatch());
        Test.stopTest();

        // Verify only stale case triggered email
        System.assertEquals(1, Limits.getEmailInvocations(), 'Should send 1 email for stale case');
    }
}