//
//  SleepViewController.swift
//  
//
//  Created by Evan Byrd on 11/30/18.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import CoreData

class SleepViewController: UIViewController {

    @IBOutlet weak var todaySleep: UILabel!
    @IBOutlet weak var avgSleep: UILabel!
    var currentUser: User? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the current user.
        var user_id = ""
        if let user: User = self.currentUser {
            user_id = "\(user.id)"
        }
        
        let get_user_url = "http://localhost:3000/v1/users/4"
        
        let githubURL: NSURL = NSURL(string: get_user_url)!
        
        let data = NSData(contentsOf: githubURL as URL)!
        
        let swiftyjson = try! JSON(data: data as Data)
//        print("\n****************************\n")
//        print(swiftyjson["daily_wellness_survey_today_objects"][0]["hours_of_sleep"])
//        print("\n****************************\n")
        
        if let tsleep = self.todaySleep {
            tsleep.text = swiftyjson["daily_wellness_survey_today_objects"][0]["hours_of_sleep"].rawString()
        }
        
        var total_sleep = 0
        var counter = 0
        
        for i in 0..<6 {
            if let this_sleep = swiftyjson["daily_wellness_survey_weekly_objects"][i]["hours_of_sleep"].rawString() {
                total_sleep = total_sleep + Int(this_sleep)!
            }
            counter = counter + 1
        }
        
        let avgS = total_sleep/counter
        
        if let asleep = self.avgSleep {
            asleep.text = "\(avgS)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
