public with sharing class AccountAddressTriggerHandler {
    public static void handleBeforeInsertUpdate(List<Account> accounts) {
        AccountAddressService.syncShippingPostalCode(accounts);
    }
}
