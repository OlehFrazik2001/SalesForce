@isTest
public with sharing class GetDataWeatherTest{
    private class RestMock implements HttpCalloutMock {
        
        public HTTPResponse respond(HTTPRequest req) {
            String fullJson = '{"coord":{"lon":24.0232,"lat":49.8383},"weather":[{"id":803,"main":"Clouds","description":"рвані хмари","icon":"04n"}],"base":"stations","main":{"temp":279.36,"feels_like":279.36,"temp_min":278.93,"temp_max":279.36,"pressure":1013,"humidity":100},"visibility":10000,"wind":{"speed":0,"deg":0},"clouds":{"all":75},"dt":1634066823,"sys":{"type":1,"id":8909,"country":"UA","sunrise":1634013636,"sunset":1634053190},"timezone":10800,"id":702550,"name":"Lviv","cod":200}';
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'text/json');
            res.setBody(fullJson);
            res.setStatusCode(200);
            return res;
        }
    }
    @isTest
    public static void test(){
        Weather_setting__c ws = new Weather_setting__c();
        ws.Name = 'Lviv';
        ws.Language__c = 'en';
        insert ws;
        Test.setMock(HttpCalloutMock.class, new RestMock());
        test.startTest();
            System.schedule('jobName','0 0 * * * ?',new GetDataWeather());
        test.stopTest();
    }

}