public class ServicesController {
    public String serviceRecordTypeId;

    public String getString() {
        return serviceRecordTypeId;
    }
 			
    public void setString(String serviceRecordTypeId) {
        this.serviceRecordTypeId = serviceRecordTypeId;
    }
    public List<SelectOption> options {get;set;}
    public String option {get;set;}
    public String startDate {get;set;}
    public String endDate {get;set;}
    public String currentRecordId;
    public date startDateNew;
    public date endDateNew;
    public List<Service__c> getServices() {
        startDate = apexpages.currentpage().getparameters().get('startDate');
        endDate = apexpages.currentpage().getparameters().get('endDate');
        option  = ApexPages.CurrentPage().getparameters().get('option');
        if (startDate!='') {
            startDateNew = date.parse(startDate);
        }
        if (endDate!='') {
            endDateNew = date.parse(endDate);
        }

        return [SELECT Name, RecordTypeId, Service_Date__c, Contact__c FROM Service__c WHERE RecordTypeId = :option AND Service_Date__c >= :startDateNew AND Service_Date__c <= :endDateNew AND Contact__c = :currentRecordId];
    }

    public PageReference next() {
    	PageReference pg = new PageReference('/apex/ServiceSelect');
        pg.getparameters().put('startDate', startDate);
        pg.getparameters().put('endDate', endDate);
        pg.getparameters().put('recordId', serviceRecordTypeId);
        pg.getparameters().put('id', currentRecordId);
        pg.getparameters().put('option', option);
        pg.setRedirect(true);
        return pg;
    }

    public ServicesController() {
        serviceRecordTypeId = apexpages.currentpage().getparameters().get('recordId');
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        Schema.DescribeSObjectResult R = Service__c.SObjectType.getDescribe();
        options = new List<SelectOption>();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        for (Schema.RecordTypeInfo recordType : RT) {
            options.add(new SelectOption(recordType.getRecordTypeId(), recordType.getName()));
        }
    }

}
