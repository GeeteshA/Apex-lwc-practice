public with sharing class CaseReminderBatch implements Database.Batchable<sObject> {
    private final Date cutoffDate;

    public CaseReminderBatch() {
        // this.cutoffDate = Date.today().addDays(-7);
        this.cutoffDate = Date.today();
        
    }

    public Database.QueryLocator start(Database.BatchableContext bc) {
         return CaseFactory.getStaleOpenCasesQueryLocator(cutoffDate);
    }

    public void execute(Database.BatchableContext bc, List<Case> scope) {
        CaseService.sendReminderEmails(scope);
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('✅ Case Reminder Batch completed');
    }
}
// Test classes fix it with setup
// Check custom metadata and setting