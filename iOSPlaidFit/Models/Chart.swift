//
//  Chart.swift
//  iOSPlaidFit
//
//  Created by Winston Chu on 12/7/18.
//  Copyright © 2018 Winston Chu. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import CoreData
import Charts

class Chart {
 
    var barChartView : BarChartView!
    var todayStat : UILabel!
    var avgStat : UILabel!
    var weeklyStats : [Int] = []
    var stat : String = ""
    var today_stat : String = ""
    var average_stat : String = ""
    var stat_unit : String = ""
    var stat_api_var : String = ""
    var currentUser: User?
    var date = DateModel()
    
    init(weeklyStats: [Int], stat: String, today_stat: String, average_stat: String, stat_unit: String, stat_api_var: String, currentUser: User, barChartView: BarChartView, todayStat: UILabel, avgStat: UILabel) {
        self.weeklyStats = weeklyStats
        self.stat = stat
        self.today_stat = today_stat
        self.average_stat = average_stat
        self.stat_unit = stat_unit
        self.stat_api_var = stat_api_var
        self.currentUser = currentUser
        self.barChartView = barChartView
        self.todayStat = todayStat
        self.avgStat = avgStat
    }
    
    // returns array of unit of stat from the past week
    func getWeeklyStat() {
        if let user_id = currentUser?.id, let api_key = currentUser?.api_key {
            let user_url = ApiUrl().get_user_url + String(user_id)
            let headers: HTTPHeaders = [
                "Authorization": "Token token=\(api_key)"
            ]
            Alamofire.request(user_url, headers: headers).responseJSON { response in
                if let error = response.error {
                    print(error.localizedDescription)
                }
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    if let weeklyStat = JSON["daily_wellness_survey_weekly_objects"] as? [[String: Any]] {
                        for survey in weeklyStat {
                            if let this_stat = survey[self.stat_api_var] {
                                self.weeklyStats.append(this_stat as! Int)
                            }
                        }
                    }
                }
                self.setChartValues()
                self.getAverageStat()
                self.getTodayStat()
                self.configureView()
            }
        }
    }
    
    func setChartValues() {
        let values = (0..<self.weeklyStats.count).map { (i) -> BarChartDataEntry in
            let val = self.weeklyStats[i]
            return BarChartDataEntry(x: Double(i), y: Double(val))
        }
        let dates = date.getDates()
        let set = BarChartDataSet(values: values, label: self.stat)
        set.colors = [UIColor(red: 184/255, green: 27/255, blue: 17/255, alpha: 1.0)]
        set.valueFormatter = DigitValueFormatter()
        let data = BarChartData(dataSet: set)
        self.barChartView.data = data
        self.barChartView.backgroundColor = UIColor.lightGray
        self.barChartView.rightAxis.enabled = false
        self.barChartView.xAxis.labelPosition = .bottom
        self.barChartView.xAxis.axisMaximum = 7
        self.barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dates)
        self.barChartView.xAxis.granularity = 1
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = self.stat_unit
        leftAxisFormatter.positiveSuffix = self.stat_unit
        self.barChartView.leftAxis.axisMaximum = 12
        self.barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    }
    
    // returns average unit of stat for past week
    func getAverageStat() {
        var total_stat = 0
        var days = 1
        for day in self.weeklyStats {
            total_stat += day
            days += 1
        }
        self.average_stat = String(total_stat / days)
    }
    
    // returns unit of stat for today
    func getTodayStat() {
        if self.weeklyStats.count < 7 {
            today_stat = "N/A"
        } else {
            today_stat = String(self.weeklyStats[6]) + self.stat_unit
        }
    }
    
    func configureView() {
        if let tStat = self.todayStat {
            tStat.text = self.today_stat
        }
        if let aStat = self.avgStat {
            aStat.text = self.average_stat + self.stat_unit
        }
        print("yay it worked :)")
    }

}
