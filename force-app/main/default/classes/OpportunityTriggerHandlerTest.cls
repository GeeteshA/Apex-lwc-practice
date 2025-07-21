@IsTest
private class OpportunityTriggerHandlerTest {
    @TestSetup
    static void setup() {
        Account testAcc = new Account(Name = 'Test Account');
        insert testAcc;
    }
    
    @IsTest
    static void testStageSyncWithMultipleAccounts() {
        Account acc1 = [SELECT Id FROM Account LIMIT 1];
        Account acc2 = new Account(Name = 'Account 2');
        insert acc2;
        
        // Create opportunities for different accounts
        Opportunity opp1Acc1 = new Opportunity(
            Name = 'Opp1 Acc1',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = acc1.Id
        );
        
        Opportunity opp1Acc2 = new Opportunity(
            Name = 'Opp1 Acc2',
            StageName = 'Closed Lost',
            CloseDate = Date.today().addDays(-1),
            AccountId = acc2.Id
        );
        
        Test.startTest();
        insert new List<Opportunity>{opp1Acc1, opp1Acc2};
        Test.stopTest();
        
        // Verify both accounts were updated correctly
        Map<Id, Account> accounts = new Map<Id, Account>([
            SELECT Last_Closed_Opportunity_Stage__c 
            FROM Account
        ]);
        
        System.assertEquals('Closed Won', accounts.get(acc1.Id).Last_Closed_Opportunity_Stage__c);
        System.assertEquals('Closed Lost', accounts.get(acc2.Id).Last_Closed_Opportunity_Stage__c);
    }
    
    @IsTest
    static void testNoUpdateForNonClosedStages() {
        Account acc = [SELECT Id FROM Account LIMIT 1];
        
        Opportunity opp = new Opportunity(
            Name = 'Non-closed Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = acc.Id
        );
        
        Test.startTest();
        insert opp;
        
        // Update to another non-closed stage
        opp.StageName = 'Qualification';
        update opp;
        Test.stopTest();
        
        Account updatedAcc = [SELECT Last_Closed_Opportunity_Stage__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(null, updatedAcc.Last_Closed_Opportunity_Stage__c,
            'Should not update for non-closed stages');
    }
}