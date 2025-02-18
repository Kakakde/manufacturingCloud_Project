public with sharing class PreventContactDelet_ActiveUser_Handler {
    public static void preventDeletionMethod(List<Contact> ContactList)
    {
        Set<Id> ContactIdSet = new Set<Id>();
        for(Contact cont : ContactList)
        {
            ContactIdSet.add(cont.Id);
        }

        Set<Id> ContactWithActiveUser = new Set<Id>();
        for(User usr : [SELECT Id, ContactId FROM User WHERE ContactId IN :ContactIdSet WITH SECURITY_ENFORCED])
        {
            ContactWithActiveUser.add(usr.ContactId);
        }

        for(Contact con : ContactList)
        {
            if(ContactWithActiveUser.contains(con.Id))
            {
                con.addError('This contact is associated with an active user and cannot be deleted.');
            }
        }
    }
}