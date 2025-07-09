public with sharing class OpportunityController {
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
        return OpportunityService.getOpportunities();
    }

    @AuraEnabled
    public static void saveOpportunities(List<Opportunity> opportunities) {
        OpportunityService.saveOpportunities(opportunities);
    }
}