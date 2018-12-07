//
//  SignupViewController.swift
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

class SignupViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties

    let create_users_url = "http://128.237.212.128:3000/v1/users"
    let create_team_assignments_url = "http://128.237.212.128:3000/v1/team_assignments"
    let headers: HTTPHeaders = [
        // hard-coding token value as user ID 1's value for now
        // b/c can't authorize creation when signing up a new user
        "Authorization": "Token token=f30aab90374746dc5ecf203827782989"
    ]
    var loggedInUser: User? = nil
    var teams = [(String, Int)]()
    @IBOutlet weak var andrewIdField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfField: UITextField!
    @IBOutlet weak var teamPicker: UIPickerView!
    @IBOutlet weak var classPicker: UIPickerView!
    @IBOutlet weak var majorPicker: UIPickerView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var pwImage: UIImageView!
    @IBOutlet weak var pwConfImage: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Picker Delegates
    
    let teamPickerDelegate = TeamPickerDelegate()
    let classPickerDelegate = ClassPickerDelegate()
    let majorPickerDelegate = MajorPickerDelegate()

    // MARK: - Functional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        setBackgroundImage()
        setupPickerBorders()
        signupButton.setTitleColor(UIColor.lightGray, for: .disabled)
        let pwConfTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        let pwTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pwImage.isUserInteractionEnabled = true
        pwImage.addGestureRecognizer(pwTapGestureRecognizer)
        pwConfImage.isUserInteractionEnabled = true
        pwConfImage.addGestureRecognizer(pwConfTapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        var text = ""
        if passwordField.text != "" && passwordConfField.text != "" {
            if passwordField.text == passwordConfField.text && (passwordField.text?.count)! >= 6 {
                text = "Passwords match."
            } else {
                if passwordField.text != passwordConfField.text {
                    text = "Passwords do not match."
                }
                if (passwordField.text?.count)! < 6 {
                    text = "Password must be at least 6 characters."
                }
                if passwordField.text != passwordConfField.text && (passwordField.text?.count)! < 6 {
                    text = "Passwords do not match and must be at least 6 characters."
                }
                
            }
        }
        if text != "" {
            let alert = UIAlertController(title: "Password Confirmation", message: text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setupDelegates() {
        teamPickerDelegate.teams = self.teams
        teamPicker.delegate = teamPickerDelegate
        teamPicker.dataSource = teamPickerDelegate
        classPicker.delegate = classPickerDelegate
        classPicker.dataSource = classPickerDelegate
        majorPicker.delegate = majorPickerDelegate
        majorPicker.dataSource = majorPickerDelegate
        andrewIdField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        phoneField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        passwordConfField.delegate = self
        signupButton.isEnabled = false
    }
    
    func setBackgroundImage() {
        let backgroundImage = UIImage(named: "pic_background")
        let backgroundImageView = UIImageView(frame: self.contentView.frame)
        backgroundImageView.image = backgroundImage
        self.contentView.insertSubview(backgroundImageView, at: 0)
    }
    
    func setupPickerBorders() {
        teamPicker.layer.borderWidth = 3
        teamPicker.layer.borderColor = UIColor.white.cgColor
        classPicker.layer.borderWidth = 3
        classPicker.layer.borderColor = UIColor.white.cgColor
        majorPicker.layer.borderWidth = 3
        majorPicker.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false // show nav bar to go back (cancel) to login screen
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        createUser(sender: sender)
    }
    
    func createUser(sender: Any) {
        let major = self.majorPickerDelegate.majors[majorPicker.selectedRow(inComponent: 0)]
        let class_year = self.classPickerDelegate.classes[classPicker.selectedRow(inComponent: 0)]
        let parameters: [String : Any] = [
            "first_name" : firstNameField.text!,
            "last_name" : lastNameField.text!,
            "andrew_id" : andrewIdField.text!,
            "email" : emailField.text!,
            "major" : major,
            "phone" : phoneField.text!,
            "role" : "Player",
            "active" : "true",
            "year" : class_year,
            "password" : passwordField.text!,
            "password_confirmation" : passwordConfField.text!
        ]
        Alamofire.request(create_users_url, method: .post, parameters: parameters, headers: headers).responseJSON{ response in
            if let result = response.result.value {
                let JSON = result as! NSDictionary
                let team_id = self.teamPickerDelegate.teams[self.teamPicker.selectedRow(inComponent: 0)].1
                self.loggedInUser = User(id: JSON["id"]! as! Int, team_id: team_id, first_name: JSON["first_name"]! as! String, last_name: JSON["last_name"]! as! String, andrew_id: JSON["andrew_id"]! as! String, email: JSON["email"]! as! String, phone_number: JSON["phone"]! as! String, role: JSON["role"]! as! String, year: JSON["year"]! as! String, major: JSON["major"]! as! String, missing_daily_boolean: JSON["missing_daily_boolean"]! as! Bool, missing_post_boolean: JSON["missing_post_boolean"]! as! Bool, api_key: JSON["api_key"]! as! String, team_string: "")
                self.createTeamAssignment(sender: sender)
            }
        }
    }
    
    func createTeamAssignment(sender: Any) {
        let team_id = self.teamPickerDelegate.teams[teamPicker.selectedRow(inComponent: 0)].1
        let user_id = self.loggedInUser?.id
        let parameters: [String : Any] = [
            "team_id" : team_id,
            "user_id" : user_id!,
            "active" : true,
            "date_added" : getTodayDateString()
        ]
        Alamofire.request(create_team_assignments_url, method: .post, parameters: parameters, headers: headers).responseJSON{ response in
            if response.result.value != nil { // team assignment was created successfully
                self.saveUser(self.loggedInUser!)
                self.performSegue(withIdentifier: "signupSegue", sender: sender)
            }
        }
    }

    func getTodayDateString() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    @objc func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        validateTextFields()
        return true
    }
    
    func validateTextFields() {
        if (andrewIdField.text == "") || (firstNameField.text == "") || (lastNameField.text == "") || (phoneField.text == "") || (emailField.text == "") || (passwordField.text == "") || (passwordConfField.text == "") {
            signupButton.isEnabled = false
        } else {
            signupButton.isEnabled = true
        }
    }
    
    @IBAction func pwTextChanged(_ sender: Any) {
        confirmPasswords()
    }
    
    @IBAction func pwConfTextChanged(_ sender: Any) {
        confirmPasswords()
    }
    
    func confirmPasswords() {
        if passwordField.text != "" && passwordConfField.text != "" {
            // passwords must match and be at least 6 characters
            if passwordField.text == passwordConfField.text && (passwordField.text?.count)! >= 6 {
                pwImage.image = UIImage(named: "green_confirm")
                pwConfImage.image = UIImage(named: "green_confirm")
            } else {
                pwImage.image = UIImage(named: "warning")
                pwConfImage.image = UIImage(named: "warning")
                signupButton.isEnabled = false
            }
        } else {
            pwImage.image = nil
            pwConfImage.image = nil
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signupSegue" {
            // set the destination as the Home page and set the current user to the recently created (logged in) user
            let nav = segue.destination as! UINavigationController
            let hvc = nav.topViewController as! HomeViewController
            hvc.currentUser = loggedInUser
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "signupSegue" {
                // do not perform segue if there is no created (logged in) user
                if loggedInUser == nil {
                    return false
                }
            }
        }
        return true
    }
    
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

}
