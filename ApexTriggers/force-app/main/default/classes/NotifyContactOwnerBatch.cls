global class NotifyContactOwnerBatch implements Database.Batchable<SObject> {
    @TestVisible static Integer emailLimits;
    global Database.QueryLocator start(Database.BatchableContext BC) {
       return Database.getQueryLocator('SELECT Id, Owner.ID, Birthdate, Age__c, Name FROM Contact WHERE Birthdate = NEXT_90_DAYS AND Age__c = 17');
    }
 
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        Map<Id, List<Contact>> mapOwnerContact = new Map<Id, List<Contact>>();
        for (Contact con : scope) {
            if (Date.newInstance(Date.Today().addDays(90).year() - 18, Date.Today().addDays(90).month(), Date.Today().addDays(90).day()) == con.Birthdate) {
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
            List<String> toAddresses = new List<String>{u.Email};
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
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(mails);
        emailLimits = Limits.getEmailInvocations();
    }

    global void finish(Database.BatchableContext BC){
    }
}