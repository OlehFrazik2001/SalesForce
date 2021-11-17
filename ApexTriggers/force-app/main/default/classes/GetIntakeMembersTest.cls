@isTest
public class GetIntakeMembersTest {

    @isTest
    static void testGetAllMembers() {
        Intake__c intake = new Intake__c();
        insert intake;
        System.assertEquals(0, GetIntakeMembers.getAllMembers(intake.Id).size(), 'No members in a created intake');
    }

    @isTest
    static void updateIntakeMembersTest() {
        List<Intake_Member__c> intakeMembersList = new List<Intake_Member__c>();
        Intake_Member__c intakeMember = new Intake_Member__c(Name='TestingMethod');
        insert intakeMember;
        intakeMember.Gender__c = 'Male';
        intakeMembersList.add(intakeMember);
        GetIntakeMembers.updateIntakeMembers(intakeMembersList);
        Intake_Member__c newIntakeMember = [SELECT Name, Gender__c FROM Intake_Member__c WHERE Name = :intakeMember.Name LIMIT 1];
        
        System.assertEquals('Male', newIntakeMember.Gender__c, 'Member was updated');
    }
}
