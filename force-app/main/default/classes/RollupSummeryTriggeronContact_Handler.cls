public with sharing class RollupSummeryTriggeronContact_Handler {
    public static void updateContactCount(Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        Set<Id> accountIds = new Set<Id>();

        if (newMap != null) {
            for (Contact con : newMap.values()) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }
        if (oldMap != null) {
            for (Contact con : oldMap.values()) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }

        if (!accountIds.isEmpty()) {
            // Query Accounts and their related Contacts
            List<Account> accountsToUpdate = [SELECT Id, Number_of_Contacts__c, (SELECT Id FROM Contacts) FROM Account WHERE Id IN :accountIds WITH SECURITY_ENFORCED];

            // Update the No_of_Contacts__c field
            for (Account acc : accountsToUpdate) {
                acc.Number_of_Contacts__c = acc.Contacts.size();
            }

            if (!accountsToUpdate.isEmpty()) {
                update accountsToUpdate;
            }
        }
    }
}