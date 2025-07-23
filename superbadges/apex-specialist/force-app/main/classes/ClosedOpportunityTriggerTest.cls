@isTest
public class ClosedOpportunityTriggerTest {
    
    @isTest
    static void testInsertClosedWonOpportunities() {
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 0; i < 5; i++) {
            oppList.add(new Opportunity(
                Name = 'Closed Won Opp ' + i,
                StageName = 'Closed Won',
                CloseDate = Date.today()
            ));
        }
        insert oppList;

        List<Task> tasks = [SELECT Id, Subject, WhatId FROM Task WHERE Subject = 'Follow Up Test Task'];
        System.assertEquals(5, tasks.size(), 'Should create 5 follow-up tasks');
    }

    @isTest
    static void testUpdateToClosedWonOpportunities() {
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 0; i < 3; i++) {
            oppList.add(new Opportunity(
                Name = 'Opp ' + i,
                StageName = 'Prospecting',
                CloseDate = Date.today()
            ));
        }
        insert oppList;

        for (Opportunity opp : oppList) {
            opp.StageName = 'Closed Won';
        }
        update oppList;

        List<Task> tasks = [SELECT Id FROM Task WHERE Subject = 'Follow Up Test Task'];
        System.assertEquals(3, tasks.size(), 'Should create 3 follow-up tasks');
    }
}
