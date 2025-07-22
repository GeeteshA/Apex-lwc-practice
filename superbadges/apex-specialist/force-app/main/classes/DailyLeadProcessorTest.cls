@isTest
public class DailyLeadProcessorTest {

    @testSetup
    static void setupData() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(
                FirstName = 'Test',
                LastName = 'User' + i,
                Company = 'Test Company'
            ));
        }
        insert leads;
    }

    @isTest
    static void testScheduledJob() {
        Test.startTest();

        // Safe cron expression — Jan 1, 2099 at midnight
        String cronExp = '0 0 0 1 1 ? 2099';
        String jobId = System.schedule('Test Scheduled Job', cronExp, new DailyLeadProcessor());

        Test.stopTest(); // Triggers scheduled job

        // Validate all Leads were updated
        List<Lead> updatedLeads = [SELECT Id, LeadSource FROM Lead];
        for (Lead l : updatedLeads) {
            System.assertEquals('Dreamforce', l.LeadSource, 'LeadSource should be updated to Dreamforce');
        }
    }
}
