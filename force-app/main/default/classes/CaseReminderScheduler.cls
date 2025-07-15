public with sharing class CaseReminderScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new CaseReminderBatch(), 100);
    }
}
