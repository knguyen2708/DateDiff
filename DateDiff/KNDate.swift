//
//  KNDate.swift
//  BCG_Test
//
//  Created by Khanh Nguyen on 17/03/2016.
//  Copyright © 2016 knguyen. All rights reserved.
//

import UIKit

/**
 Represents a date.
 
 This was made a structure instead of class, since it's just a set of integers.
 
 Made immutable for simplicity.
 */
struct KNDate {
    /**
     Day. Between 1 and 31 inclusively.
     */
    let day: Int
    
    /**
     Month. Between 1 and 12 inclusively.
     */
    let month: Int
    
    /**
     Year. Between 1901 and 2999 inclusively.
     */
    let year: Int
    
    /**
     Constructs a date. `day`, `month`, `year` together must form a valid date.
     */
    init(day: Int, month: Int, year: Int) throws {
        // Validations
        
        guard 1901 <= year && year <= 2999 else {
            throw KNError(info: "year must be between 1901 and 2999")
        }

        guard 1 <= month && month <= 12 else {
            throw KNError(info: "month must be between 1 and 10 inclusively")
        }
        
        let maxDay = KNDate.numberOfDaysInMonth(month, year: year)
        
        guard 1 <= day && day <= maxDay else {
            throw KNError(info: "day must be between 1 and \(maxDay)")
        }
        
        self.day = day
        self.month = month
        self.year = year
    }

    /**
     The minimum date supported by `KNDate`.
     */
    static let minDate: KNDate = try! KNDate(day: 1, month: 1, year: 1901)

    /**
     The maximum date supported by `KNDate`.
     */
    static let maxDate: KNDate = try! KNDate(day: 31, month: 12, year: 2999)
}

// Constructor using string
extension KNDate {
    /**
     Constructs a date from a string. The format must be "dd/MM/yyyy".
     */
    init(string: String) throws {
        let nsstring = string as NSString
        
        // Parse the string
        let matches = KNDate.dateFormatRegex.matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, string.unicodeScalars.count))
        
        // If regex doesn't match, it means `string` doesn't conform to dd/MM/yyyy format.
        guard let match = matches.first else { throw KNError(info: "string must conform to date format dd/MM/yyyy") }
        
        // Extract date components
        // Conversion from string -> int won't fail because of the regex pattern
        let dayRange = match.rangeAtIndex(1)
        let dayString = nsstring.substringWithRange(dayRange)
        let day = KNDate.integerFormatter.numberFromString(dayString)!.integerValue
        
        let monthRange = match.rangeAtIndex(2)
        let monthString = nsstring.substringWithRange(monthRange)
        let month = KNDate.integerFormatter.numberFromString(monthString)!.integerValue
        
        let yearRange = match.rangeAtIndex(3)
        let yearString = nsstring.substringWithRange(yearRange)
        let year = KNDate.integerFormatter.numberFromString(yearString)!.integerValue
        
        try self.init(day: day, month: month, year: year)
    }
    
    // Regexes and formatters are expensive to create. Make sure they are created only once.
    // Static constants in Swift are lazy-initialized and created in a thread-safe manner.
    private static let dateFormatRegex: NSRegularExpression = try! NSRegularExpression(pattern: "^(\\d{1,2})/(\\d{1,2})/(\\d{4})$", options: .CaseInsensitive)
    private static let integerFormatter: NSNumberFormatter = {
        let formatter = NSNumberFormatter()
        return formatter
    }()
}

extension KNDate: CustomStringConvertible {
    var description: String {
        return "\(day)/\(month)/\(year)"
    }
}