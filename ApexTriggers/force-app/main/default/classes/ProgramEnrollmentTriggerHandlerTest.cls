@isTest
private class ProgramEnrollmentTriggerHandlerTest {
   static testMethod void testOdesaDirectorShareEdit(){
    List<UserRole> OdesaDirectorRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Odesa_Director'];
    List<Group> OdesaDirectorGroup = [SELECT Id FROM Group WHERE Type = 'Role' AND DeveloperName = 'Odesa_Director'];
    Profile p = [SELECT Id FROM Profile WHERE Name='Custom:SalesUser']; 
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='user123456@testorg.com.com', UserRoleId = OdesaDirectorRole[0].Id);

    System.runAs(u) {
        Program_Enrollment__c peOdesa = new Program_Enrollment__c(city__c = 'Odesa');
        insert peOdesa;
        List<Program_Enrollment__c> peOdesaList = [SELECT Id FROM Program_Enrollment__c WHERE city__c = 'Odesa' AND OwnerId = :u.Id];
        List<Program_Enrollment__Share> progs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause FROM Program_Enrollment__Share WHERE ParentId = :peOdesaList[0].Id AND UserOrGroupId= :OdesaDirectorGroup[0].Id];
        System.assertEquals(progs.size(), 1, 'Set the object\'s sharing model to Private.');
        System.assertEquals(progs[0].AccessLevel, 'Edit', 'Test permission');
        System.assertEquals(progs[0].RowCause, 'OdesaDirector__c', 'Test RowCause');
        System.assertEquals(progs[0].UserOrGroupId, OdesaDirectorGroup[0].Id, 'Test to which users is shared');
        Program_Enrollment__c peOdesa2 = new Program_Enrollment__c(city__c = 'Lviv');
        delete peOdesa;
        insert peOdesa2;
        peOdesa2.city__c = 'Odesa';
        update peOdesa2;
        peOdesaList = [SELECT Id FROM Program_Enrollment__c WHERE city__c = 'Odesa' AND OwnerId = :u.Id];
        progs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause FROM Program_Enrollment__Share WHERE ParentId = :peOdesaList[0].Id AND UserOrGroupId= :OdesaDirectorGroup[0].Id];
        System.assertEquals(progs.size(), 1, 'Set the object\'s sharing model to Private.');
        System.assertEquals(progs[0].AccessLevel, 'Edit', 'Test permission');
        System.assertEquals(progs[0].RowCause, 'OdesaDirector__c', 'Test RowCause');
        System.assertEquals(progs[0].UserOrGroupId, OdesaDirectorGroup[0].Id, 'Test to which users is shared');
        }
   } 
   
   static testMethod void testKyivDirectorShareEdit(){
    List<UserRole> KyivDirectorRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'Kyiv_Director'];
    List<Group> KyivDirectorGroup = [SELECT Id FROM Group WHERE Type = 'RoleAndSubordinates' AND DeveloperName = 'Kyiv_Director'];
    Profile p = [SELECT Id FROM Profile WHERE Name='Custom:SalesUser']; 
    User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='user123457@testorg.com.com', UserRoleId = KyivDirectorRole[0].Id);

    System.runAs(u) {
        Program_Enrollment__c peKyiv = new Program_Enrollment__c(city__c = 'Kyiv');
        insert peKyiv;
        List<Program_Enrollment__c> peKyivList = [SELECT Id FROM Program_Enrollment__c WHERE city__c = 'Kyiv' AND OwnerId = :u.Id];
        List<Program_Enrollment__Share> progs = [SELECT Id, UserOrGroupId, AccessLevel, RowCause FROM Program_Enrollment__Share WHERE ParentId = :peKyivList[0].Id AND UserOrGroupId = :KyivDirectorGroup[0].Id];
        System.assertEquals(progs.size(), 1, 'Set the object\'s sharing model to Private.');
        System.assertEquals(progs[0].AccessLevel, 'Edit', 'Test permission');
        System.assertEquals(progs[0].RowCause, 'KyivDirector__c', 'Test RowCause');
        System.assertEquals(progs[0].UserOrGroupId, KyivDirectorGroup[0].Id, 'Test to which users is shared');
        }
   }  
}