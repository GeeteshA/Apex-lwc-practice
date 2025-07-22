@isTest
private class TestRestrictContactByName {
    
    @isTest
    static void testInsertInvalidName() {
        Contact invalidContact = new Contact(FirstName='Test', LastName='INVALIDNAME');
        Test.startTest();
        try {
            insert invalidContact;
            System.assert(false, 'Insert should have failed due to INVALIDNAME');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The Last Name "INVALIDNAME" is not allowed.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateInvalidName() {
        Contact validContact = new Contact(FirstName='Test', LastName='Valid');
        insert validContact;

        validContact.LastName = 'INVALIDNAME';
        Test.startTest();
        try {
            update validContact;
            System.assert(false, 'Update should have failed due to INVALIDNAME');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The Last Name "INVALIDNAME" is not allowed.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testValidInsertUpdate() {
        Contact c = new Contact(FirstName='Test', LastName='Valid');
        insert c;

        c.LastName = 'AlsoValid';
        update c;

        Contact fetched = [SELECT LastName FROM Contact WHERE Id = :c.Id];
        System.assertEquals('AlsoValid', fetched.LastName);
    }
}
