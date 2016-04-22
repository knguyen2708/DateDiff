//
//  Tests.swift
//  Tests
//
//  Created by Khanh Nguyen on 19/04/2016.
//  Copyright © 2016 knguyen. All rights reserved.
//

import XCTest
import BCG_Test

@testable import BCG_Test

class KNDate_Tests: XCTestCase {
    
    /**
     Tests the basic initializer `KNDate(day:month:year:)`
     
     Normal and error cases are tested.
     */
    func testBasicInitializer() {
        let z = try! KNDate(day: 27, month: 8, year: 1985)
        XCTAssert(z.day == 27)
        XCTAssert(z.month == 08)
        XCTAssert(z.year == 1985)
        
        // Invalid day, month
        XCTAssertThrowsError(try KNDate(day: 0, month: 8, year: 1985))
        XCTAssertThrowsError(try KNDate(day: 32, month: 8, year: 1985))
        XCTAssertThrowsError(try KNDate(day: 27, month: 0, year: 1985))
        XCTAssertThrowsError(try KNDate(day: 27, month: 13, year: 1985))
        
        // We don't support years outside 1901 and 2999
        XCTAssertThrowsError(try KNDate(day: 27, month: 8, year: 1885))
        XCTAssertThrowsError(try KNDate(day: 27, month: 8, year: 3000))
    }
    
    /**
     Tests the string initializer `KNDate(string:)`
     
     Normal and error cases are tested.
     */
    func testStringInitializer() {
        
        do {
            let z = try! KNDate(string: "27/08/1985")
            XCTAssert(z.day == 27)
            XCTAssert(z.month == 08)
            XCTAssert(z.year == 1985)
        }

        // malform dates
        XCTAssertThrowsError(try KNDate(string: ""))
        XCTAssertThrowsError(try KNDate(string: "a"))
        XCTAssertThrowsError(try KNDate(string: "15"))
        XCTAssertThrowsError(try KNDate(string: "27/08"))
        XCTAssertThrowsError(try KNDate(string: "08/1985"))
        
        XCTAssertThrowsError(try KNDate(string: "a27/08/1985"))
        XCTAssertThrowsError(try KNDate(string: "31/b08/1985"))
        XCTAssertThrowsError(try KNDate(string: "31/08/c1985"))
        XCTAssertThrowsError(try KNDate(string: "31/08/ 1985"))
    }
    
    /**
     Tests `KNDate.differenceInDays(fromDate:toDate:)` -- the error cases.
     
     Happens when `fromDate` is less than `toDate`.
     */
    func testCountMethod_ErrorCases() {
        // start date > end date cases
        XCTAssertThrowsError(try KNDate_count("22/06/1983", "21/06/1983"))
        XCTAssertThrowsError(try KNDate_count("02/06/1983", "22/05/1983"))
        XCTAssertThrowsError(try KNDate_count("02/06/1983", "22/06/1982"))
    }
    
    /**
     Tests `KNDate.differenceInDays(fromDate:toDate:)` against `NSDate`'s implementation.
     
     This one uses the sample data (in the question).
     */
    func testSampleData() throws {
        do {
            let (start, end) = ("02/06/1983", "22/06/1983")
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }

        do {
            let (start, end) = ("04/08/1984", "25/12/1984") // This is 142, not 173 as claimed in the sample cases!
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }

        do {
            let (start, end) = ("03/08/1983", "03/01/1989")
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }
    }
    
    /**
     Tests `KNDate.differenceInDays(fromDate:toDate:)` against `NSDate`'s implementation

     This one makes sure every single line of code (apart from exceptional cases, which are tested in `testCountMethod_ErrorCases`) are covered.
     */
    func testWhiteBoxCases() throws {
        do {
            let (start, end) = ("03/06/1950", "04/06/1950") // Next day
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }

        do {
            let (start, end) = ("03/06/1950", "05/06/1950") // Same month
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }

        do {
            let (start, end) = ("03/06/1949", "05/07/1950") // 1 month apart
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }

        do {
            let (start, end) = ("31/12/1950", "01/01/1951") // Next year
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }

        do {
            let (start, end) = ("31/12/1950", "01/01/1952") // 1 year apart
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }

        do {
            let (start, end) = ("03/01/1952", "05/10/1952") // 10 month apart in a leap year, including Feb
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }

        do {
            let (start, end) = ("03/06/1951", "05/07/1953") // 2 years apart, including leap year
            XCTAssertEqual(try KNDate_count(start, end), try NSDate_count(start, end))
        }
    }
    
    /**
     Shortcut to `KNDate.differenceInDays(fromDate:toDate:)` which takes two strings.
     */
    private func KNDate_count(fromDateString: String, _ toDateString: String) throws -> Int {
        return try KNDate.differenceInDays(fromDate: try KNDate(string: fromDateString), toDate: try KNDate(string: toDateString))
    }
    
    /**
     Count difference in days using `NSDate`.
     */
    private func NSDate_count(fromDateString: String, _ toDateString: String) throws -> Int {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "dd/MM/yyyy"
        let fromDate = fmt.dateFromString(fromDateString)!
        let toDate = fmt.dateFromString(toDateString)!
        
        var optFromDateDay: NSDate?, optToDateDay: NSDate?
        
        let calendar = NSCalendar.currentCalendar()
        calendar.rangeOfUnit(.Day, startDate: &optFromDateDay, interval: nil, forDate: fromDate)
        calendar.rangeOfUnit(.Day, startDate: &optToDateDay, interval: nil, forDate: toDate)
        
        guard let fromDateDay = optFromDateDay else { throw NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid fromDateString"]) }
        guard let toDateDay = optToDateDay else { throw NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "invalid toDateString"]) }
        
        let difference = calendar.components(.Day, fromDate: fromDateDay, toDate: toDateDay, options: [])
        return difference.day - 1 // -1 due to the way NSDate calculate the difference
    }
}