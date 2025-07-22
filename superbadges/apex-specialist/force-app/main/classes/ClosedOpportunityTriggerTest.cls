@isTest
public class ClosedOpportunityTriggerTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Opportunity inserted as 'Closed Won' directly
        Opportunity opp1 = new Opportunity(
            Name = 'Opp Insert Closed Won',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 1000,
            AccountId = acc.Id
        );

        // Opportunity inserted with non-Closed stage
        Opportunity opp2 = new Opportunity(
            Name = 'Opp Insert Not Closed',
            StageName = 'Prospecting',
            CloseDate = Date.today().addDays(30),
            Amount = 1500,
            AccountId = acc.Id
        );

        insert new List<Opportunity>{ opp1, opp2 };
    }

    @isTest
    static void testInsertClosedWonCreatesTask() {
        Opportunity opp = [SELECT Id FROM Opportunity WHERE StageName = 'Closed Won' LIMIT 1];

        List<Task> tasks = [SELECT Id, WhatId FROM Task WHERE WhatId = :opp.Id];
        System.assertEquals(1, tasks.size(), 'Should create 1 Task when Opportunity is inserted as Closed Won');
        System.assertEquals(opp.Id, tasks[0].WhatId, 'Task should be related to Opportunity');
    }

    @isTest
    static void testUpdateToClosedWonCreatesTask() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Prospecting' LIMIT 1];
        
        // Update stage to Closed Won
        opp.StageName = 'Closed Won';
        update opp;

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :opp.Id];
        System.assertEquals(1, tasks.size(), 'Task should be created when Opportunity is updated to Closed Won');
    }

    @isTest
    static void testNoDuplicateTaskForUnchangedClosedWon() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Closed Won' LIMIT 1];
        
        Integer taskCountBefore = [SELECT COUNT() FROM Task WHERE WhatId = :opp.Id];
        update opp; // No stage change
        Integer taskCountAfter = [SELECT COUNT() FROM Task WHERE WhatId = :opp.Id];

        System.assertEquals(taskCountBefore, taskCountAfter, 'No additional task should be created when stage remains Closed Won');
    }
}
