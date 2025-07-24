public class ParkLocator {
    public static List<String> country(String theCountry) {
        ParkService.ParksImplPort parkService = new ParkService.ParksImplPort();
        return parkService.byCountry(theCountry);
    }
}
