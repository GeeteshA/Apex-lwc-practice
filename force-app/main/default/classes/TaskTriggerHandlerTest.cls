@IsTest
private class TaskTriggerHandlerTest {
    @TestSetup
    static void setup() {
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
    }
    
    @IsTest
    static void testEscalationCaseCreation() {
        Account testAcc = [SELECT Id FROM Account LIMIT 1];
        
        // Test both with and without WhatId
        Task escalationTaskWithWhatId = new Task(
            Subject = 'Escalation',
            Priority = 'High',
            WhatId = testAcc.Id
        );
        
        Task escalationTaskWithoutWhatId = new Task(
            Subject = 'Escalation',
            Priority = 'High'
        );
        
        Test.startTest();
        insert new List<Task>{escalationTaskWithWhatId, escalationTaskWithoutWhatId};
        Test.stopTest();
        
        // Verify cases were created
        List<Case> createdCases = [SELECT Subject, ParentId FROM Case ORDER BY CreatedDate];
        System.assertEquals(2, createdCases.size(), 'Should create two cases');
        
        // Verify first case is linked to account
        System.assertEquals(testAcc.Id, createdCases[0].ParentId, 
            'Case should be linked to the task\'s WhatId');
            
        
        // Verify tasks were marked as escalated
        List<Task> tasks = [SELECT Escalated_Task__c FROM Task];
        for(Task t : tasks) {
            System.assertEquals(true, t.Escalated_Task__c, 'Task should be marked as escalated');
        }
    }
    
    @IsTest
    static void testNonEscalationTaskNoCase() {
        Task normalTask = new Task(
            Subject = 'Normal Task',
            Priority = 'Normal'
        );
        
        Test.startTest();
        insert normalTask;
        Test.stopTest();
        
        System.assertEquals(0, [SELECT COUNT() FROM Case], 'No case should be created');
    }
}