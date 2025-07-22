@isTest
public class AccountAddressTriggerTest {

    static Id accWithMatchId;
    static Id accWithoutMatchId;

    @testSetup
    static void setupData() {
        Account acc1 = new Account(
            Name = 'Match True Account',
            BillingPostalCode = '12345',
            Match_Billing_Address__c = true
        );

        Account acc2 = new Account(
            Name = 'Match False Account',
            BillingPostalCode = '99999',
            Match_Billing_Address__c = false
        );

        insert new List<Account>{acc1, acc2};

        accWithMatchId = acc1.Id;
        accWithoutMatchId = acc2.Id;
    }

    static testMethod void testMatchBillingAddressTrue() {
        Account acc = [SELECT ShippingPostalCode, BillingPostalCode FROM Account WHERE Id = :accWithMatchId];
        System.assertEquals(acc.BillingPostalCode, acc.ShippingPostalCode, 'ShippingPostalCode should match BillingPostalCode');
    }

    static testMethod void testMatchBillingAddressFalse() {
        Account acc = [SELECT ShippingPostalCode FROM Account WHERE Id = :accWithoutMatchId];
        System.assertEquals(null, acc.ShippingPostalCode, 'ShippingPostalCode should remain null');
    }
}
