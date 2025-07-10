public with sharing class InactiveAccountScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new InactiveAccountBatch(), 200);
    }
}