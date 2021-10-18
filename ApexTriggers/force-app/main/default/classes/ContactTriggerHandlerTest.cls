@isTest
private class ContactTriggerHandlerTest {

    static testMethod void testProgram() {
        List<Program__c> progs = new List<Program__c>();
        Program__c prog1 = new Program__c(name='Test1');
        Program__c prog2 = new Program__c(name='Test2');
        progs.add(prog1);
        progs.add(prog2);
        insert progs;
        Contact con1 = new Contact(lastname = 'test1', Current_Program__c = prog1.Id);
        insert con1;
        List<Contact> contList = [SELECT Name, Current_Program_Name__c FROM Contact WHERE Current_Program__c = :prog1.id];
        System.assertEquals(1, contList.size());
        System.assertEquals('Test1', contList[0].Current_Program_Name__c);
        con1.Current_Program__c = prog2.Id;
        update con1;
    }

    static testMethod void checkPrimary() {
        Account acc = new Account(name='Test');
        insert acc;
        Program__c prog = new Program__c(name='Test');
        insert prog;
        List<Contact> contacts = new List<Contact>();
        Contact con1 = new Contact(lastname = 'test1', AccountId = acc.Id, Primary__c = true, Current_Program__c = prog.Id);
        Contact con2 = new Contact(lastname = 'test2', AccountId = acc.Id, Primary__c = true, Current_Program__c = prog.Id);
        contacts.add(con1);
        contacts.add(con2);
        insert contacts;

        List<Contact> contList = [SELECT Name, Primary__c FROM Contact WHERE AccountId = :acc.id AND Primary__c = true];
        System.assertEquals(1, contList.size());
        delete [SELECT Name, Primary__c FROM Contact WHERE AccountId = :acc.id AND Primary__c = true];
        contList = [SELECT Name, Primary__c FROM Contact WHERE AccountId = :acc.id AND Primary__c = true];
        System.assertEquals(1, contList.size());
    }

    static testMethod void checkPrimaryAndArchive() {
        Account acc = new Account(name='Test');
        insert acc;
        Program__c prog = new Program__c(name='Test');
        insert prog;
        List<Contact> contacts = new List<Contact>();
        Contact con1 = new Contact(lastname = 'test1', AccountId = acc.Id, Primary__c = true, Archive__c = true, Current_Program__c = prog.Id);
        Contact con2 = new Contact(lastname = 'test2', AccountId = acc.Id, Primary__c = false, Current_Program__c = prog.Id);
            
        contacts.add(con1);
        contacts.add(con2);
        insert contacts;
        List<Contact> contList = [SELECT Name, Primary__c FROM Contact WHERE AccountId = :acc.id AND Primary__c = true];
        System.assertEquals('test2', contList[0].Name);
    }
}
