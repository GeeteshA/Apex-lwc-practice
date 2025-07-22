@isTest
private class VerifyDateTest {
    
    @isTest
    static void testDateWithinRange() {
        Date input = Date.newInstance(2021, 5, 20);
        Date result = VerifyDate.checkDate(input);
        System.assertEquals(input, result, 'Should return same date if within range');
    }

    @isTest
    static void testDateOutsideRange() {
        Date input = Date.newInstance(2025, 1, 1);
        Date expected = Date.newInstance(2022, 12, 31).toStartOfMonth().addMonths(1).addDays(-1); 
        Date result = VerifyDate.checkDate(input);
        System.assertEquals(expected, result, 'Should return end of the month within range');
    }
}

