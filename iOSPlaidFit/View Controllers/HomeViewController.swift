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
class HomeViewController: UIViewController, ORKTaskViewControllerDelegate {

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
            
            //convert question:answer dictionary to json data
            let jsonData = try? JSONSerialization.data(withJSONObject: resDictionary, options: [])
            
            //convert json data to string
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print("hello")
            print(jsonString)
            print(currentUser)
            
        }
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel!
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
    
    // MARK: - Functional
    
    func configureView() {
        // Update the user interface for the current user.
        if let user: User = self.currentUser {
            if let name = self.nameLabel {
                name.text = user.first_name! + " " + user.last_name!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            // go back to login screen and clear the current user
            self.currentUser = nil
            _ = navigationController?.popToRootViewController(animated: true)
        } else if segue.identifier == "profileSegue" {
            // go to profile view and set the current user to display info
            (segue.destination as! ProfileViewController).currentUser = self.currentUser
        }
    }

}
