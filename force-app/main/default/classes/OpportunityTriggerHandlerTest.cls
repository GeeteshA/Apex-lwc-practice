@IsTest
private class OpportunityTriggerHandlerTest {
    @IsTest
    static void testOpportunityStageFlow() {
        // 1. Create test account
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
        
        // 2. Create opportunity with Prospecting stage (today's date)
        Opportunity opp1 = new Opportunity(
            Name = 'First Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = testAcc.Id
        );
        
        Test.startTest();
        insert opp1;
        Test.stopTest();
        
        // 3. Check Last_Closed_Opportunity_Stage__c is NOT Prospecting
        Account afterFirstInsert = [SELECT Last_Closed_Opportunity_Stage__c FROM Account WHERE Id = :testAcc.Id];
        System.assertEquals(null, afterFirstInsert.Last_Closed_Opportunity_Stage__c,
            'Should NOT update to Prospecting stage');
        
        // 4. Update opportunity to Closed Won
        opp1.StageName = 'Closed Won';
        update opp1;
        
        // 5. Check Last_Closed_Opportunity_Stage__c is now Closed Won
        Account afterUpdate = [SELECT Last_Closed_Opportunity_Stage__c FROM Account WHERE Id = :testAcc.Id];
        System.assertEquals('Closed Won', afterUpdate.Last_Closed_Opportunity_Stage__c,
            'Should update to Closed Won stage');
        
        // 6. Create second opportunity with Closed Lost (older date)
        Opportunity opp2 = new Opportunity(
            Name = 'Second Opp',
            StageName = 'Closed Lost',
            CloseDate = Date.today().addDays(-5), // Older date
            AccountId = testAcc.Id
        );
        insert opp2;
        
        // 7. Final check - should still show Closed Won (newer date)
        Account finalCheck = [SELECT Last_Closed_Opportunity_Stage__c FROM Account WHERE Id = :testAcc.Id];
        System.assertEquals('Closed Won', finalCheck.Last_Closed_Opportunity_Stage__c,
            'Should keep Closed Won as it has newer date');
    }
}