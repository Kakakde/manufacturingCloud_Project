public with sharing class UserProcessorQueueableClass implements Queueable {
    public List<User> usersToProcess;
    public UserProcessorQueueableClass(List<User> usersToProcess) {
        this.usersToProcess = usersToProcess;
    }
    public void execute(QueueableContext context) {
        if (!usersToProcess.isEmpty()) {
            List<User> usersToInsert = new List<User>();
            List<User> usersToUpdate = new List<User>();

            for (User usr : usersToProcess) {
                if (usr.Id == null) {
                    // New User record to insert
                    usersToInsert.add(usr);
                } else {
                    // Existing User record to update
                    usersToUpdate.add(usr);
                }
            }

            try {
                if (!usersToInsert.isEmpty()) {
                    insert usersToInsert;
                }
                if (!usersToUpdate.isEmpty()) {
                    update usersToUpdate;
                }
            } catch (DmlException e) {
                System.debug('Error processing users: ' + e.getMessage());
            }
        }
    }
}