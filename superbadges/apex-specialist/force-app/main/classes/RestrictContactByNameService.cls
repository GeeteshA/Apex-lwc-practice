public class RestrictContactByNameService {
    public static void checkForInvalidNames(List<Contact> contacts) {
        for (Contact c : contacts) {
            if (c.LastName != null && c.LastName.trim().equalsIgnoreCase('INVALIDNAME')) {
                c.addError('The Last Name "INVALIDNAME" is not allowed.');
            }
        }
    }
}
