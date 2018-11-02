//
//  LoginViewController.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire

class LoginViewController: UIViewController {

    // MARK: - Properties
    
    let login_url = "http://localhost:3000/v1/token"
    var loggedInUser: User? = nil
    var teams = [(String, Int)]()
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var errorField: UILabel!
    
    // MARK: - Functional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.hidesWhenStopped = true // hide the loading animation when nothing is loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the nav bar so users can't go back to home page if they log out
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        loadingView.startAnimating() // start the loading animation for the duration of the API call
        // format the string that will be encoded with Base64 encoding and then encode it
        let loginString = NSString(format: "%@:%@", emailField.text!, passwordField.text!)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: NSData.Base64EncodingOptions())
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64LoginString)"
        ]
        Alamofire.request(login_url, headers: headers).responseJSON{ response in
            // need to handle errors too!
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                print(JSON)
                // only athletes (players) can log in
                if (JSON["role"]! as! String) != "Player" {
                    self.errorField.text = "Sorry! Only athletes can log in."
                    self.loadingView.stopAnimating()
                } else {
                    self.loggedInUser = User(id: JSON["id"]! as! Int, first_name: JSON["first_name"]! as! String, last_name: JSON["last_name"]! as! String, andrew_id: JSON["andrew_id"]! as! String, email: JSON["email"]! as! String, phone_number: JSON["phone"]! as! String, role: JSON["role"]! as! String, year: JSON["year"]! as! String, missing_daily_boolean: JSON["missing_daily_boolean"]! as! Bool, missing_post_boolean: JSON["missing_post_boolean"]! as! Bool, api_key: JSON["api_key"]! as! String)
                    self.loadingView.stopAnimating() // stop the loading animation after a user has logged in and the API call is done
                    self.performSegue(withIdentifier: "loginSegue", sender: sender)
                    
                }
            }
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        loadingView.startAnimating() // start the loading animation for the duration of the API call
        // prep the team picker here
        let get_teams_url = "http://localhost:3000/v1/teams"
        let headers: HTTPHeaders = [
            // hard-coding token value as user ID 1's value for now
            // b/c can't authorize creation when signing up a new user
            "Authorization": "Token token=b8b254b72f725987677f0a00f80c0017"
        ]
        Alamofire.request(get_teams_url, headers: headers).responseJSON{ response in
            if let result = response.result.value as? [[String: Any]] {
                for team in result {
                    let gender = team["gender"]! as! String
                    let sport = team["sport"]! as! String
                    let team_id = team["id"]! as! Int
                    self.teams.append((gender + "'s " + sport, team_id))
                }
                self.loadingView.stopAnimating() // stop the loading animation after the teams have been fetched from the API
                self.performSegue(withIdentifier: "goToSignupScreenSegue", sender: sender)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            // set the destination as the Home page and set the current user to the recently logged in user
            let nav = segue.destination as! UINavigationController
            let hvc = nav.topViewController as! HomeViewController
            hvc.currentUser = loggedInUser
        } else if segue.identifier == "goToSignupScreenSegue" {
            let nav = segue.destination as! SignupViewController
            nav.teams = teams
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "loginSegue" {
                // do not perform segue if, for any reason, user failed to log in
                if loggedInUser == nil {
                    return false
                }
            } else if ident == "goToSignupScreenSegue" {
                // do not perform segue if the teams have not been fetched yet
                if teams.isEmpty {
                    return false
                }
            }
        }
        return true
    }

}
