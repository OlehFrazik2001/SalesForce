public class ContactTriggerHandler extends TriggerHandler {
    
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

    public override void beforeInsert() {
        programContact((List<Contact>)Trigger.New, null);
    }

    public override void beforeUpdate() {
        programContact((List<Contact>)Trigger.New, (Map<Id, Contact>)Trigger.OldMap);
    }

    public static void programContact(List<Contact> triggerNew, Map<Id, Contact> oldMap){
        Set<Id> programIdSet = new Set<Id>();
        for(Contact con : triggerNew){
            programIdSet.add(con.Current_Program__c);
        }
        Map<Id, Program__c> mapProgram = new Map<Id, Program__c>([SELECT Id, Name FROM Program__c WHERE Id IN :programIdSet]);
        for(Contact con : triggerNew){
            if(con.Current_Program__c != null){
                if(oldMap == null) {
                    con.Current_Program_Name__c = mapProgram.get(con.Current_Program__c).Name;
                } else if(con.Current_Program__c != oldMap.get(con.Id).Current_Program__c){
                    con.Current_Program_Name__c = mapProgram.get(con.Current_Program__c).Name;
                }
            }
        }
    }

    public static void updateContactPrimary(List<Contact> triggerNew){
        String accId;
        String conId;
        List<Contact> contacts = new List<Contact>();
        
        
        for(Contact con : (List<Contact>) triggerNew) {
          if(con.Primary__c == true) {
            accId = con.AccountId;
            conId = con.Id;
          }
        }
        List<Contact> conList = [SELECT Id, Name, Primary__c FROM Contact WHERE AccountId = :accId];
        for(Contact con : conList) {
            if(con.Primary__c == true && con.Id != conId) {
                con.Primary__c = false;
                contacts.add(con);
            }
        }
        updateAccountPrimaryContact(accId, conId);
        update contacts;
    }

    public static void ContactPrimaryChangedToFalse(List<Contact> triggerNew, List<Contact> triggerOld) {
        String accId;
        String conId;
        Map<Id, Contact> conmap = new Map<Id, Contact>(triggerOld);
        for(Contact con: triggerNew) {
            if (con.Primary__c != conmap.get(con.Id).Primary__c && con.Primary__c == false){
                accId = con.AccountId;
                conId = con.Id;
            }
        }
        if(conId != null){
            MakeAnotherPrimary(accId, conId);
        }
    }

    public static void PrimaryAndArchiveIsChecked(List<Contact> triggerNew){
        String accId;
        String conId;
        List<Contact> contacts = new List<Contact>();
        for(Contact con: triggerNew) {
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

    public static void deletePrimary(List<Contact> triggerOld){
        String accId;
        String conId;
        List<Contact> contacts = new List<Contact>();
        
        for(Contact con : (List<Contact>) triggerOld) {
          if(con.Primary__c == true) {
            accId = con.AccountId;
            conId = con.Id;
          }
        }
        List<Contact> conList = [SELECT Id, Name, Primary__c FROM Contact WHERE AccountId = :accId AND Archive__c = FALSE AND Id != :conId];
        for(Contact con : conList) {
            if(con.Primary__c == false) {
                con.Primary__c = true;
                contacts.add(con);
                break;
            }
        }
        update contacts;
        updateAccountPrimaryContact(accId, conId);
       
    }


    public static void updateAccountPrimaryContact(String accId, String conId){
        List<Account> accounts = new List<Account>();
        List<Account> accList = [SELECT Id, Primary_Contact__c FROM Account WHERE Id = :accId];
        for(Account acc : accList) {
            acc.Primary_Contact__c = conId;
            accounts.add(acc);
        }
        update accounts;
    }

    

    public static void MakeAnotherPrimary(String accId, String conId){
        List<Contact> newCont = new List<Contact>();
        List<Contact> conList = [SELECT Id, Name, Primary__c, Archive__c FROM Contact WHERE AccountId = :accId AND Archive__c = FALSE];
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
    
}
