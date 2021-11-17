public class IntakeTriggerHandler extends TriggerHandler{
    public override void afterInsert() {
        createIntakeMembers(Trigger.new);
    }

    public static void createIntakeMembers(List<Intake__c> intakeList) {
        Map<Id, Intake__c> contactIdIntakeMap = new Map<Id, Intake__c>();
        Map<Id, Intake__c> accountIdIntakeMap = new Map<Id, Intake__c>();
        for(Intake__c intake : intakeList) {
            contactIdIntakeMap.put(intake.Contact__c, intake);
        }
        List<Contact> conList2 = [SELECT Id, AccountId, Name FROM Contact WHERE Id = :contactIdIntakeMap.keySet()];
        for (Contact con : conList2) {
            accountIdIntakeMap.put(con.AccountId, contactIdIntakeMap.get(con.Id));
        }
        List<Contact> conList = [SELECT Id, Age__c, SSN__c, Gender__c, AccountId FROM Contact WHERE AccountId = :accountIdIntakeMap.keySet()];
        List<Intake_Member__c> intakeMembers = new List<Intake_Member__c>();
        for(Contact con : conList) {
            intakeMembers.add(new Intake_Member__c(Age__c = con.Age__c, 
                SSN__c = con.SSN__c, 
                Gender__c = con.Gender__c, 
                Contact__c = con.Id,
                Intake__c = accountIdIntakeMap.get(con.AccountId).Id
                ));
        }
        insert intakeMembers;
    }

}
