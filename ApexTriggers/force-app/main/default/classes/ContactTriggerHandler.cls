public class ContactTriggerHandler extends TriggerHandler {
    public static Boolean isFirstTime = true;
    public static Boolean runChangeAccount = false;
    
    public override void afterUpdate() {
        updateContactPrimary((List<Contact>)Trigger.new, (Map<Id, Contact>)Trigger.OldMap);
        ContactPrimaryChangedToFalse(Trigger.new, (Map<Id, Contact>)Trigger.OldMap);
    }

    public override void afterInsert() {
        updateContactPrimary((List<Contact>)Trigger.new, null);  
    }

    public override void afterDelete() {
        deletePrimary(Trigger.old);
    }

    public override void beforeInsert() {
        programContact((List<Contact>)Trigger.New, null);
        PrimaryAndArchiveIsChecked(Trigger.new);
    }

    public override void beforeUpdate() {
        programContact((List<Contact>)Trigger.New, (Map<Id, Contact>)Trigger.OldMap);
        PrimaryAndArchiveIsChecked(Trigger.new);
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

    public static void updateContactPrimary(List<Contact> triggerNew, Map<Id, Contact> oldMap){
        Map<Id, Id> mapAccountIdContactId = new Map<Id, Id>();
        Set<Id> contactIdSet = new Set<Id>(); 
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = new List<Account>();
        for(Contact con : (List<Contact>) triggerNew) { 
            if(con.Primary__c == true && (oldMap == null || con.Primary__c != oldMap.get(con.Id).Primary__c) ) {
                isFirstTime = false;
                contactIdSet.add(con.Id);
                mapAccountIdContactId.put(con.AccountId, con.Id);
            }
        }
        
        List<Account> accountList = [SELECT Id,  (SELECT Id FROM Contacts WHERE Primary__c = True AND Id IN :contactIdSet) FROM Account WHERE Id IN :mapAccountIdContactId.keyset()];
        for( Account acc : accountList){
            acc.Primary_Contact__c = mapAccountIdContactId.get(acc.Id);
            accounts.add(acc);
            for(Contact con : acc.Contacts) {
                if(con.Id != acc.Primary_Contact__c) {
                    con.Primary__c = false;
                    contacts.add(con);
                }
            }   
        }
        update accounts;
        update contacts;
    }

    public static void ContactPrimaryChangedToFalse(List<Contact> triggerNew, Map<Id, Contact> oldMap) {
        if(isFirstTime){
            isFirstTime = false;
            Map<Id, Id> mapAccountIdContactId = new Map<Id, Id>();
            Set<Id> contactIdSet = new Set<Id>(); 
            List<Contact> contacts = new List<Contact>();
            List<Account> accounts = new List<Account>();
            for(Contact con: triggerNew) {
                if (con.Primary__c != oldMap.get(con.Id).Primary__c && con.Primary__c == false || runChangeAccount){
                    contactIdSet.add(con.Id);
                    mapAccountIdContactId.put(con.AccountId, con.Id);
                }
            }
            List<Account> accountList = [SELECT Id, (SELECT Id FROM Contacts WHERE Primary__c = False AND Archive__c = False AND Id NOT IN :contactIdSet) FROM Account WHERE Id IN :mapAccountIdContactId.keyset()];
            for( Account acc : accountList){
                for(Contact con : acc.Contacts) {
                    con.Primary__c = true;
                    contacts.add(con);
                    acc.Primary_Contact__c = con.Id;
                    accounts.add(acc);
                    break;
                }     
                
            }
            update accounts;
            update contacts;
        }
    }

    public static void PrimaryAndArchiveIsChecked(List<Contact> triggerNew){
        for(Contact con: triggerNew) {
            if (con.Primary__c == true && con.Archive__c == true){
                con.Primary__c = false;
                isFirstTime = true;
                runChangeAccount = true;
            }
        }
    }

    public static void deletePrimary(List<Contact> triggerOld){
        Set<Id> accountIdSet = new Set<Id>();
        Set<Id> contactIdSet = new Set<Id>();
        List<Contact> contacts = new List<Contact>();
        List<Account> accounts = new List<Account>();
        for(Contact con: triggerOld) {
            if (con.Primary__c == true){
                accountIdSet.add(con.AccountId);
                contactIdSet.add(con.Id);
            }
        }
        if (accountIdSet.size() != 0) {
            List<Account> accountList = [SELECT Id, (SELECT Id FROM Contacts WHERE Primary__c = False AND Archive__c = False AND Id NOT IN :contactIdSet) FROM Account WHERE Id IN :accountIdSet];
            for( Account acc : accountList){
                for(Contact con : acc.Contacts) {
                    con.Primary__c = true;
                    contacts.add(con);
                    acc.Primary_Contact__c = con.Id;
                    accounts.add(acc);
                    break;
                }     
                
            }
            update accounts;
            update contacts;
        }
    }
}