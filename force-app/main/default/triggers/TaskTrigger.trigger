// Trigger to create a Case when a High Priority Escalation Task is inserted
trigger TaskTrigger on Task (after insert) {
    
    // List to hold new Case records to be inserted
    List<Case> casesToCreate = new List<Case>();

    // List to hold Tasks that need to be updated (to mark them as processed)
    List<Task> tasksToUpdate = new List<Task>();

    // Loop through all new Tasks
    for (Task task : Trigger.new) {
        // Check if the Task matches the condition for escalation
        if (
            task.Subject == 'Escalation' &&
            task.Priority == 'High' &&
            task.Escalated_Task__c != true
        ) {
            // Create a related Case
            Case newCase = new Case();
            newCase.Subject = 'Auto-created from High Priority Escalation Task';
            newCase.Description = 'This case was created due to an escalation task: ' + task.Subject;

            
            // if (task.WhatId != null && String.valueOf(task.WhatId).startsWith('001')) {
            //     newCase.AccountId = task.WhatId;
            // }

            casesToCreate.add(newCase);

            // Mark this Task as escalated to prevent future recursion
            Task updatedTask = new Task(Id = task.Id);
            updatedTask.Escalated_Task__c = true;
            tasksToUpdate.add(updatedTask);
        }
    }

    // Insert the new Case records
    if (!casesToCreate.isEmpty()) {
        insert casesToCreate;
    }

    // Update the Task records to mark as processed
    if (!tasksToUpdate.isEmpty()) {
        update tasksToUpdate;
    }
}
