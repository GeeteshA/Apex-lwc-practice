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
    
    // Batch: Send reminder emails
    public static void sendReminderEmails(List<Case> cases) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Case_Reminder' LIMIT 1];
        
        for (Case c : cases) {
            if (c.Owner.Email != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(template.Id);
                mail.setTargetObjectId(c.OwnerId);
                mail.setWhatId(c.Id);
                mail.setSaveAsActivity(false);
                emails.add(mail);
            }
        }
        if (!emails.isEmpty()) Messaging.sendEmail(emails);
    }
}