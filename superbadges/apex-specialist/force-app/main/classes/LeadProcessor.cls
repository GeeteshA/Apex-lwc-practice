public class LeadProcessor implements Database.Batchable<SObject> {
    
    // Start method to collect all Lead records
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
    }

    // Execute method to update LeadSource to 'Dreamforce'
    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        for (Lead l : scope) {
            l.LeadSource = 'Dreamforce';
        }
        update scope;
    }
    // Finish method to perform any final operations after batch processing
    public void finish(Database.BatchableContext bc) {      
    }
}
