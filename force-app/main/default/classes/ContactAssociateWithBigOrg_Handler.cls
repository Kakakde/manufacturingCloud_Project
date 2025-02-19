public with sharing class ContactAssociateWithBigOrg_Handler {
    public static void ExecuteMethod(set<Id> accountIds){
        Map<Id, Boolean> accountBigOrgStatus = new Map<Id, Boolean>();

        // Get count of contacts per account
        for (AggregateResult ar : [
            SELECT AccountId, COUNT(Id) totalContacts 
            FROM Contact 
            WHERE AccountId IN :accountIds 
            GROUP BY AccountId
        ]) {
            accountBigOrgStatus.put((Id) ar.get('AccountId'), (Integer) ar.get('totalContacts') >= 5);
        }

        List<Contact> contactsToUpdate = new List<Contact>();
        for (Contact con : [
            SELECT Id, Contact_Associate_With__c, AccountId 
            FROM Contact 
            WHERE AccountId IN :accountIds WITH SECURITY_ENFORCED
        ]) {
            Boolean isBigOrg = accountBigOrgStatus.get(con.AccountId) == true;
            if (con.Contact_Associate_With__c != isBigOrg) {
                con.Contact_Associate_With__c = isBigOrg;
                contactsToUpdate.add(con);
    }
}
if (!contactsToUpdate.isEmpty()) {
    update contactsToUpdate;
}
    }
    }