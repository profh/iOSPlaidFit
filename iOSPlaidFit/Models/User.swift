//
//  User.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation
import CoreData

class User {
    
    // MARK: - Properties
    var id: Int?
    var team_id: Int?
    var first_name: String?
    var last_name: String?
    var andrew_id: String?
    var email: String?
    var phone_number: String?
    var role: String?
    var year: String?
    var major: String?
    var missing_daily_boolean: Bool?
    var missing_post_boolean: Bool?
    var api_key: String?
    var team_string: String?
    
    // MARK: - General
    
    init(id: Int, team_id: Int, first_name: String, last_name: String, andrew_id: String, email: String, phone_number: String, role: String, year: String, major: String, missing_daily_boolean: Bool, missing_post_boolean: Bool, api_key: String, team_string: String) {
        self.id = id
        self.team_id = team_id
        self.first_name = first_name
        self.last_name = last_name
        self.andrew_id = andrew_id
        self.email = email
        self.phone_number = phone_number
        self.role = role
        self.year = year
        self.major = major
        self.missing_daily_boolean = missing_daily_boolean
        self.missing_post_boolean = missing_post_boolean
        self.api_key = api_key
        self.team_string = team_string
    }
    
    // https://stackoverflow.com/questions/32364055/formattting-phone-number-in-swift
    func formatPhone() -> String? {
        // Remove any character that is not a number
        let numbersOnly = self.phone_number?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly?.count
        let hasLeadingOne = numbersOnly?.hasPrefix("1")
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne!) else {
            return nil
        }
        let hasAreaCode = (length! >= 10)
        var sourceIndex = 0
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne! {
            leadingOne = "1 "
            sourceIndex += 1
        }
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly!.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly!.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly!.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
}
