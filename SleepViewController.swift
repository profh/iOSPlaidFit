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
    
    func setChartValues() {
        let dataEntries = getWeeklySleep()
        let size = dataEntries.count
//        let values = (0..<size).map { (i) -> ChartDataEntry in
        let values = (0..<7).map { (i) -> BarChartDataEntry in
//            let val = dataEntries[i]
            let val = i
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
    func getWeeklySleep() -> Array<Int> {
        let user_url = "http://localhost:3000/v1/token"
        let headers: HTTPHeaders = [
            "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
        ]
        var weeklyHours : [Int] = []
        let param : [String: Any] = [:]
        Alamofire.request(user_url, parameters: param, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let error = response.error {
                print(error.localizedDescription)
            } else {
                if let result = response.result.value as? [String: Any] {
                    print(result)
                    if let weeklySleep = result["daily_wellness_survey_weekly_objects"] as? [[String: Any]] {
                        for survey in weeklySleep {
                            if let this_sleep = survey["hours_of_sleep"] {
                                let sleep = this_sleep as! Int
                                weeklyHours.append(sleep)
                            }
                        }
                    }
                }
            }
        }
        return weeklyHours
    }
    
    // returns hours of sleep for today
    func getTodaySleep() -> Int {
        let user_url = "http://localhost:3000/v1/token"
        let headers: HTTPHeaders = [
            "Authorization": "Token token=1977ec368318a5fddc09f8191aacf39b"
        ]
        var today_sleep = 0
        Alamofire.request(user_url, headers:headers).responseJSON { response in
            if let error = response.error {
                print(error.localizedDescription)
            } else {
                if let result = response.result.value as? [String: Any] {
                    if let tSleep = result["daily_wellness_survey_today_objects"] as? [String: Any] {
                        today_sleep = tSleep["hours_of_sleep"] as! Int
                    }
                }
            }
        }
        return today_sleep
    }
    
    func getAverageSleep() -> Int {
        let weeklySleep = getWeeklySleep()
        var total_sleep = 0
        var days = 0
        for day in weeklySleep {
            total_sleep = total_sleep + day
            days = days + 1
        }
        return total_sleep/days
    }

    func configureView() {
        if let tSleep = self.todaySleep {
            tSleep.text = String(getTodaySleep())
        }
//        if let aSleep = self.avgSleep {
//            aSleep.text = String(getAverageSleep())
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.setChartValues()
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
