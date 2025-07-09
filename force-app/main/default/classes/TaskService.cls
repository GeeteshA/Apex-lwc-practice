public with sharing class TaskService {
    // Constants
    public static final String ESCALATION_TASK_SUBJECT = 'Escalation';
    private static final String HIGH_PRIORITY = 'High';
    private static final String CASE_SUBJECT = 'Auto-created from High Priority Escalation Task';
    private static final String CASE_DESCRIPTION_PREFIX = 'Created from task: ';

    public static void createCasesForEscalatedTasks(List<Task> tasks) {
        List<Case> casesToCreate = new List<Case>();
        List<Task> tasksToUpdate = new List<Task>();
        
        for (Task task : tasks) {
            if (task.Subject == ESCALATION_TASK_SUBJECT &&
                task.Priority == HIGH_PRIORITY &&
                task.Escalated_Task__c != true) {
                
                casesToCreate.add(new Case(
                    Subject = CASE_SUBJECT,
                    Description = CASE_DESCRIPTION_PREFIX + task.Subject
                ));
                
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