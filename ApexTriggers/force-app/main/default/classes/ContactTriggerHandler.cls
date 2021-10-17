public class ContactTriggerHandler extends TriggerHandler {
    
    public static void updateAccountPrimaryContact(String accId, String conId){
        List<Account> accounts = new List<Account>();
        List<Account> accList = [SELECT Id, Primary_Contact__c FROM Account WHERE Id =: accId];
        for(Account acc : accList) {
            acc.Primary_Contact__c = conId;
            accounts.add(acc);
        }
        update accounts;
    }

    public static void updateContactPrimary(List<Contact> contactsFromTrigger){
        String accId;
        String conId;
        List<Contact> contacts = new List<Contact>();
        
        for(Contact con : (List<Contact>) contactsFromTrigger) {
          if(con.Primary__c == true) {
            accId = con.AccountId;
            conId = con.Id;
          }
        }
        List<Contact> conList = [SELECT Id, Name, Primary__c FROM Contact WHERE AccountId =: accId];
        for(Contact con : conList) {
            if(con.Primary__c == true && con.Id != conId) {
                con.Primary__c = false;
                contacts.add(con);
            }
        }
        updateAccountPrimaryContact(accId, conId);
        update contacts;
    }

    public static void MakeAnotherPrimary(String accId, String conId){
        List<Contact> newCont = new List<Contact>();
        List<Contact> conList = [SELECT Id, Name, Primary__c, Archive__c FROM Contact WHERE AccountId =: accId AND Archive__c = FALSE];
        if(conList.size() != 0){
            for(Contact con : conList) {
                if(con.Id != conId) {
                    con.Primary__c = true;
                    conId = con.Id;
                    newCont.add(con);
                    break;
                }
            }
            update newCont;
            updateAccountPrimaryContact(accId, conId);
        }   
    }

    public static void ContactPrimaryChangedToFalse(List<Contact> contactsFromTrigger, List<Contact> contactsFromTriggerOld) {
        String accId;
        String conId;
        Map<Id, Contact> conmap = new Map<Id, Contact>(contactsFromTriggerOld);
        for(Contact con: contactsFromTrigger) {
            if (con.Primary__c != conmap.get(con.Id).Primary__c && con.Primary__c == false){
                accId = con.AccountId;
                conId = con.Id;
            }
        }
        if(conId != null){
            MakeAnotherPrimary(accId, conId);
        }
    }


    public static void PrimaryAndArchiveIsChecked(List<Contact> contactsFromTrigger){
        String accId;
        String conId;
        List<Contact> contacts = new List<Contact>();
        for(Contact con: contactsFromTrigger) {
            if (con.Primary__c == true && con.Archive__c == true){
                Contact newCon = new Contact(Id=con.Id);
                accId = con.AccountId;
                conId = con.Id;
                newCon.Primary__c = false;
                contacts.add(newCon);
            }
        }
        if (accId != null) {
            MakeAnotherPrimary(accId, conId);
            update contacts;
        }
    }

    public static void deletePrimary(List<Contact> contactsFromTrigger){
        String accId;
        String conId;
        List<Contact> contacts = new List<Contact>();
        
        for(Contact con : (List<Contact>) contactsFromTrigger) {
          if(con.Primary__c == true) {
            accId = con.AccountId;
            conId = con.Id;
          }
        }
        List<Contact> conList = [SELECT Id, Name, Primary__c FROM Contact WHERE AccountId =: accId AND Archive__c = FALSE];
        for(Contact con : conList) {
            if(con.Primary__c == false && con.Id != conId) {
                con.Primary__c = true;
                contacts.add(con);
                break;
            }
        }
        updateAccountPrimaryContact(accId, conId);
        update contacts;
    }

    public override void afterUpdate() {
        updateContactPrimary(Trigger.new);
        ContactPrimaryChangedToFalse(Trigger.new, Trigger.old);
        PrimaryAndArchiveIsChecked(Trigger.new);
    }

    public override void afterInsert() {
        updateContactPrimary(Trigger.new);
        PrimaryAndArchiveIsChecked(Trigger.new);
    }

    public override void beforeDelete() {
        deletePrimary(Trigger.old);
    }
}
