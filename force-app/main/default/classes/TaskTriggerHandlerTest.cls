@IsTest
private class TaskTriggerHandlerTest {
    @IsTest
    static void testEscalationCase() {
        // Create escalation task
        Task escalationTask = new Task(
            Subject = 'Escalation',
            Priority = 'High'
        );
        
        Test.startTest();
        insert escalationTask;
        Test.stopTest();
        
        // Verify case was created
        Case createdCase = [SELECT Subject FROM Case LIMIT 1];
        System.assertEquals('Auto-created from High Priority Escalation Task', createdCase.Subject);
    }
}