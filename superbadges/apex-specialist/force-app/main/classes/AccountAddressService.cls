public with sharing class AccountAddressService {
    public static void syncShippingPostalCode(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.Match_Billing_Address__c == true) {
                acc.ShippingPostalCode = acc.BillingPostalCode;
            }
        }
    }
}
