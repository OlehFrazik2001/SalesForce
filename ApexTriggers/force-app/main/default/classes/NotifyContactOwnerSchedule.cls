global class NotifyContactOwnerSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        NotifyContactOwnerBatch notifyContact = new NotifyContactOwnerBatch(); // Your batch class
        database.executeBatch(notifyContact);
    }
}