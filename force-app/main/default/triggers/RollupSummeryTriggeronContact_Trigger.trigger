trigger RollupSummeryTriggeronContact_Trigger on Contact (after insert, after update, after delete, after undelete) {
    if(Trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
        RollupSummeryTriggeronContact_Handler.updateContactCount(Trigger.newMap, null);
        }
        if(trigger.isUpdate){
            RollupSummeryTriggeronContact_Handler.updateContactCount(Trigger.newMap, Trigger.oldMap);
        }
        if(trigger.isDelete)
        {
            RollupSummeryTriggeronContact_Handler.updateContactCount(null, Trigger.oldMap);
        }
    }
}