@isTest
public class ClosedOpportunityTriggerTest {

    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Opportunity opp1 = new Opportunity(
            Name = 'Opp Insert Closed Won',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 1000,
            AccountId = acc.Id
        );

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
        Task t = [SELECT Id, WhatId FROM Task WHERE WhatId = :opp.Id LIMIT 1];
        System.assertEquals(opp.Id, t.WhatId, 'Task should be related to Closed Won Opportunity');
    }

    @isTest
    static void testUpdateToClosedWonCreatesTask() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Prospecting' LIMIT 1];
        opp.StageName = 'Closed Won';
        update opp;

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :opp.Id];
        System.assertEquals(1, tasks.size(), 'One task should be created when Stage updated to Closed Won');
    }

    @isTest
    static void testNoTaskForUnchangedClosedWon() {
        Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Closed Won' LIMIT 1];
        update opp; // re-update without changing stage

        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :opp.Id];
        System.assertEquals(1, tasks.size(), 'No additional task should be created on unchanged Closed Won');
    }
}
