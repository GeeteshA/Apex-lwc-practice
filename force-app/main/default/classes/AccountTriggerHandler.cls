public with sharing class AccountTriggerHandler {
    public static void onAfterInsert(List<Account> newAccounts) {
        AccountService.createContactsForAccounts(newAccounts);
    }
}

