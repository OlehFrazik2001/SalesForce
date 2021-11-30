public class ServiceAuraController {
    @AuraEnabled
    public static  List<RecordType> servicesRecordTypeList(){
        List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType WHERE sObjectType='Service__c']; //Select all record type from Service
        return recordTypeList;
    }

    public static List<Service__c> getServices(){
        String startDateStr = ApexPages.currentpage().getparameters().get('startdate'); //get start date from url
        Date startDate = date.valueOf(startDateStr); //get start date from string
        String endDateStr = ApexPages.currentpage().getparameters().get('enddate'); //get end date from url
        Date endDate = date.valueOf(endDateStr); //get end date from string
        String recordTypeId = ApexPages.currentpage().getparameters().get('currentTypeName'); // get record type Id from url
        System.debug('Record type :'+recordTypeId);
        String contactId = ApexPages.currentpage().getparameters().get('currentRecordId'); //get contact Id
        return [SELECT Id, Name, RecordTypeId, Service_Date__c, Contact__c FROM Service__c WHERE Service_Date__c >= :startDate AND Service_Date__c <= :endDate AND RecordTypeId = :recordTypeId AND Contact__c = :contactId]; //return all services which satisfies the conditions
    }
}
