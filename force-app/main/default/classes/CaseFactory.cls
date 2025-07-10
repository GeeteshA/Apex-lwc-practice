public with sharing class CaseFactory {
    // For Batch: Get stale open cases
    public static List<Case> getStaleOpenCases(Date cutoffDate) {
        return [
            SELECT Id, CaseNumber, Subject, OwnerId, Owner.Email
            FROM Case 
            WHERE IsClosed = false 
            AND CreatedDate <= :cutoffDate
        ];
    }
    // For Batch: Returns QueryLocator
    public static Database.QueryLocator getStaleOpenCasesQueryLocator(Date cutoffDate) {
        return Database.getQueryLocator([
            SELECT Id, CaseNumber, Subject, OwnerId, Owner.Email
            FROM Case 
            WHERE IsClosed = false 
            AND CreatedDate <= :cutoffDate
        ]);
    }
}