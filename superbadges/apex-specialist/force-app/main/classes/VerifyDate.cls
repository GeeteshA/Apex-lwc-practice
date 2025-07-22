public class VerifyDate {
    public static Date checkDate(Date inputDate) {
        Date startDate = Date.newInstance(2020, 1, 1);
        Date endDate = Date.newInstance(2022, 12, 31);
        
        if (inputDate >= startDate && inputDate <= endDate) {
            return inputDate;
        } else {
            // Return last day of the month within range
            return endDate.toStartOfMonth().addMonths(1).addDays(-1);
        }
    }
}
