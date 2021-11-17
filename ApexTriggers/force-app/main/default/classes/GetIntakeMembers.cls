public  class GetIntakeMembers {
    @AuraEnabled
    public static List<Intake_Member__c> getAllMembers(String intakeId){
        return [SELECT Id, Gender__c, Age__c,SSN__c,Intake__c, Name FROM Intake_Member__c WHERE Intake__c = : intakeId]; 
        
    }
    
    @AuraEnabled
    public static void updateIntakeMembers(List<Intake_Member__c> members ){
        update members;
    }
}
