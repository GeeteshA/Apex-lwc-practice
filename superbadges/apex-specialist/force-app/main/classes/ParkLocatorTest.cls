@isTest
private class ParkLocatorTest {
    @isTest static void testCallout() {              
        Test.setMock(WebServiceMock.class, new ParkServiceMock ());
        String country = 'United States';
        List<String> result = ParkLocator.country(country);
        List<String> parks = new List<String>{'Kaziranga National Park', 'Gir National Park', 'Deer Park'};
         System.assertEquals(parks, result); 
    } }