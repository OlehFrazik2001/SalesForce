@isTest
private class ContactTriggerHandlerTest {

    static testMethod void checkPrimary() {
        Account acc = new Account(name='Test');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        Contact con1 = new Contact(lastname = 'test1', AccountId = acc.Id, Primary__c = true);
        Contact con2 = new Contact(lastname = 'test2', AccountId = acc.Id, Primary__c = true);
        Contact con3 = new Contact(lastname = 'test3', AccountId = acc.Id, Primary__c = true);
            
        contacts.add(con1);
        contacts.add(con2);
        contacts.add(con3);
        insert contacts;
        List<Contact> contList = [SELECT Name, Primary__c FROM Contact WHERE AccountId =: acc.id AND Primary__c = true];
        System.assertEquals(3, contList.size());
    }
}
