//
//  ApiUrl.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 12/7/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import Foundation
import Alamofire

let url = "http://localhost:3000/v1/"

class ApiUrl {
    
    // Login
    
    let login_url = url + "token"
    
    // Get

    let get_user_url = url + "users/"
    let get_team_url = url + "teams/"
    let get_teams_url = url + "teams"
    
    // Create
    
    let create_users_url = url + "users"
    let create_team_assignments_url = url + "team_assignments"
    let create_survey_url = url + "surveys"
    
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
