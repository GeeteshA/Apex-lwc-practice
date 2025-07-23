public class ClosedOpportunityTriggerHandler {
    
    public static void onAfterInsert(List<Opportunity> newList) {
        List<Task> followUpTasks = new List<Task>();

        for (Opportunity opp : newList) {
            if (opp.StageName == 'Closed Won') {
                followUpTasks.add(new Task(
                    Subject = 'Follow Up Test Task',
                    WhatId = opp.Id,
                    Status = 'Not Started',
                    Priority = 'Normal'
                ));
            }
        }

        if (!followUpTasks.isEmpty()) {
            insert followUpTasks;
        }
    }

    public static void onAfterUpdate(Map<Id, Opportunity> newMap, Map<Id, Opportunity> oldMap) {
        List<Task> followUpTasks = new List<Task>();

        for (Id oppId : newMap.keySet()) {
            Opportunity newOpp = newMap.get(oppId);
            Opportunity oldOpp = oldMap.get(oppId);

            // Only add a task if StageName was not Closed Won before but is now
            if (oldOpp.StageName != 'Closed Won' && newOpp.StageName == 'Closed Won') {
                followUpTasks.add(new Task(
                    Subject = 'Follow Up Test Task',
                    WhatId = newOpp.Id,
                    Status = 'Not Started',
                    Priority = 'Normal'
                ));
            }
        }

        if (!followUpTasks.isEmpty()) {
            insert followUpTasks;
        }
    }
}
