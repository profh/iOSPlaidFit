//
//  HomeViewController.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 11/1/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import ResearchKit
import CoreData
import UserNotifications

class HomeViewController: UIViewController, ORKTaskViewControllerDelegate {
    
    // MARK: - Properties

    let create_survey_url = ApiUrl().create_survey_url
    let get_team_url = ApiUrl().get_team_url
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daily_wellness_button: UIButton!
    @IBOutlet weak var post_practice_button: UIButton!
    @IBOutlet weak var results_button: UIButton!
    let center = UNUserNotificationCenter.current()
    var currentUser: User? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    @IBAction func dailyWellnessSurveyTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: DailyWellnessSurveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func postPracticeSurveyTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: PostPracticeSurveyTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
    
    @IBAction func resultsTapped(sender : AnyObject) {
        
    }
    
    // MARK: - Functional
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        
        //check if survey was completed
        if reason == .completed {
            
            //initialize dictionary to store question:answer pairs
            var resDictionary = [String:Any]()
            
            //iterate through steps of survey
            if let results = taskViewController.result.results as? [ORKStepResult] {
                
                //store results from question steps not completion step
                for stepResult: ORKStepResult in results {
                    for result in stepResult.results as! [ORKResult] {
                        if let questionResult  = result as? ORKQuestionResult {
                            let answer = questionResult.answer.unsafelyUnwrapped
                            let name = questionResult.identifier
                            resDictionary[name] = answer
                        }
                        else {
                            print("fail")
                        }
                    }
                }
                
            }
            let api_key = currentUser?.api_key as! String
            let headers = ApiUrl().getAuthHeader(api_key)
            // daily wellness survey has 7 questions
            if resDictionary.count == 7 {
                sendDailyWellnessSurvey(headers: headers, resDictionary: resDictionary)
            } else {
                // taking post-practice survey
                sendPostPracticeSurvey(headers: headers, resDictionary: resDictionary)
            }
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    func sendDailyWellnessSurvey(headers: HTTPHeaders, resDictionary: [String : Any]) {
        let parameters: [String : Any] = [
            "user_id" : currentUser?.id!,
            "team_id" : currentUser?.team_id!,
            "survey_type" : "Daily Wellness",
            "hours_of_sleep" : resDictionary["hours_of_sleep"] as! Int,
            "quality_of_sleep" : resDictionary["quality_of_sleep"] as! Int,
            "academic_stress" : resDictionary["academic_stress"] as! Int,
            "life_stress" : resDictionary["life_stress"] as! Int,
            "soreness" : resDictionary["soreness"] as! Int,
            "ounces_of_water_consumed" : resDictionary["ounces of water consumed"] as! Int,
            "hydration_quality" : resDictionary["hydration_quality"] as! Int,
            // hardcoding season as Fall for now
            "season" : "Fall"
        ]
        self.currentUser?.missing_daily_boolean = false
        pushToAPI(parameters: parameters, headers: headers)
    }
    
    func sendPostPracticeSurvey(headers: HTTPHeaders, resDictionary: [String : Any]) {
        let parameters: [String : Any] = [
            "user_id" : currentUser?.id!,
            "team_id" : currentUser?.team_id!,
            "survey_type" : "Post-Practice",
            "player_rpe_rating" : resDictionary["player_rpe_rating"] as! Int,
            "player_personal_performance" : resDictionary["player_personal_performance"] as! Int,
            "participated_in_full_practice" : resDictionary["participated_in_full_practice"] as! Bool,
            "minutes_participated" : resDictionary["minutes_participated"] as! Int,
            // hardcoding season and practice ID for now
            "season" : "Fall",
            "practice_id" : 1
        ]
        self.currentUser?.missing_post_boolean = false
        pushToAPI(parameters: parameters, headers: headers)
    }
    
    func pushToAPI(parameters: [String : Any], headers: HTTPHeaders) {
        Alamofire.request(create_survey_url, method: .post, parameters: parameters, headers: headers).responseJSON{_ in
            self.saveUser(self.currentUser!)
        }
    }
    
    func configureView() {
        // Update the user interface for the current user.
        if let user: User = self.currentUser {
            if let name = self.nameLabel {
                name.text = "Welcome, " + user.first_name! + "!"
            }
        }
    }
    
    func setupNotifications() {
        center.removeAllPendingNotificationRequests()
        // Request permission to display alerts and play sounds.
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        let content = UNMutableNotificationContent()
        content.title = "Good Morning!"
        content.body = "Please complete your Daily Wellness Survey"
        // Configure the recurring date to send notifications at 8:00 AM everyday.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        // CHANGE THIS FOR NOTIFICATION DEMO
        dateComponents.hour = 9
        dateComponents.minute = 0
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // Create the request
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }
    
    func tearDownNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    func getTeamName() {
        if let team_id = currentUser?.team_id, let api_key = currentUser?.api_key {
            let headers = ApiUrl().getAuthHeader(api_key)
            Alamofire.request(get_team_url + String(team_id), headers: headers).responseJSON{ response in
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    let gender = JSON["gender"]! as! String
                    let sport = JSON["sport"]! as! String
                    self.currentUser?.team_string = gender + "'s " + sport
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.setupNotifications()
        self.getTeamName()
        // set the date label
        // not sure why if you take out this logic from viewDidLoad(), build will fail
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        let dateString = dateFormatter.string(from: currentDate)
        self.dateLabel.numberOfLines = 2
        self.dateLabel.text = dateString
        if let user: User = self.currentUser {
            print("----------")
            print(user.missing_daily_boolean!)
            daily_wellness_button.isEnabled = user.missing_daily_boolean!
            post_practice_button.isEnabled = user.missing_post_boolean!
        } else {
            print("failed to load user in viewDidLoad")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user: User = self.currentUser {
            print("=========")
            print(user.missing_daily_boolean!)
            daily_wellness_button.isEnabled = user.missing_daily_boolean!
            post_practice_button.isEnabled = user.missing_post_boolean!
        } else {
            print("failed to load user in viewDidAppear")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func deleteUser() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                // if the contact we are deleting is the same as this one in CoreData {
                context.delete(data)
                try context.save()
            }
        } catch {
            print("Failed")
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            // go back to login screen and clear the current user
            self.deleteUser()
            self.tearDownNotifications()
            self.currentUser = nil
            _ = navigationController?.popToRootViewController(animated: true)
        } else if segue.identifier == "profileSegue" {
            // go to profile view and set the current user to display info
            (segue.destination as! ProfileViewController).currentUser = self.currentUser
        } else if segue.identifier == "resultSegue" {
            (segue.destination as! ResultsViewController).currentUser = self.currentUser
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if let ident = identifier {
            if ident == "profileSegue" {
                // do not perform segue if, for any reason, user failed to log in
                if currentUser?.team_string == "" {
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
        print(user.missing_daily_boolean!)
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
