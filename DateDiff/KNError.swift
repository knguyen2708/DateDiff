//
//  KNError.swift
//  BCG_Test
//
//  Created by Khanh Nguyen on 19/04/2016.
//  Copyright © 2016 knguyen. All rights reserved.
//

import Foundation

/**
 Represents an error in KN.
 */
class KNError: Error {
    var _domain: String { return "KN" }
    var _code: Int { return -1 }

    /**
     Info related to the error.
     */
    let info: String

    /**
     Constructs an instance with related info.
     */
    init(info: String) {
        self.info = info
    }
}
