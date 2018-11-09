//
//  iOSPlaidFitTests.swift
//  iOSPlaidFitTests
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import XCTest
@testable import iOSPlaidFit

class iOSPlaidFitTests: XCTestCase {

    var goodUser:User!
    var badEmailUser:User!
    var badPhone1User:User!
    var badPhone2User:User!
    var badRoleUser:User!
    var badYearUser:User!
    
    override func setUp() {
        super.setUp()
        
        goodUser = User(id: 1, team_id: 1, first_name: "John", last_name: "Smith", andrew_id: "jsmith", email: "jsmith@gmail.com", phone_number: "1234567890", role: "Player", year: "Senior", missing_daily_boolean: false, missing_post_boolean: false, api_key: "abcd1234")
        
        badEmailUser = User(id: 2, team_id: 1, first_name: "John", last_name: "Smith", andrew_id: "jsmith", email: "jsmith@gmail", phone_number: "5555555555", role: "Player", year: "Senior", missing_daily_boolean: false, missing_post_boolean: false, api_key: "abcd1234")
        
        badPhone1User = User(id: 3, team_id: 1, first_name: "John", last_name: "Smith", andrew_id: "jsmith", email: "jsmith@gmail.com", phone_number: "12345678901", role: "Player", year: "Senior", missing_daily_boolean: false, missing_post_boolean: false, api_key: "abcd1234")
        
        badPhone2User = User(id: 4, team_id: 1, first_name: "John", last_name: "Smith", andrew_id: "jsmith", email: "jsmith@gmail.com", phone_number: "Phone Number", role: "Player", year: "Senior", missing_daily_boolean: false, missing_post_boolean: false, api_key: "abcd1234")
        
        badRoleUser = User(id: 5, team_id: 1, first_name: "John", last_name: "Smith", andrew_id: "jsmith", email: "jsmith@gmail.com", phone_number: "5555555555", role: "Parent", year: "Senior", missing_daily_boolean: false, missing_post_boolean: false, api_key: "abcd1234")
        
        badYearUser = User(id: -1, team_id: 1, first_name: "John", last_name: "Smith", andrew_id: "jsmith", email: "jsmith@gmail.com", phone_number: "5555555555", role: "User", year: "Dropout", missing_daily_boolean: false, missing_post_boolean: false, api_key: "abcd1234")
    }

    override func tearDown() {
        super.tearDown()
        
        goodUser = nil
        badEmailUser = nil
        badPhone1User = nil
        badPhone2User = nil
        badRoleUser = nil
        badYearUser = nil
    }
    
    func testEmail() {
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        assert(emailTest.evaluate(with: goodUser.email!))
        assert(!(emailTest.evaluate(with: badEmailUser.email!)))
    }
    
    func testPhone() {
        let phoneRegEx = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        assert(phoneTest.evaluate(with: goodUser.phone_number!))
        assert(!(phoneTest.evaluate(with: badPhone1User.phone_number!)))
        assert(!(phoneTest.evaluate(with: badPhone2User.phone_number!)))
    }
    
    func testRole() {
        let roles = ["player", "athletic trainer", "coach", "guest"]
        let goodUserRole = goodUser.role!.lowercased()
        let badUserRole = badRoleUser.role!.lowercased()
        assert(roles.contains(goodUserRole))
        assert(!(roles.contains(badUserRole)))
    }
    
    func testYear() {
        let years = ["freshman", "sophomore", "junior", "senior"]
        let goodUserYear = goodUser.year!.lowercased()
        let badUserYear = badYearUser.year!.lowercased()
        assert(years.contains(goodUserYear))
        assert(!(years.contains(badUserYear)))
    }
    
    func testAll() {
        testEmail()
        testPhone()
        testRole()
        testYear()
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
