@isTest
private class ContactTriggerHandlerTest {
    @isTest
    static void testSendWelcomeEmails() {
        // Create a test Contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com'
        );
        
        Test.startTest();
        // Insert the test Contact, which should trigger the email
        insert testContact;
        Test.stopTest();
        
        // Verify that the email was sent
        List<EmailMessage> sentEmails = [SELECT Id  FROM EmailMessage];
        System.assertEquals(1, sentEmails.size());
        
    }
}
