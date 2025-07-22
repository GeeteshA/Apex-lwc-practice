public class RestrictContactByNameHandler {
    public static void validateRestrictedNames(List<Contact> newContacts) {
        RestrictContactByNameService.checkForInvalidNames(newContacts);
    }
}
