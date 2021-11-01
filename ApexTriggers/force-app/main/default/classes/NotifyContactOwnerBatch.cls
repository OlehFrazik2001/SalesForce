public class NotifyContactOwnerBatch implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
       return Database.getQueryLocator('SELECT Id, Owner.ID, Birthdate, Name FROM Contact');
    }
 
    public void execute(Database.BatchableContext BC, List<Contact> scope){
        Map<Id, List<Contact>> mapOwnerContact = new Map<Id, List<Contact>>();
        for (Contact con : scope) {
            if (con.Birthdate != null && Date.Today().addDays(90) == con.Birthdate && (Date.Today().addDays(90).year() - con.Birthdate.year()) == 18) {
                if (mapOwnerContact.containsKey(con.Owner.Id)) {
                    mapOwnerContact.get(con.Owner.Id).add(con);
                } else {
                    mapOwnerContact.put(con.Owner.Id, new List<Contact> {con});
                }
            }
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<User> users = [SELECT Id, Email FROM User WHERE Id IN :mapOwnerContact.keySet()];
        for (User u : users) {
            String[] toAddresses = new String[] {u.Email};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            String body = 'Here is a list of contacts turning 18 in 3 month:<br>';
            for(Contact con : mapOwnerContact.get(u.Id)) {
                body += con.Name + ' - ' + con.Birthdate + '<br>';
            } 
            mail.setSubject('Contacts Turning 18');
            mail.setHtmlBody(body); 
            mail.setToAddresses(toAddresses);
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }

    public void finish(Database.BatchableContext BC){
    }
}
