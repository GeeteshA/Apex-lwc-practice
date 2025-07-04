// CaseFactory.cls for TaskTriggerHandler
public class CaseFactory {
    public static Case createCaseFromTask(Task task) {
        return new Case(
            Subject = 'Auto-created from High Priority Escalation Task',
            Description = 'This case was created due to an escalation task: ' + task.Subject
        );
    }
}