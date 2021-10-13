import { LightningElement, track, wire} from 'lwc';
import getWeather from '@salesforce/apex/GetWeather.getWeather';

export default class allWeather extends LightningElement {
     @track columns = [
          { label: 'City', fieldName: 'Name' },
          { label: 'Temperature', fieldName: 'temperature__c' },
          { label: 'Temperature (Feels like)', fieldName: 'temp_feels_like__c' },
          { label: 'Description', fieldName: 'weather_description__c' },
          { label: 'Date', fieldName: 'date__c'}
      ];
     @track weatherList;

     @wire (getWeather) wiredWeather({data,error}){
          if (data) {
               this.weatherList = data;
          console.log(data); 
          } else if (error) {
          console.log(error);
          }
     }
}