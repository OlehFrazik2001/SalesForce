@isTest
public class ServiceAuraControllerTest {
    @TestSetup
    static void createContact(){
        List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType='Service__c'];
        System.assertEquals(ServiceAuraController.servicesRecordTypeList().size(), recordTypeList.size(), 'All records type were selected');
        Contact con = new Contact(LastName='Test');
        insert con;
        Id clinicalNote = Schema.SObjectType.Service__c.getRecordTypeInfosByDeveloperName().get('Clinical_Note').getRecordTypeId();
        List<Service__c> serviceList = new List<Service__c>();
        for (Integer i = 0; i < 10; i++) {
            Service__c service = new Service__c(Name='Test' + i, Service_Date__c = Date.Today().addDays(-i), Contact__c = con.Id, RecordTypeId = clinicalNote);
            serviceList.add(service);
        }
        insert serviceList;
    }

    @isTest
    public static void testServiceAuraController(){
        Id recordTypeId = Schema.SObjectType.Service__c.getRecordTypeInfosByDeveloperName().get('Clinical_Note').getRecordTypeId();
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'Test' LIMIT 1];
        List<Service__c> serviceList = [SELECT Id FROM Service__c];
        apexpages.currentpage().getparameters().put('startdate', string.valueOf(Date.Today().addDays(-1)));
        apexpages.currentpage().getparameters().put('enddate', string.valueOf(Date.Today().addDays(1)));
        apexpages.currentpage().getparameters().put('currentRecordId', con.Id);
        apexpages.currentpage().getparameters().put('currentTypeName', 'Clinical_Note');
        System.assertEquals(2, ServiceAuraController.getServices().size(), 'Two services are selected');
        
    }
}
