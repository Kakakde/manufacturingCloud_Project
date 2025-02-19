trigger RollupSummeryTriggeronContact_Trigger on Contact (before insert, after insert, after update, before delete, after delete, after undelete) 
{
    if (RecursionHandle_Handler.isTriggerExecuting) {   //Handle Recursion
        return; 
    }
        RecursionHandle_Handler.isTriggerExecuting = true;

    Set<Id> accountIds = new Set<Id>();
    Set<Id> contactsToProcess = new Set<Id>();

    if(trigger.isBefore){
    if(trigger.isDelete)
        {
            PreventContactDelet_ActiveUser_Handler.preventDeletionMethod(trigger.old);//Assignment 4 : Prevent Contact Deletion 
        }
    if(trigger.isInsert || trigger.isUpdate)
        {
            PreventContact_sameEmail_Handler.sameEmailMethod(trigger.new);//Assignment 5 : Prevent Contact with same Email
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert){
            RollupSummeryTriggeronContact_Handler.updateContactCount(Trigger.newMap, null); //Assignment 3 : Rollup Summary on Account

            Welcome_newContact_Email_Handler.sendEmailMethod(trigger.new); //Assignment 6 : Send Welcome Email

           // UserCreate_BasedOnContactEmail_Handler.UserInsertMethod(Trigger.new); //Assignment 2 : Create User based on Contact Email

           for (Contact newCon : Trigger.new) {
                contactsToProcess.add(newCon.Id);
        }
           if (!contactsToProcess.isEmpty()) {
            System.enqueueJob(new NewWeatherAPI_Handler(contactsToProcess));// Assignment 1 : Call Weather API Logic
        }

        } 
        if(Trigger.isUndelete) {
            RollupSummeryTriggeronContact_Handler.updateContactCount(Trigger.newMap, null); 
        }
        if (Trigger.isUpdate) {
            RollupSummeryTriggeronContact_Handler.updateContactCount(Trigger.newMap, Trigger.oldMap);

          
            for (Contact con : Trigger.new) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
            for (Contact con : Trigger.old) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
            for (Contact newCon : Trigger.new) {
                Contact oldCon = Trigger.oldMap != null ? Trigger.oldMap.get(newCon.Id) : null;
                if (oldCon == null || newCon.MailingCity != oldCon.MailingCity) {
                    contactsToProcess.add(newCon.Id);
                }
            }
        }
        if (Trigger.isDelete) {
            RollupSummeryTriggeronContact_Handler.updateContactCount(null, Trigger.oldMap);

            for (Contact con : Trigger.old) {
                if (con.AccountId != null) {
                    accountIds.add(con.AccountId);
                }
            }
        }

       
        if (!accountIds.isEmpty()) {
            ContactAssociateWithBigOrg_Handler.ExecuteMethod(accountIds); //Assignment 7 : Associate Contact with Big Org
        }
        
        // ✅ Call Weather API logic asynchronously
        

        
    }

    RecursionHandle_Handler.isTriggerExecuting = false; 
}
