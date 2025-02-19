trigger RollupSummeryTriggeronContact_Trigger on Contact (after insert, after update, after delete, after undelete) 
{
    if (RecursionHandle_Handler.isTriggerExecuting) {   //Handle Recursion
        return; 
    }
        RecursionHandle_Handler.isTriggerExecuting = true;

    Set<Id> accountIds = new Set<Id>();

    if (Trigger.isAfter) {
        if (Trigger.isInsert || Trigger.isUndelete) {
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
            ContactAssociateWithBigOrg_Handler.ExecuteMethod(accountIds);
        }
    }

    RecursionHandle_Handler.isTriggerExecuting = false; 
}
