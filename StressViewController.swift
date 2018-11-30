//
//  StressViewController.swift
//  iOSPlaidFit
//
//  Created by Evan Byrd on 11/30/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import CoreData

class StressViewController: UIViewController {

    @IBOutlet var todayStress: UIView!
    @IBOutlet weak var avgStress: UILabel!
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
        
        let get_user_url = "http://localhost:3000/v1/users/" + user_id
        
        let githubURL: NSURL = NSURL(string: get_user_url)!
        
        let data = NSData(contentsOf: githubURL as URL)!
        
        let swiftyjson = try? JSON(data: data as Data)
        
        if let tstress = self.todayStress {
            tstress.text = swiftyjson!["daily_wellness_survey_today_objects"][0]["life_stress"].string
        }
        
        var total_stress = 0
        var counter = 0
        
        for i in 0..<6 {
            if let this_stress = swiftyjson!["daily_wellness_survey_weekly_objects"][i]["life_stress"].string {
                total_stress = total_stress + Int(this_stress)!
            }
            counter = counter + 1
        }
        
        let avgS = total_stress/counter
        
        if let astress = self.avgStress {
            astress.text = "\(avgS)"
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
