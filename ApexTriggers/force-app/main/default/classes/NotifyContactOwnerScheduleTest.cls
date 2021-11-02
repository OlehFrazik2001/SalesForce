@isTest
public class NotifyContactOwnerScheduleTest{
     public static testmethod void test(){

        Test.startTest();
            String CRON_EXP = '0 0 0 ? * * *';
            String jobId = System.schedule('NotifyContactOwnerScheduleTest', CRON_EXP, new NotifyContactOwnerSchedule());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
            System.assertEquals(Date.Today().addDays(1), ct.NextFireTime);   
        Test.stopTest();        
     }
}