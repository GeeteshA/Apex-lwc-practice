public with sharing class ClosedOpportunityService {

    public static void createFollowUpTasks(List<Opportunity> opportunities, Map<Id, Opportunity> oldMap, Boolean isInsert) {
        List<Task> followUpTasks = new List<Task>();

        for (Opportunity opp : opportunities) {
            Boolean isClosedWon = opp.StageName == 'Closed Won';
            Boolean wasClosedWon = !isInsert && oldMap != null &&
                                   oldMap.containsKey(opp.Id) &&
                                   oldMap.get(opp.Id).StageName == 'Closed Won';

            // Create a Task only if:
            // - on insert: StageName is 'Closed Won'
            // - on update: Stage changed to 'Closed Won'
            if (isClosedWon && (isInsert || !wasClosedWon)) {
                followUpTasks.add(new Task(
                    Subject = 'Follow Up Test Task',
                    WhatId = opp.Id
                ));
            }
        }

        if (!followUpTasks.isEmpty()) {
            insert followUpTasks;
        }
    }
}
