trigger UserCreate_BasedOnContactEmail_Trigger on Contact (after insert, after update) {
    if (Trigger.isAfter) {
        UserCreate_BasedOnContactEmail_Handler.UserInsertMethod(Trigger.new);
    }
}