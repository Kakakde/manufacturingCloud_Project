public with sharing class NewWeatherAPI_Handler implements Queueable, Database.AllowsCallouts {
    private Set<Id> contactIds;

    public NewWeatherAPI_Handler(Set<Id> contactIds) {
        this.contactIds = contactIds;
    }

    public void execute(QueueableContext context) {
        String apiKey = '';
        try {
            OpenWeather_API_Key__mdt apiKeyRecord = [SELECT Key__c FROM OpenWeather_API_Key__mdt WHERE DeveloperName = 'MyAPI_KEY' LIMIT 1];
            apiKey = apiKeyRecord.Key__c;
        } catch (Exception e) {
            System.debug('Error retrieving API Key: ' + e.getMessage());
            return;
        }


        List<Contact> contactsToUpdate = [SELECT Id, MailingCity FROM Contact WHERE Id IN :contactIds];
        String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

        for (Contact con : contactsToUpdate) {
            if (String.isNotBlank(con.MailingCity)) {
                String endpoint = baseUrl + '?q=' + EncodingUtil.urlEncode(con.MailingCity, 'UTF-8') + '&appid=' + apiKey + '&units=metric';
                HttpRequest req = new HttpRequest();
                req.setEndpoint(endpoint);
                req.setMethod('GET');

                try {
                    Http http = new Http();
                    HttpResponse res = http.send(req);
                    if (res.getStatusCode() == 200) {
                        Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                        Map<String, Object> main = (Map<String, Object>) responseBody.get('main');
                        List<Object> weatherList = (List<Object>) responseBody.get('weather');
                        if (weatherList != null && !weatherList.isEmpty()) {
                            Map<String, Object> weather = (Map<String, Object>) weatherList[0];
                            con.Weather_Condition__c = (String) weather.get('description');
                        }
                        con.Temperature__c = main != null ? (Decimal) main.get('temp') : null;
                        con.Humidity__c = main != null ? (Decimal) main.get('humidity') : null;
                    } else {
                        System.debug('Error from Weather API: ' + res.getBody());
                    }
                } catch (Exception e) {
                    System.debug('Exception during API call: ' + e.getMessage());
                }
            }
        }

        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }
}