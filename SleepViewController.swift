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
import Charts

class SleepViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todaySleep: UILabel!
    @IBOutlet weak var avgSleep: UILabel!
    var weeklyHours : [Int] = []
    var average_sleep : String = ""
    var today_sleep : String = ""
    var currentUser: User?
    
    func setChartValues() {
        let dataEntries = weeklyHours
        let size = dataEntries.count
        print(size)
        let values = (0..<size).map { (i) -> BarChartDataEntry in
            let val = dataEntries[i]
            return BarChartDataEntry(x: Double(i), y: Double(val))
        }
        let dates = ["12/1","12/2","12/3","12/4","12/5","12/6","12/6"]
        
        let set1 = BarChartDataSet(values: values, label: "Sleep")
        let data = BarChartData(dataSet: set1)
        
        self.barChartView.data = data
        
        self.barChartView.rightAxis.enabled = false
        
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.xAxis.axisMaximum = 7
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        self.barChartView.xAxis.granularity = 1
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " hrs"
        leftAxisFormatter.positiveSuffix = " hrs"
        
        self.barChartView.leftAxis.axisMaximum = 12
        self.barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    }
    
    // returns array of hours of sleep from the past week
    func getWeeklySleep() {
        if let user_id = currentUser?.id, let api_key = currentUser?.api_key {
            let user_url = "http://localhost:3000/v1/users/" + String(user_id)
            let headers: HTTPHeaders = [
                "Authorization": "Token token=\(api_key)"
            ]
            Alamofire.request(user_url, headers: headers).responseJSON { response in
                if let error = response.error {
                    print(error.localizedDescription)
                }
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let weeklySleep = JSON["daily_wellness_survey_weekly_objects"] as? [[String: Any]] {
                        for survey in weeklySleep {
                            if let this_sleep = survey["hours_of_sleep"] {
                                self.weeklyHours.append(this_sleep as! Int)
                            }
                        }
                    }
                }
                self.setChartValues()
                self.getAverageSleep()
                self.getTodaySleep()
                self.configureView()
            }
        }
    }
    
    // returns hours of sleep for today
    func getTodaySleep() {
        if weeklyHours.count < 7 {
            today_sleep = "N/A"
        } else {
            today_sleep = String(weeklyHours[6])
        }
    }
    
    func getAverageSleep() {
        let weeklySleep = weeklyHours
        var total_sleep = 0
        var days = 1
        for day in weeklySleep {
            total_sleep = total_sleep + day
            days = days + 1
        }
        average_sleep = String(total_sleep / days)
    }

    func configureView() {
        if let tSleep = self.todaySleep {
            tSleep.text = today_sleep + " hours"
        }
        if let aSleep = self.avgSleep {
            aSleep.text = average_sleep + " hours"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeeklySleep()
    }

}
