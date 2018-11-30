//
//  SorenessViewController.swift
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

class SorenessViewController: UIViewController {

    @IBOutlet weak var todaySoreness: UILabel!
    @IBOutlet weak var avgSoreness: UILabel!
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
        
        let swiftyjson = try? JSON(data: data as Data)
        
        
        if let tsoreness = self.todaySoreness {
            tsoreness.text = swiftyjson!["post_practice_survey_yesterday_objects"][0]["player_rpe_rating"].rawString()
        }
        
        var total_soreness = 0
        var counter = 0
        
        for i in 0..<6 {
            if let this_soreness = swiftyjson!["post_practice_survey_weekly_objects"][i]["player_rpe_rating"].rawString() {
                total_soreness = total_soreness + Int(this_soreness)!
            }
            counter = counter + 1
        }
        
        let avgS = total_soreness/counter
        
        if let asoreness = self.avgSoreness {
            asoreness.text = "\(avgS)"
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
