
@isTest
private class RollupSummeryTrigger_TestClass {

    @isTest
    static void testContactTriggerScenarios() {
        // Create a test Account
        Account testAccount1 = new Account(Name = 'Test Account 1');
        insert testAccount1;
        
        // Verify initial contact count
        testAccount1 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAccount1.Id];
        System.assertEquals(null, testAccount1.Number_of_Contacts__c, 'Initial contact count should be Null.');
        
        // Create a new Contact associated with the test Account
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact@example.com',
            AccountId = testAccount1.Id
        );
        insert testContact;
        
        // Verify contact count after insertion
        testAccount1 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAccount1.Id];
        System.assertEquals(1, testAccount1.Number_of_Contacts__c, 'Contact count should be 1 after insertion.');
        
        // Create another Account
        Account testAccount2 = new Account(Name = 'Test Account 2');
        insert testAccount2;
        
        // Update the Contact to associate it with the new Account
        testContact.AccountId = testAccount2.Id;
        update testContact;
        
        // Verify contact counts after update
        testAccount1 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAccount1.Id];
        testAccount2 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAccount2.Id];
        System.assertEquals(0, testAccount1.Number_of_Contacts__c, 'Contact count for Account 1 should be 0 after reassignment.');
        System.assertEquals(1, testAccount2.Number_of_Contacts__c, 'Contact count for Account 2 should be 1 after reassignment.');
        
        // Delete the Contact
        delete testContact;
        
        // Verify contact count after deletion
        testAccount2 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAccount2.Id];
        System.assertEquals(0, testAccount2.Number_of_Contacts__c, 'Contact count should be 0 after deletion.');
        
        // Undelete the Contact
        undelete testContact;
        
        // Verify contact count after undeletion
        testAccount2 = [SELECT Id, Number_of_Contacts__c FROM Account WHERE Id = :testAccount2.Id];
        System.assertEquals(1, testAccount2.Number_of_Contacts__c, 'Contact count should be 1 after undeletion.');
    }
}