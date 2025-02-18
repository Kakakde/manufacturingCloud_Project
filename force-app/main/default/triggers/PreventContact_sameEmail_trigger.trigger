trigger PreventContact_sameEmail_trigger on Contact (before insert) {
    if(trigger.isBefore && trigger.isInsert)
    {
    PreventContact_sameEmail_Handler.sameEmailMethod(trigger.new);
}
}