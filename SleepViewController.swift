//
//  SleepViewController.swift
//  
//
//  Created by Evan Byrd on 11/30/18.
//  Refactored by Winston Chu on 12/07/18.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let chart = Chart(weeklyStats: weeklyHours, stat: "Sleep", today_stat: today_sleep, average_stat: average_sleep, stat_unit: " hours", stat_api_var: "hours_of_sleep", currentUser: currentUser!, barChartView: barChartView, todayStat: todaySleep, avgStat: avgSleep)
        chart.getWeeklyStat()
    }
    
//    func setChartValues() {
//        let dataEntries = weeklyHours
//        let size = dataEntries.count
//        print(size)
//        let values = (0..<size).map { (i) -> BarChartDataEntry in
//            let val = dataEntries[i]
//            return BarChartDataEntry(x: Double(i), y: Double(val))
//        }
//        let dates = self.getDates()
//
//        let set1 = BarChartDataSet(values: values, label: "Sleep")
//        set1.colors = [UIColor(red: 184/255, green: 27/255, blue: 17/255, alpha: 1.0)]
//        set1.valueFormatter = DigitValueFormatter()
//        let data = BarChartData(dataSet: set1)
//        self.barChartView.data = data
//        self.barChartView.backgroundColor = UIColor.lightGray
//
//        self.barChartView.rightAxis.enabled = false
//
//        self.barChartView.xAxis.labelPosition = .bottom
//        self.barChartView.xAxis.axisMaximum = 7
//        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
//        self.barChartView.xAxis.granularity = 1
//
//        let leftAxisFormatter = NumberFormatter()
//        leftAxisFormatter.minimumFractionDigits = 0
//        leftAxisFormatter.maximumFractionDigits = 1
//        leftAxisFormatter.negativeSuffix = " hrs"
//        leftAxisFormatter.positiveSuffix = " hrs"
//
//        self.barChartView.leftAxis.axisMaximum = 12
//        self.barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
//    }
//
//    // gets a date array of the past week, formatted for the bar chart
//    // https://stackoverflow.com/questions/26996330/swift-get-last-7-days-starting-from-today-in-array
//    func getDates() -> [String] {
//        let cal = Calendar.current
//        var date = cal.startOfDay(for: Date())
//        var days = [String]()
//        for _ in 1 ... 7 {
//            let day = cal.component(.day, from: date)
//            let month = cal.component(.month, from: date)
//            days.append(String(month) + "/" + String(day))
//            date = cal.date(byAdding: .day, value: -1, to: date)!
//        }
//        return days.reversed()
//    }
//
//    // returns array of hours of sleep from the past week
//    func getWeeklySleep() {
//        if let user_id = currentUser?.id, let api_key = currentUser?.api_key {
//            let user_url = "http://localhost:3000/v1/users/" + String(user_id)
//            let headers: HTTPHeaders = [
//                "Authorization": "Token token=\(api_key)"
//            ]
//            Alamofire.request(user_url, headers: headers).responseJSON { response in
//                if let error = response.error {
//                    print(error.localizedDescription)
//                }
//                if let result = response.result.value {
//                    let JSON = result as! NSDictionary
//                    if let weeklySleep = JSON["daily_wellness_survey_weekly_objects"] as? [[String: Any]] {
//                        for survey in weeklySleep {
//                            if let this_sleep = survey["hours_of_sleep"] {
//                                self.weeklyHours.append(this_sleep as! Int)
//                            }
//                        }
//                    }
//                }
//                self.setChartValues()
//                self.getAverageSleep()
//                self.getTodaySleep()
//                self.configureView()
//            }
//        }
//    }
//
//    // returns hours of sleep for today
//    func getTodaySleep() {
//        if weeklyHours.count < 7 {
//            today_sleep = "N/A"
//        } else {
//            today_sleep = String(weeklyHours[6]) + " hours"
//        }
//    }
//
//    func getAverageSleep() {
//        let weeklySleep = weeklyHours
//        var total_sleep = 0
//        var days = 1
//        for day in weeklySleep {
//            total_sleep = total_sleep + day
//            days = days + 1
//        }
//        average_sleep = String(total_sleep / days)
//    }
//
//    func configureView() {
//        if let tSleep = self.todaySleep {
//            tSleep.text = today_sleep
//        }
//        if let aSleep = self.avgSleep {
//            aSleep.text = average_sleep + " hours"
//        }
//    }

}
