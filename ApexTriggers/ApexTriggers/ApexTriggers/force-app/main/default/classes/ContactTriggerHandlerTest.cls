@isTest
private class ContactTriggerHandlerTest {

    @TestSetup
    static void setup(){
        List<Program__c> progs = new List<Program__c>();
        Program__c prog = new Program__c(Name='Test');
        Program__c prog2 = new Program__c(Name='Test2');
        progs.add(prog);
        progs.add(prog2);
        insert progs;

        Account acc = new Account(name='TestMethod');
        insert acc;
    }

    static testMethod void testProgram() {
        Map<Id, Program__c> mapProgram = new Map<Id, Program__c>([SELECT Id, Name FROM Program__c]);
        List <Program__c> programValues = mapProgram.values();
        Contact con1 = new Contact(LastName = 'test1', Current_Program__c = programValues[0].Id);
        insert con1;
        con1 = [SELECT Current_Program__c, Current_Program_Name__c FROM Contact  WHERE Current_Program__c= :programValues[0].Id][0];
        System.assertEquals(con1.Current_Program_Name__c, mapProgram.get(con1.Current_Program__c).Name, 'Program Name has been populated'); 
        con1.Current_Program__c = programValues[1].Id;
        update con1;
        con1 = [SELECT Current_Program__c, Current_Program_Name__c FROM Contact  WHERE Current_Program__c= :programValues[1].Id][0];
        System.assertEquals(con1.Current_Program_Name__c, mapProgram.get(con1.Current_Program__c).Name, 'Program Name has been updated');
    }


    static testMethod void checkPrimary() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'TestMethod'][0];
        List<Contact> contacts = new List<Contact>();
        Contact con1 = new Contact(lastname = 'test1', AccountId = acc.Id, Primary__c = true);
        Contact con2 = new Contact(lastname = 'test2', AccountId = acc.Id, Primary__c = true);
        contacts.add(con1);
        contacts.add(con2);
        insert contacts;
        List<Contact> contList = [SELECT Name, Primary__c FROM Contact WHERE AccountId = :acc.id AND Primary__c = true];
        System.assertEquals(1, contList.size(), 'Only one primary after insert');
        delete [SELECT Name, Primary__c FROM Contact WHERE AccountId = :acc.id AND Primary__c = true];
        contList = [SELECT Name, Primary__c FROM Contact WHERE AccountId = :acc.id AND Primary__c = true];
        System.assertEquals(1, contList.size(), 'Only one primary after delete');
    }

    static testMethod void checkPrimaryAndArchive() {
        Account acc = [SELECT Id, Name FROM Account WHERE Name = 'TestMethod'][0];
        List<Contact> contacts = new List<Contact>();
        Contact con1 = new Contact(lastname = 'test1', AccountId = acc.Id, Primary__c = true);
        Contact con2 = new Contact(lastname = 'test2', AccountId = acc.Id, Primary__c = false);
        contacts.add(con1);
        contacts.add(con2);
        insert contacts;
        con1.Archive__c = true;
        update con1;
        List<Contact> contList = [SELECT Name, Primary__c FROM Contact WHERE AccountId = :acc.id AND Primary__c = true];
        System.assertEquals('test2', contList[0].Name, 'Primary changed to next contact');
    }
}
