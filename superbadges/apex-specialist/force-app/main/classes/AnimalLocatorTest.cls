@isTest
private class AnimalLocatorTest {
@isTest static  void testGet() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        // Call method to test
        String result = AnimalLocator.getAnimalNameById (7);
        System.assertNotEquals(null,result,'The callout returned a null response.');        
        System.assertEquals('dog', result, 'The animal name should be \'dog\'');          
}
}