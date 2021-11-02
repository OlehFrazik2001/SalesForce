@isTest 
public class NotifyContactOwnerBatchTest 
{
    static testMethod void testMethod1() 
    {
        List<Contact> contacts= new List<Contact>();
        for(Integer i=0 ;i <100;i++)
        {
            Contact con = new Contact(LastName = 'test1' + i);
            Contact con2 = new Contact(LastName = 'test2' + i);
            con.Birthdate = Date.newInstance(Date.Today().addDays(90).year() - 18, Date.Today().addDays(90).month(), Date.Today().addDays(90).day());
            con.Birthdate = Date.newInstance(Date.Today().addDays(90).year() - 16, Date.Today().addDays(90).month(), Date.Today().addDays(90).day());
            contacts.add(con);
        }
        
        insert contacts;
        
        Test.startTest();

            NotifyContactOwnerBatch batchJob = new NotifyContactOwnerBatch();
            DataBase.executeBatch(batchJob); 
            
        Test.stopTest();
    }
}