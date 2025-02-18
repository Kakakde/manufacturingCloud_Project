@isTest
private class PreventContactDelet_ActiveUser_TestClass {
    @isTest
    static void testPreventDeletionIfAssociatedWithActiveUser() {
        // Create a test Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a test Contact associated with the Account
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact123@example.com',
            AccountId = testAccount.Id
        );
        insert testContact;

        // Retrieve the Customer Community User Profile
        Profile communityUserProfile = [SELECT Id, UserType FROM Profile WHERE UserType = 'PowerPartner' LIMIT 1];

        // Create a test User associated with the Contact
        User portalUser = new User(
            Username = 'testuser' + DateTime.now().getTime() + '@example.com',
            LastName = 'User',
            Alias = 'tuser',
            Email = 'testuser@example.com',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = communityUserProfile.Id,
            ContactId = testContact.Id
        );

        // Insert the portal user
        insert portalUser;

        // Attempt to delete the Contact
        Test.startTest();
        try {
            delete testContact;
            System.assert(false, 'Expected DmlException was not thrown.');
        } catch (DmlException e) {
            System.debug('Actual Exception Message: ' + e.getMessage());
        }
        Test.stopTest();
    }
}
