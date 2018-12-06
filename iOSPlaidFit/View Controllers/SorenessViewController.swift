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
import Charts

class SorenessViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todaySoreness: UILabel!
    @IBOutlet weak var avgSoreness: UILabel!
    
    func configureView() {
        if let tSoreness = self.todaySoreness {
            tSoreness.text = String(getTodaySoreness())
        }
        if let aSoreness = self.avgSoreness {
            aSoreness.text = String(getAverageSoreness())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.setChartValues()
        // Do any additional setup after loading the view.
    }
    
    func setChartValues() {
        let dataEntries = getWeeklySoreness()
        let size = dataEntries.count
        let values = (0..<size).map { (i) -> ChartDataEntry in
            let val = dataEntries[i]
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        
        let set1 = BarChartDataSet(values: values, label: "Soreness")
        let data = BarChartData(dataSet: set1)
        
        self.barChartView.data = data
    }
    
    func getWeeklySoreness() -> Array<Int> {
        let user_url = "http://localhost:3000/v1/token"
        let headers: HTTPHeaders = [
            "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
        ]
        var weeklySoreness : [Int] = []
        Alamofire.request(user_url, headers:headers).responseJSON { response in
            if let error = response.error {
                print("error")
            } else {
                if let result = response.result.value as? [String: Any] {
                    if let weeklySore = result["post_practice_survey_weekly_objects"] as? [[String: Any]] {
                        for survey in weeklySore {
                            if let this_soreness = survey["soreness"] {
                                let soreness = this_soreness as! Int
                                weeklySoreness.append(soreness)
                            }
                        }
                    }
                }
            }
        }
        return weeklySoreness
    }
    
    func getTodaySoreness() -> Int {
        let user_url = "http://localhost:3000/v1/token"
        let headers: HTTPHeaders = [
            "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
        ]
        var today_soreness = 0
        Alamofire.request(user_url, headers:headers).responseJSON { response in
            if let error = response.error {
                print("error")
            } else {
                if let result = response.result.value as? [String: Any] {
                    if let tSoreness = result["post_practice_survey_yesterday_objects"] as? [String: Any] {
                        today_soreness = tSoreness["soreness"] as! Int
                    }
                }
            }
        }
        return today_soreness
    }
    
    func getAverageSoreness() -> Int {
        let weeklySoreness = getWeeklySoreness()
        var total_soreness = 0
        var days = 0
        for day in weeklySoreness {
            total_soreness = total_soreness + day
            days = days + 1
        }
        return total_soreness/days
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
