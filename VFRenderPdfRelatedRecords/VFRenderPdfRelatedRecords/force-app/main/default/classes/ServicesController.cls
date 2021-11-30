public class ServicesController {

    public List<SelectOption> recordsTypeId {get;set;}
    public String recordTypeId {get;set;}
    public String startDate {get;set;}
    public String endDate {get;set;}
    public String currentRecordId;
    public date startDateNew;
    public date endDateNew;
    public List<Service__c> getServices() {
        if (apexpages.currentpage().getparameters().get('endDate') != null || apexpages.currentpage().getparameters().get('startDate') != null) {
            startDate = apexpages.currentpage().getparameters().get('startDate');
            endDate = apexpages.currentpage().getparameters().get('endDate');
            recordTypeId  = ApexPages.CurrentPage().getparameters().get('recordTypeId');
            if (startDate != '') {
                startDateNew = date.valueOf(startDate);
            }
            if (endDate != '') {
                endDateNew = date.valueOf(endDate);
            }
        }
        return [SELECT Id, Name, RecordTypeId, Service_Date__c, Contact__c FROM Service__c WHERE RecordTypeId = :recordTypeId AND Service_Date__c >= :startDateNew AND Service_Date__c <= :endDateNew AND Contact__c = :currentRecordId];
    }

    public PageReference next() {
    	PageReference pg = new PageReference('/apex/ServiceSelect');
        pg.getparameters().put('startDate', startDate);
        pg.getparameters().put('endDate', endDate);
        pg.getparameters().put('recordId', currentRecordId);
        pg.getparameters().put('recordTypeId', recordTypeId);
        pg.setRedirect(true);
        return pg;
    }

    public void getRecordsType() {
        Schema.DescribeSObjectResult R = Service__c.SObjectType.getDescribe();
        recordsTypeId = new List<SelectOption>();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        for (Schema.RecordTypeInfo recordType : RT) {
            recordsTypeId.add(new SelectOption(recordType.getRecordTypeId(), recordType.getName()));
        }
    }
    public ServicesController() {
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('recordId');
        getRecordsType();
    }

}
