trigger Welcome_newContact_Email_Trigger on contact (after insert) {
    if(trigger.isafter && trigger.isInsert)
    {
        Welcome_newContact_Email_Handler.sendEmailMethod(trigger.new);
    }
}