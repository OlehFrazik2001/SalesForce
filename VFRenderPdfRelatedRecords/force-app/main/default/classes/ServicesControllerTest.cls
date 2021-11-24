@isTest
public class ServicesControllerTest {

    @TestSetup
    static void createServices(){
        RecordType recordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'Education_Note' LIMIT 1];
        Date today = Date.Today();
        Contact con = new Contact(LastName = 'Testing');
        insert con;
        List<Service__c> services = new List<Service__c>();
        for (Integer i = 0; i < 5; i++) {
            Service__c ser = new Service__c(Name = 'Test' + i, Service_Date__c = today.addDays((-2)*i), Contact__c = con.Id, RecordTypeId = recordType.Id);
            services.add(ser);
        }
        insert services;
    }

    @isTest
    public static void testServicesController(){
        ServicesController sc = new ServicesController();
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'Testing' LIMIT 1];
        Date today = Date.Today(); 
        RecordType recordType = [SELECT Id, Name FROM RecordType WHERE DeveloperName = 'Education_Note' LIMIT 1];
        List<Service__c> services = [SELECT Id, Contact__c FROM Service__c WHERE Name LIKE 'Test%'];
        sc.currentRecordId = con.Id;
       
        PageReference pg = new PageReference('/apex/ServiceSelect');
        apexpages.currentpage().getparameters().put('startDate', string.valueOf(today.addDays(-1)));
        apexpages.currentpage().getparameters().put('endDate', string.valueOf(today.addDays(1)));
        apexpages.currentpage().getparameters().put('recordTypeId', recordType.Id);
        sc.startDate = apexpages.currentpage().getparameters().get('startDate');
        sc.endDate = apexpages.currentpage().getparameters().get('endDate');
        sc.recordTypeId = apexpages.currentpage().getparameters().get('recordTypeId');
        sc.next();    
        List<Service__c> listServiceUsers = sc.getServices();
        System.assertEquals(1, listServiceUsers.size(), 'Only one service will be shown on the page');
    }
}
