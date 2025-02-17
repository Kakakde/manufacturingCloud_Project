public with sharing class Welcome_newContact_Email_Handler {
    public static void sendEmailMethod(List<Contact> contactRecordList){
        List<Messaging.SingleEmailMessage> emailsMessage = new List<Messaging.SingleEmailMessage>();
        if(!contactRecordList.isEmpty()){
           for(Contact contactInstance : contactRecordList)
           {
            if(contactInstance.Email != null)
            {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses( new String[] {contactInstance.Email});
                mail.setSubject('Hi, This is Welcome Email');
                mail.setPlainTextBody('Dear '+contactInstance.FirstName+' Thank you for joining us!');
                emailsMessage.add(mail);
            }
           }
        }
        if(!emailsMessage.isEmpty()){
            Messaging.sendEmail(emailsMessage);
        }
    }
}