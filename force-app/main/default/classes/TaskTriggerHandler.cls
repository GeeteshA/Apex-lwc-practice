public with sharing class TaskTriggerHandler {
    // Handles after insert event for Tasks
    // Scenario: Create Case for escalation Tasks
    public static void onAfterInsert(List<Task> newTasks) {
        TaskService.createCasesForEscalatedTasks(newTasks);
    }
}
