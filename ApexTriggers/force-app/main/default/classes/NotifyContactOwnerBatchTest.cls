@isTest 
public class NotifyContactOwnerBatchTest {
    @testSetup static void makeData() {
        List<Contact> contacts= new List<Contact>();
        Contact con1 = new Contact(LastName = 'testSetup1', Birthdate = Date.newInstance(Date.Today().addDays(90).year() - 18, Date.Today().addDays(90).month(), Date.Today().addDays(90).day()));
        Contact con2 = new Contact(LastName = 'testSetup2', Birthdate = Date.newInstance(Date.Today().addDays(90).year() - 18, Date.Today().addDays(90).month(), Date.Today().addDays(90).day()));
        Contact con3 = new Contact(LastName = 'testSetup3', Birthdate = Date.newInstance(Date.Today().addDays(90).year() - 16, Date.Today().addDays(90).month(), Date.Today().addDays(90).day()));
        contacts.add(con1);
        contacts.add(con2);
        contacts.add(con3);
        insert contacts;
    }
    

    @isTest 
    static void batchNotifyTest(){
        Test.startTest();
            DataBase.executeBatch(new NotifyContactOwnerBatch());
        Test.stopTest();
        System.assert(NotifyContactOwnerBatch.emailLimits > 0, 'Email was sent');
    }
}
