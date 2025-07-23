@isTest
private class ParkLocatorTest {
    @isTest static void testCallout() {              
        Test.setMock(WebServiceMock.class, new ParkServiceMock());
        
        List<String> result = ParkLocator.country('United States');
        List<String> expected = new List<String>{'Kaziranga National Park', 'Gir National Park', 'Deer Park'};
        
        System.assertEquals(expected, result); 
    }
}
