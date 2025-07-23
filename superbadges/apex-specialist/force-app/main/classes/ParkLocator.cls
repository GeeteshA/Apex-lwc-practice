public class ParkLocator {
    public static List<String> country(String theCountry) {
        ParkService.ParksPort parkService = new ParkService.ParksPort();
        return parkService.byCountry(theCountry); 
    }
}
