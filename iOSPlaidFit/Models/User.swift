//
//  User.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation

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
    var missing_daily_boolean: Bool?
    var missing_post_boolean: Bool?
    var api_key: String?
    
    // MARK: - General
    
    init(id: Int, team_id: Int, first_name: String, last_name: String, andrew_id: String, email: String, phone_number: String, role: String, year: String, missing_daily_boolean: Bool, missing_post_boolean: Bool, api_key: String) {
        self.id = id
        self.team_id = team_id
        self.first_name = first_name
        self.last_name = last_name
        self.andrew_id = andrew_id
        self.email = email
        self.phone_number = phone_number
        self.role = role
        self.year = year
        self.missing_daily_boolean = missing_daily_boolean
        self.missing_post_boolean = missing_post_boolean
        self.api_key = api_key
    }
    
}
