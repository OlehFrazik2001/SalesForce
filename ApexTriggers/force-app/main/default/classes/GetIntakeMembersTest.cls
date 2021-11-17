@isTest
public class GetIntakeMembersTest {

    @TestSetup
    static void createTestData() {
        Account acc = new Account(Name='TestAccount');
        insert acc;
        List<Contact> conList = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            Contact con = new Contact(LastName='TestContact' + i, AccountId = acc.Id);
            conList.add(con);
        }
        insert conList;
        System.debug('Contacts ' + conList);
    }

    @isTest
    public static void testSomething() {
        List<Contact> conList = [SELECT Id, AccountId FROM Contact WHERE LastName LIKE 'TestContact%'];
        System.debug('Contacts ' + conList);
        Intake__c intake = new Intake__c(Name='TestIntake', Contact__c = conList[0].Id);
        System.debug('intake ' + intake);
        insert intake;
        System.debug('Intake ' + intake);
        intake = [SELECT Id FROM Intake__c ];
        List<Intake_Member__c> intakeMembers = [SELECT Id FROM Intake_Member__c];
        System.assertEquals(5, intakeMembers.size());
    }
}
