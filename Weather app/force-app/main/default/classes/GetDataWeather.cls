global with sharing class GetDataWeather implements Schedulable{
    @future(callout=true)
    static void getResponce(){
        List<Weather_setting__c> ws = [SELECT Name, Language__c FROM Weather_setting__c LIMIT 1];
        Weather_setting__c wsItem = ws[0];
        String apiKey = '771db49d62dcc3111546dc5ecad97ebf';
        String requestEndpoint = 'https://api.openweathermap.org/data/2.5/weather';
		    requestEndpoint += '?q=' + wsItem.Name;
		    requestEndpoint += '&appid=' + apiKey;
            requestEndpoint += '&lang=' + wsItem.Language__c;
		    Http http = new Http();
		    HttpRequest request = new HttpRequest();
		    request.setEndpoint(requestEndpoint);
		    request.setMethod('GET');
		    HttpResponse response = http.send(request);

            Weather__c newCity = new Weather__c();
        
            if (response.getStatusCode() == 200) {
                Map<string,object> results=( Map<string,object>)JSON.deserializeUntyped(response.getBody());
                newCity.Name = String.valueOf(results.get('name')); 
                Map<string,object> mainresults=( Map<string,object>)(results.get('main'));
                newCity.temperature__c = decimal.valueOf(string.valueOf(mainresults.get('temp')));
                newCity.pressure__c = decimal.valueOf(string.valueOf(mainresults.get('pressure')));
                newCity.humidity__c = decimal.valueOf(string.valueOf(mainresults.get('humidity')));
                newCity.temp_feels_like__c = decimal.valueOf(string.valueOf(mainresults.get('feels_like')));
                Map<string,object> wind=( Map<string,object>)(results.get('wind'));
                newCity.wind_speed__c = decimal.valueOf(string.valueOf(wind.get('speed')));
                // List<Map<String, Object>> weat=( List<Map<String, Object>>)(results.get('weather'));
                // System.debug(weat[0]);
                List<Object> weat=( List<Object>)(results.get('weather'));
                Map<String, Object> firstMap = (Map<String, Object>)weat[0];
                newCity.weather_description__c = string.valueOf(firstMap.get('description'));
                Map<string,object> coord=( Map<string,object>)(results.get('coord'));
                newCity.longtitude__c = decimal.valueOf(string.valueOf(coord.get('lon')));
                newCity.lattitude__c = decimal.valueOf(string.valueOf(coord.get('lat')));
                insert newCity;
            }
    }  
    global void execute(SchedulableContext ctx) {
        getResponce();
    }
}
