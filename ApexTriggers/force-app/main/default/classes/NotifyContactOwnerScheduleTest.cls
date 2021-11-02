@isTest
public class NotifyContactOwnerScheduleTest{
     public static testmethod void test(){
        Test.startTest();
            String CRON_EXP = '0 0 6 ? * * *';
            String jobId = System.schedule('NotifyContactOwnerScheduleTest', CRON_EXP, new NotifyContactOwnerSchedule());
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
            System.assertEquals('2021-11-03 06:00:00', String.valueOf(ct.NextFireTime));   
        Test.stopTest();        
     }
}