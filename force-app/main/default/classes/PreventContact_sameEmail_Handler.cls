public with sharing class PreventContact_sameEmail_Handler {
    public static void sameEmailMethod(List<Contact> contactRecordList){
                
                Set<String> incomingEmails = new Set<String>();
                for (Contact con : contactRecordList) {
                    if (con.Email != null) {
                        incomingEmails.add(con.Email);
                    }
                }
        
                // Query existing contacts with the same emails
                Map<String, Contact> existingContacts = new Map<String, Contact>();
                for (Contact con : [
                    SELECT Id, Email
                    FROM Contact
                    WHERE Email != null AND Email IN :incomingEmails WITH SECURITY_ENFORCED
                ]) {
                    existingContacts.put(con.Email.toLowerCase(), con);
                }
        
                // Add error to incoming contacts if a duplicate is found
                for (Contact con : contactRecordList) {
                    if (con.Email != null && existingContacts.containsKey(con.Email.toLowerCase())) {
                        con.addError('A contact with this email already exists.');
                    }
                }
            }
        }
        

