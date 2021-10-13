public with sharing class GetWeather {
    @AuraEnabled(cacheable=true)
    public static List<Weather__c> getWeather() {
        return [SELECT Name, date__c, temperature__c, temp_feels_like__c, weather_description__c FROM Weather__c];
    }
}
