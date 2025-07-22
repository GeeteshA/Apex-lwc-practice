@isTest
public class LeadProcessorTest {

    @testSetup
    static void setupTestData() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 100; i++) { 
            leads.add(new Lead(
                FirstName = 'Test',
                LastName = 'User' + i,
                Company = 'Test Company',
                LeadSource = 'Web'
            ));
        }
        insert leads;
    }

    @isTest
    static void testBatchExecution() {
        Test.startTest();
        LeadProcessor batch = new LeadProcessor();
        Database.executeBatch(batch, 100); 
        Test.stopTest();

        // Assert all leads updated
        for (Lead l : [SELECT LeadSource FROM Lead]) {
            System.assertEquals('Dreamforce', l.LeadSource, 'LeadSource should be Dreamforce');
        }
    }
}
