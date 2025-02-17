public class OpportunityToSalesAgreementService implements Queueable, Database.AllowsCallouts {
    private Id opportunityId;

    public OpportunityToSalesAgreementService(Id opportunityId) {
        this.opportunityId = opportunityId;
    }

    public void execute(QueueableContext context) {
        String baseUrl = System.Url.getOrgDomainUrl().toExternalForm();
        String endpoint = baseUrl + '/services/data/v59.0/connect/manufacturing/sales-agreements';

        // Prepare the request body
        Map<String, Object> requestBodyMap = new Map<String, Object>{
            'sourceObjectId' => opportunityId, // Use dynamic Opportunity ID
        
            'salesAgreementDefaultValues' => new Map<String, Object> {
                'salesAgreement' => new Map<String, Object> {
                    'StartDate' => '2020-10-05', // Use a valid date
                    'ScheduleFrequency' => 'Monthly',
                    'ScheduleCount' => 10, // Integer value
                    'PricebookId' => '01sWs000001Qf7uIAC', // Example PricebookId
                    'Name' => 'Test Sales Agreement 2'
                },
                'salesAgreementProduct' => new Map<String, Object> {
                    'PricebookEntry' => '01uWs000002EIX9IAO', // Example PricebookEntry
                    'Name' => 'Test Product - Version 3',
                    'InitialPlannedQuantity' => 1 // Integer value
                }
            }
        };
        

        // Serialize the request body
        String requestBody = JSON.serialize(requestBodyMap);
        System.debug('📌 Request Body: ' + requestBody); // Debug log for verification

        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setHeader('Content-Type', 'application/json');
        req.setBody(requestBody);
        req.setTimeout(120000); // Increased timeout

        Http http = new Http();
        HttpResponse res;

        try {
            res = http.send(req);
            System.debug('🔄 Response Status: ' + res.getStatusCode());
            System.debug('📌 Response Body: ' + res.getBody());

            // Check if response is successful
            if (res.getStatusCode() == 201 || res.getStatusCode() == 200) {
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                if (jsonResponse.containsKey('id')) {
                    String salesAgreementId = (String) jsonResponse.get('id');
                    System.debug('✅ Created Sales Agreement ID: ' + salesAgreementId);
                } else {
                    System.debug('⚠ No ID returned in response. Response Body: ' + res.getBody());
                }
            } else {
                // Improved error handling for response body
                System.debug('❌ Error: ' + res.getStatusCode() + ' - ' + res.getBody());
            }
        } catch (CalloutException e) {
            System.debug('⚠ Callout Exception: ' + e.getMessage());
        } catch (Exception e) {
            System.debug('⚠ General Exception: ' + e.getMessage());
        }
    }
}
