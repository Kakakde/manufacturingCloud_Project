public with sharing class UserCreate_BasedOnContactEmail_Handler {
    public static void UserInsertMethod(List<Contact> newContacts) {
        Set<String> contactEmails = new Set<String>();
        for (Contact con : newContacts) {
            if (con.Email != null) {
                contactEmails.add(con.Email);
            }
        }
        // Query existing Users with these emails
        Map<String, User> ExistingUsersByEmail = new Map<String, User>();
        for (User usr : [SELECT Id, Email FROM User WHERE Email IN :contactEmails WITH SECURITY_ENFORCED]) {
            ExistingUsersByEmail.put(usr.Email, usr);
        }

        // Prepare lists for User insertions and updates
       
        List<User> usersToProcess = new List<User>();

        for (Contact con : newContacts) {

            User existingUser = ExistingUsersByEmail.get(con.Email);
            if (existingUser == null) {
                // Create new User
                User newUser = new User(
                    Username = con.Email,
                    Email = con.Email,
                    LastName = con.LastName != null ? con.LastName : 'DefaultLastName',
                    FirstName = con.FirstName,
                    Phone = con.Phone,
                    Title = con.Title,
                    Alias = con.LastName,
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    EmailEncodingKey = 'UTF-8',
                    LanguageLocaleKey = 'en_US',
                    ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id
                );
                usersToProcess.add(newUser);
            } else {
                // Update existing User
                existingUser.FirstName = con.FirstName;
                existingUser.LastName = con.LastName != null ? con.LastName : existingUser.LastName;
                existingUser.Phone = con.Phone;
                existingUser.Title = con.Title;
                usersToProcess.add(existingUser);
            }
        }
        System.debug('Users to process: ' + usersToProcess.size());
        // Perform DML operations asynchronously to avoid Mixed DML errors
        if (!usersToProcess.isEmpty()) {
            System.enqueueJob(new UserProcessorQueueableClass(usersToProcess));
        }
    }

}