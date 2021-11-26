public class ServiceAuraController {
    @AuraEnabled
    public static  List<RecordType> servicesRecordTypeList(){
        List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType WHERE sObjectType='Service__c'];
        return recordTypeList;
    }

    public static List<Service__c> getServices(){
        String startDateStr = ApexPages.currentpage().getparameters().get('startdate');
        Date startDate = Date.newInstance(2000, 1, 1);
        startDate = date.valueOf(startDateStr);
        String endDateStr = ApexPages.currentpage().getparameters().get('enddate');
        Date endDate;
        endDate = date.valueOf(endDateStr);
        String recordTypeId = Schema.SObjectType.Service__c.getRecordTypeInfosByDeveloperName().get(ApexPages.currentpage().getparameters().get('currentTypeName')).getRecordTypeId();
        String contactId = ApexPages.currentpage().getparameters().get('currentRecordId');
        return [SELECT Id, Name, RecordTypeId, Service_Date__c, Contact__c FROM Service__c WHERE Service_Date__c >= :startDate AND Service_Date__c <= :endDate AND RecordTypeId = :recordTypeId AND Contact__c = :contactId];
    }
}
