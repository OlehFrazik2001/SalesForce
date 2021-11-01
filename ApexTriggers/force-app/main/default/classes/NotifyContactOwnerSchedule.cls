global class NotifyContactOwnerSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        NotifyContactOwnerBatch notifyContact = new NotifyContactOwnerBatch();
        database.executeBatch(notifyContact);
    }
}