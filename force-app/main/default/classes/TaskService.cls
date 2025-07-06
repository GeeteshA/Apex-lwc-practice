public with sharing class TaskService {
    public static final String ESCALATION_TASK_SUBJECT = 'Escalation';

    // Creates Cases for high-priority escalation Tasks
    // Scenario: Auto-create Case for 'Escalation' Tasks
    
    public static void createCasesForEscalatedTasks(List<Task> tasks) {
        List<Case> casesToCreate = new List<Case>();
        List<Task> tasksToUpdate = new List<Task>();
        
        for (Task task : tasks) {
            if (task.Subject == ESCALATION_TASK_SUBJECT &&
                task.Priority == 'High' &&
                task.Escalated_Task__c != true) {
                // Create related Case
                casesToCreate.add(new Case(
                    Subject = 'Auto-created from High Priority Escalation Task',
                    Description = 'Created from task: ' + task.Subject
                ));
                // Prevent recursion
                tasksToUpdate.add(new Task(
                    Id = task.Id,
                    Escalated_Task__c = true
                ));
            }
        }
        
        if (!casesToCreate.isEmpty()) insert casesToCreate;
        if (!tasksToUpdate.isEmpty()) update tasksToUpdate;
    }
}