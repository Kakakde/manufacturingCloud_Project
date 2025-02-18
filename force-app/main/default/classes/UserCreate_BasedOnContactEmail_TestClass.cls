
@isTest
private class UserCreate_BasedOnContactEmail_TestClass {

    
    @isTest
    static void testUserInsertMethod() {
        // Step 1: Create a test Profile
        Profile testProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];

        // Step 2: Create a test user to use with runAs
        User testUser = new User(
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            Email = 'testuser@example.com',
            LastName = 'Test',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = testProfile.Id
        );
        insert testUser;

        // Step 3: Execute the test as the new user
        System.runAs(testUser) {
            // Create test Contacts
            List<Contact> contacts = new List<Contact>{
                new Contact(
                    FirstName = 'Bill',
                    LastName = 'Doe',
                    Email = 'Bill.doe@example.com',
                    Phone = '123-456-7890',
                    Title = 'Manager'
                ),
                new Contact(
                    FirstName = 'Jane',
                    LastName = 'Smith',
                    Email = 'jane.smith@example.com',
                    Phone = '987-654-3210',
                    Title = 'Director'
                )
            };
            insert contacts;

            // Execute the method to test
            Test.startTest();
            UserCreate_BasedOnContactEmail_Handler.UserInsertMethod(contacts);
            Test.stopTest();

            // Verify that Users were created or updated
            Set<String> contactEmails = new Set<String>{'Bill.doe@example.com', 'jane.smith@example.com'};
            List<User> users = [SELECT Id, Email, FirstName, LastName, Phone, Title FROM User WHERE Email IN :contactEmails];
            System.assertEquals(2, users.size(), 'Two users should be created or updated.');

            // Verify User details
            for (User u : users) {
                if (u.Email == 'Bill.doe@example.com') {
                    System.assertEquals('Bill', u.FirstName, 'First name should be Bill.');
                    System.assertEquals('Doe', u.LastName, 'Last name should be Doe.');
                    System.assertEquals('123-456-7890', u.Phone, 'Phone number should match.');
                    System.assertEquals('Manager', u.Title, 'Title should be Manager.');
                } else if (u.Email == 'jane.smith@example.com') {
                    System.assertEquals('Jane', u.FirstName, 'First name should be Jane.');
                    System.assertEquals('Smith', u.LastName, 'Last name should be Smith.');
                    System.assertEquals('987-654-3210', u.Phone, 'Phone number should match.');
                    System.assertEquals('Director', u.Title, 'Title should be Director.');
                }
            }
        }
    }
}