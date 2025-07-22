public with sharing class OpportunityService {
    public static void createFollowUpTasks(List<Opportunity> opportunities, Map<Id, Opportunity> oldMap, Boolean isInsert) {
        List<Task> followUpTasks = new List<Task>();

        for (Opportunity opp : opportunities) {
            Boolean isClosedWon = opp.StageName == 'Closed Won';
            Boolean wasClosedWon = !isInsert && oldMap != null && oldMap.containsKey(opp.Id) && oldMap.get(opp.Id).StageName == 'Closed Won';

            if (isClosedWon && (isInsert || !wasClosedWon)) {
                Task t = new Task(
                    Subject = 'Follow Up Test Task',
                    WhatId = opp.Id
                );
                followUpTasks.add(t);
            }
        }

        if (!followUpTasks.isEmpty()) {
            insert followUpTasks;
        }
    }
}
