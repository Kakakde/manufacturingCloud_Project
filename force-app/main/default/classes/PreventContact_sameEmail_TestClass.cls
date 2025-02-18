@isTest
private class PreventContact_sameEmail_TestClass {
    @isTest
        static void testPreventDuplicateEmails() {
            // Create an existing contact
            Contact existingContact = new Contact(
                FirstName = 'Existing',
                LastName = 'User',
                Email = 'duplicate@example.com'
            );
            insert existingContact;
    
            // Attempt to insert a new contact with the same email
            Contact newContact = new Contact(
                FirstName = 'New',
                LastName = 'User',
                Email = 'duplicate@example.com'
            );
    
            Test.startTest();
            try {
                insert newContact;
                System.assert(false, 'Expected DmlException was not thrown.');
            } catch (DmlException e) {
    
                System.assert(e.getMessage().contains('A contact with this email already exists.'));
            }
            Test.stopTest();
        }
    }
    
