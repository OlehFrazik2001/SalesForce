public class ServiceAuraController {
    @AuraEnabled
    public static  List<RecordType> servicesRecordTypeList(){
        List<RecordType> recordTypeList = [SELECT Id, Name FROM RecordType WHERE sObjectType='Service__c'];
        system.debug('recordTypeList ' + recordTypeList);
        return recordTypeList;
    }
    
    public static List<Service__c> lstServices;

    @AuraEnabled
    public static List<Service__c> getServices1(String recordTypeName, Date startDate, Date endDate,String currentRecordId) {
        System.debug('0  ' + rec);
        String recordTypeId = [SELECT Id FROM RecordType WHERE Name = :recordTypeName LIMIT 1].Id;
        System.debug('1  ' + recordTypeId);
        System.debug('2  ' + startDate);
        lstServices = [SELECT Id, Name, RecordTypeId, Service_Date__c, Contact__c FROM Service__c WHERE RecordTypeId = :recordTypeId AND Service_Date__c >= :startDate AND Service_Date__c <= :endDate ];
        System.debug('3  ' + lstServices);
        return lstServices;
    }

    public static List<Service__c> getServices(){
        System.debug('4  ' + lstServices);
        return lstServices;
    }
    
}
