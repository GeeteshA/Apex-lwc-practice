public class TaskTriggerHandler {
    public static final String ESCALATION_TASK_SUBJECT = 'Escalation';
    
    public static void handleEscalationTasks(List<Task> newTasks) {
        List<Case> casesToCreate = new List<Case>();
        List<Task> tasksToUpdate = new List<Task>();
        
        for (Task task : newTasks) {
            if (task.Subject == ESCALATION_TASK_SUBJECT &&
                task.Priority == 'High' &&
                task.Escalated_Task__c != true) {
                
                casesToCreate.add(CaseFactory.createCaseFromTask(task));
                
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
