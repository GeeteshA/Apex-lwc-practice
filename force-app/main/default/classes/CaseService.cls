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
        System.debug('📦 Cases received in execute: ' + cases.size());

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Case_Reminder' LIMIT 1];

        for (Case c : cases) {
            System.debug('🔍 Case: ' + c.CaseNumber + ' | OwnerId: ' + c.OwnerId + ' | Email: ' + c.Owner.Email);

            if (c.Owner.Email != null && c.OwnerId != null) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(template.Id);
                mail.setTargetObjectId(c.OwnerId); 
                mail.setSaveAsActivity(false);
                emails.add(mail);
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
            System.debug('📤 Emails Sent: ' + emails.size());
        } else {
            System.debug('⚠️ No valid recipients — email list is empty.');
        }
    }
//  public static void sendReminderEmails(List<Case> cases) {
//         System.debug('📦 Cases received in execute: ' + cases.size());

//         List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
//         EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Case_Reminder' LIMIT 1];

//         for (Case c : cases) {
//             System.debug('🔍 Case: ' + c.CaseNumber + ' | Owner Email: ' + c.Owner.Email);
//             if (c.Owner.Email != null) {
//                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
//                 mail.setTemplateId(template.Id);
//                 mail.setTargetObjectId(c.OwnerId);
//                 mail.setSaveAsActivity(false);  
//                 emails.add(mail);
//             }
//         }

//         if (!emails.isEmpty()) {
//             Messaging.sendEmail(emails);
//             System.debug('📤 Emails Sent: ' + emails.size());
//         } else {
//             System.debug('⚠️ No valid recipients — emails list is empty.');
//         }
//     }
}