trigger PreventContactDelet_ActiveUser_Trigger on Contact (before delete) {
    if(trigger.isBefore && trigger.isDelete)
    {
        PreventContactDelet_ActiveUser_Handler.preventDeletionMethod(trigger.old);
    }
}