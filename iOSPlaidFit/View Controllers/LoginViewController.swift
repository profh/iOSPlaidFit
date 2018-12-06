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
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    
    let login_url = "http://localhost:3000/v1/token"
    var loggedInUser: User? = nil
    var teams = [(String, Int)]()
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var errorField: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Core Data Stuff
    
    func saveUser(_ user: User) {
        // Connect to the context for the container stack
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        // Specifically select the People entity to save this object to
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        // Set values one at a time and save
        newUser.setValue(user.id, forKey: "id")
        newUser.setValue(user.team_id, forKey: "team_id")
        newUser.setValue(user.first_name, forKey: "first_name")
        newUser.setValue(user.last_name, forKey: "last_name")
        newUser.setValue(user.andrew_id, forKey: "andrew_id")
        newUser.setValue(user.email, forKey: "email")
        newUser.setValue(user.phone_number, forKey: "phone_number")
        newUser.setValue(user.role, forKey: "role")
        newUser.setValue(user.year, forKey: "year")
        newUser.setValue(user.major, forKey: "major")
        newUser.setValue(user.missing_post_boolean, forKey: "missing_post_boolean")
        newUser.setValue(user.missing_daily_boolean, forKey: "missing_daily_boolean")
        newUser.setValue(user.api_key, forKey: "api_key")
        newUser.setValue(user.team_string, forKey: "team_string")
        do {
            try context.save()
            print("successfully saved user!")
        } catch {
            print("Failed saving user")
        }
    }
    
    func loadUser(_ data: NSManagedObject) {
        let id = data.value(forKey: "id") as! Int
        let team_id = data.value(forKey: "team_id") as! Int
        let first_name = data.value(forKey: "first_name") as! String
        let last_name = data.value(forKey: "last_name") as! String
        let andrew_id = data.value(forKey: "andrew_id") as! String
        let email = data.value(forKey: "email") as! String
        let phone_number = data.value(forKey: "phone_number") as! String
        let role = data.value(forKey: "role") as! String
        let year = data.value(forKey: "year") as! String
        let major = data.value(forKey: "major") as! String
        let missing_post_boolean = data.value(forKey: "missing_post_boolean") as! Bool
        let missing_daily_boolean = data.value(forKey: "missing_daily_boolean") as! Bool
        let api_key = data.value(forKey: "api_key") as! String
        let team_string = data.value(forKey: "team_string") as! String
        self.loggedInUser = User(id: id, team_id: team_id, first_name: first_name, last_name: last_name, andrew_id: andrew_id, email: email, phone_number: phone_number, role: role, year: year, major: major, missing_daily_boolean: missing_daily_boolean, missing_post_boolean: missing_post_boolean, api_key: api_key, team_string: team_string)
    }
    
    // MARK: - Functional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup the loading animation
        loadingView.hidesWhenStopped = true // hide the loading animation when nothing is loading
        // set the text fields
        self.errorField.text = ""
        self.emailField.delegate = self
        self.passwordField.delegate = self
        // disable button for now
        loginButton.isEnabled = false
        loginButton.setTitleColor(UIColor.lightGray, for: .disabled)
        // Loading user from CoreData if exists
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        print("Here")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                self.loadUser(data)
                print("user successfully loaded")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
        } catch {
            print("Failed")
        }
        // background image
        let backgroundImage = UIImage(named: "pic_background")
        let backgroundImageView = UIImageView(frame: self.view.frame)
        backgroundImageView.image = backgroundImage
        self.view.insertSubview(backgroundImageView, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the nav bar so users can't go back to home page if they log out
        self.navigationController?.isNavigationBarHidden = true
        self.errorField.text = ""
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        self.errorField.text = ""
        loadingView.startAnimating() // start the loading animation for the duration of the API call
        // format the string that will be encoded with Base64 encoding and then encode it
        let loginString = NSString(format: "%@:%@", emailField.text!, passwordField.text!)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: NSData.Base64EncodingOptions())
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64LoginString)"
        ]
        Alamofire.request(login_url, headers: headers).responseJSON{ response in
            if let error = response.error {
                self.errorField.text = error.localizedDescription
                self.loadingView.stopAnimating()
            }
            if let status = response.response?.statusCode {
                print(status)
                if status == 401 {
                    self.errorField.text = "Incorrect email/password."
                    self.loadingView.stopAnimating()
                }
            }
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                // Use this "JSON" variable to access the weekly survey objects
                // daily_wellness_survey_weekly_objects
                // post_practice_survey_weekly_objects
                print(JSON)
                // only athletes (players) can log in
                if (JSON["role"]! as! String) != "Player" {
                    self.errorField.text = "Sorry! Only athletes can log in."
                    self.loadingView.stopAnimating()
                } else {
                    self.loggedInUser = User(id: JSON["id"]! as! Int, team_id: (JSON["team_assignments"] as? [[String:Any]])?.first?["team_id"] as! Int, first_name: JSON["first_name"]! as! String, last_name: JSON["last_name"]! as! String, andrew_id: JSON["andrew_id"]! as! String, email: JSON["email"]! as! String, phone_number: JSON["phone"]! as! String, role: JSON["role"]! as! String, year: JSON["year"]! as! String, major: JSON["major"]! as! String, missing_daily_boolean: JSON["missing_daily_boolean"]! as! Bool, missing_post_boolean: JSON["missing_post_boolean"]! as! Bool, api_key: JSON["api_key"]! as! String, team_string: "")
                    self.saveUser(self.loggedInUser!)
                    self.loadingView.stopAnimating() // stop the loading animation after a user has logged in and the API call is done
                    self.performSegue(withIdentifier: "loginSegue", sender: sender)
                }
            }
        }
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        if self.teams.isEmpty {
            loadingView.startAnimating() // start the loading animation for the duration of the API call
            let get_teams_url = "http://localhost:3000/v1/teams"
            let headers: HTTPHeaders = [
                // hard-coding token value as user ID 1's value for now
                // b/c can't authorize creation when signing up a new user
                "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
            ]
            Alamofire.request(get_teams_url, headers: headers).responseJSON{ response in
                if let error = response.error {
                    self.errorField.text = error.localizedDescription
                    self.loadingView.stopAnimating()
                } else {
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
        }
    }
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        validateTextFields()
        return true
    }
    
    func validateTextFields() {
        if (passwordField.text == "") || (emailField.text == "") {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
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
