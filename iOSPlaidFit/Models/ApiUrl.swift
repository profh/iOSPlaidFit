//
//  ApiUrl.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 12/7/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation
import Alamofire

class ApiUrl {
    
    // Login
    
    let login_url = "http://localhost:3000/v1/token"
    
    // Get

    let get_user_url = "http://localhost:3000/v1/users/"
    let get_team_url = "http://localhost:3000/v1/teams/"
    let get_teams_url = "http://localhost:3000/v1/teams"
    
    // Create
    
    let create_users_url = "http://localhost:3000/v1/users"
    let create_team_assignments_url = "http://localhost:3000/v1/team_assignments"
    let create_survey_url = "http:/localhost:3000/v1/surveys"
    
    // Headers

    func getTokenHeader(email: String, password: String) -> HTTPHeaders {
        // format the string that will be encoded with Base64 encoding and then encode it
        let tokenString = NSString(format: "%@:%@", email, password)
        let tokenData: NSData = tokenString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64TokenString = tokenData.base64EncodedString(options: NSData.Base64EncodingOptions())
        return ["Authorization": "Basic \(base64TokenString)"]
    }
    
    func getAuthHeader(_ api_key: String) -> HTTPHeaders {
        return ["Authorization": "Token token=\(api_key)"]
    }
    
    
}
