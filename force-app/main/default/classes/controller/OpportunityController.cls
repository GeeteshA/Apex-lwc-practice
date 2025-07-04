public with sharing class OpportunityController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
        return [
            SELECT Id, Name, StageName, Amount, CloseDate, 
                   Account.Name, AccountId
            FROM Opportunity 
            ORDER BY CloseDate DESC
            LIMIT 50
        ];
    }

    @AuraEnabled
    public static void saveOpportunities(List<Opportunity> opportunities) {
        try {
            update opportunities;
        } catch (Exception e) {
            throw new AuraHandledException('Error updating opportunities: ' + e.getMessage());
        }
    }
}