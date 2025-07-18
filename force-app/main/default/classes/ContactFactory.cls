public with sharing class ContactFactory {
    public static List<AggregateResult> getContactCountsByAccountIds(Set<Id> accountIds) {
        return [
            SELECT AccountId, COUNT(Id) total 
            FROM Contact 
            WHERE AccountId IN :accountIds 
            AND IsDeleted = false // Critical for delete/undelete scenarios
            GROUP BY AccountId
        ];
    }
}
// public with sharing class ContactFactory {
//     public static List<AggregateResult> getContactCountsByAccountIds(Set<Id> accountIds) {
//         return [
//             SELECT AccountId, COUNT(Id) total 
//             FROM Contact 
//             WHERE AccountId IN :accountIds 
//             GROUP BY AccountId
//         ];
//     }
// }