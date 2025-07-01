public class TaskTriggerHandler {
    public static void handleEscalationTasks(List<Task> newTasks) {
        List<Case> casesToCreate = new List<Case>();
        List<Task> tasksToUpdate = new List<Task>();

        for (Task task : newTasks) {
            if (
                task.Subject == 'Escalation' &&
                task.Priority == 'High' &&
                task.Escalated_Task__c != true
            ) {
                Case newCase = new Case();
                newCase.Subject = 'Auto-created from High Priority Escalation Task';
                newCase.Description = 'This case was created due to an escalation task: ' + task.Subject;

                // Optional: Link case to account via WhatId if needed
                // if (task.WhatId != null && String.valueOf(task.WhatId).startsWith('001')) {
                //     newCase.AccountId = task.WhatId;
                // }

                casesToCreate.add(newCase);

                Task updatedTask = new Task(Id = task.Id);
                updatedTask.Escalated_Task__c = true;
                tasksToUpdate.add(updatedTask);
            }
        }

        if (!casesToCreate.isEmpty()) {
            insert casesToCreate;
        }

        if (!tasksToUpdate.isEmpty()) {
            update tasksToUpdate;
        }
    }
}
