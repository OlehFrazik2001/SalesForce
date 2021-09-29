public with sharing class DeleteLeads {
    @AuraEnabled
    public static string deleteLeads(){
        delete [SELECT Id, Rating FROM Lead WHERE Rating='Cold'];
        sendEmail();
        return ' ';
    }

    public static void sendEmail(){
        String[] toAddresses = new String[] {UserInfo.getUserEmail()};
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSubject('All leads were deleted');
        mail.setPlainTextBody('Hi ' + UserInfo.getFirstName() +'!\nAll leads with rating "Cold" were deleted successfully.\nBest regard,\nRed Tag Service.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}
