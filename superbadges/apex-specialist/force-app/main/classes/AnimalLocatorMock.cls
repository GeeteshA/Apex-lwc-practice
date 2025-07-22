@isTest
global class AnimalLocatorMock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"animal":{"id":7,"name":"dog","eats":"meat","says":"i am a lovely pet animal"}}');
        response.setStatusCode(200);
        return response; 
    }
}
