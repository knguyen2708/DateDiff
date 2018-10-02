//
//  DateCalculator.swift
//  BCG_Test
//
//  Created by Khanh Nguyen on 17/03/2016.
//  Copyright © 2016 knguyen. All rights reserved.
//

extension KNDate {
    /**
     Difference between 2 dates in days. The beginning and end days are consider partial and not included.
     
     For example, difference in days between 07/11/1972 and 08/11/1972 is 0.
     
     `fromDate` must be later than `toDate`.
     
     NOTE: requiring that `fromDate` must be earlier than `toDate` ensures the function's clarity and avoid confusions or misuses.
     */
    static func differenceInDays(from fromDate: KNDate, to toDate: KNDate) throws -> Int {
        /*
         Algorithm idea:
         
         + Find days of full year difference
         e.g. between 20/10/1989 and 18/03/1992 there are full years: 1990 and 1991.
         
         + Find days of full month difference, after removing full years
         e.g. between 20/10/1989 and 18/03/1992 there are full months: 11/1989, 12/1989, 1/1992, 2/1992
         
         + Count the days left, after removing full years and full months
         e.g. between 20/10/1989 and 18/03/1992 there are these day ranges: 21/10/1989 - 31/10/1989 and 01/03/1992 - 18/03/1992
         
         Sum up the above 3 quantities (in fact, we just keep a count, and modify it).
         Parameter checks (ie ensuring fromDate < toDate) are integrated into the flow.
         
         */
        
        // Find days of full years
        var count: Int = 0
        
        for year in stride(from: fromDate.year + 1, through: toDate.year - 1, by: 1) {
            count += KNDate.numberOfDaysInYear(year)
        }
        
        // Find days of full months
        if fromDate.year < toDate.year { // Different years
            
            // Count full months in fromDate
            for month in stride(from: fromDate.month + 1, through: 12, by: 1) {
                count += KNDate.numberOfDaysInMonth(month, year: fromDate.year)
            }
            
            // Count full months in toDate
            for month in stride(from: 1, through: toDate.month - 1, by: 1) {
                count += KNDate.numberOfDaysInMonth(month, year: toDate.year)
            }
            
        } else if fromDate.year == toDate.year { // Same year
            // Count months in [fromDate.month + 1, toDate.month - 1]
            for month in stride(from: fromDate.month + 1, through: toDate.month - 1, by: 1) {
                count += KNDate.numberOfDaysInMonth(month, year: fromDate.year)
            }
            
        } else {
            // fromDate.year > toDate.year
            throw KNError(info: "toDate must be later than fromDate")
        }
        
        // Calculate days, after removing full years and full months
        if fromDate.year < toDate.year || fromDate.month < toDate.month {
            
            // Formula: number of days in [a, b] (including both a or b) is b - a + 1
            
            // Count days in [fromDate.day + 1, last day of fromDate.month]
            count += KNDate.numberOfDaysInMonth(fromDate.month, year: fromDate.year) - (fromDate.day + 1) + 1
            
            // Count days in [1, toDate.day - 1]
            count += (toDate.day - 1) - 1 + 1
            
        } else if fromDate.month == toDate.month {
            // Count days in [fromDate.day, toDate.day], excluding the ends
            // For example [5, 8] has 2 days (8 - 5 - 1)
            if fromDate.day + 1 <= toDate.day {
                count += toDate.day - fromDate.day - 1
                
            } else {
                // fromDate.day = toDate.day or fromDate.day > toDate.day
                throw KNError(info: "toDate must be later than fromDate")
            }
            
        } else {
            throw KNError(info: "toDate must be later than fromDate")
        }
        
        return count
    }
    
    /**
     Returns number of days in a year.
     */
    static func numberOfDaysInYear(_ year: Int) -> Int {
        return isLeapYear(year) ? 366 : 365
    }
    
    /**
     Returns number of days in a month.
     */
    static func numberOfDaysInMonth(_ month: Int, year: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2: return isLeapYear(year) ? 29 : 28
        default: fatalError("invalid month")
        }
    }
    
    /**
     Returns `true` iff `year` is leap.
     */
    static func isLeapYear(_ year: Int) -> Bool {
        return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }
    
}
