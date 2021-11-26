@isTest
public class ServiceAuraControllerTest {
    @TestSetup
    static void createContact(){
        Contact con = new Contact(LastName='Test');
        insert con;
    }

    @isTest
    public static void testServiceAuraController(){
        List<RecordType> recordTypeList = [SELECT Id, DeveloperName FROM RecordType WHERE sObjectType='Service__c'];
        System.assertEquals(ServiceAuraController.servicesRecordTypeList().size(), recordTypeList.size(), 'All records type were selected');
        Contact con = [SELECT Id FROM Contact WHERE LastName = 'Test'];
        Service__c service1 = new Service__c(Name='Test01', Service_Date__c = Date.Today(), Contact__c = con.Id, RecordTypeId = recordTypeList[0].Id);
        insert service1;
        apexpages.currentpage().getparameters().put('startdate', string.valueOf(Date.Today().addDays(-1)));
        apexpages.currentpage().getparameters().put('enddate', string.valueOf(Date.Today().addDays(1)));
        apexpages.currentpage().getparameters().put('currentRecordId', con.Id);
        apexpages.currentpage().getparameters().put('currentTypeName', recordTypeList[0].DeveloperName);
        System.assertEquals(1, ServiceAuraController.getServices().size(), 'Only one service is selected');
        
    }
}
