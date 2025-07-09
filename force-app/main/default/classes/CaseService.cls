public with sharing class CaseService {
    // Constants
    private static final String CASE_SUBJECT_FIELD = 'Subject';
    private static final String CASE_DESCRIPTION_FIELD = 'Description';
    private static final String CASE_TYPE_FIELD = 'Type';

    public static Case createCase(String subject, String description, String type) {
        Case newCase = new Case(
            Subject = subject,
            Description = description,
            Type = type
        );
        insert newCase;
        return newCase;
    }
}