public with sharing class InactiveAccountBatch implements Database.Batchable<sObject> {
    private final Date cutoffDate;
    
    public InactiveAccountBatch() {
        this.cutoffDate = Date.today().addYears(-2);
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return AccountFactory.getInactiveAccountsQueryLocator(cutoffDate);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> scope) {
        AccountService.markAccountsInactive(scope);
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('Inactive Account Batch completed');
    }
}