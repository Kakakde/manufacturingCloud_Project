trigger NewWeatherAPI_Trigger on Contact (after insert, after update) {
        Set<Id> contactsToProcess = new Set<Id>();
    
        for (Contact newCon : Trigger.new) {
            Contact oldCon = Trigger.oldMap != null ? Trigger.oldMap.get(newCon.Id) : null;
            if (oldCon == null || newCon.MailingCity != oldCon.MailingCity) {
                contactsToProcess.add(newCon.Id);
            }
        }
    
        if (!contactsToProcess.isEmpty()) {
            System.enqueueJob(new NewWeatherAPI_Handler(contactsToProcess));
        }
    }
    