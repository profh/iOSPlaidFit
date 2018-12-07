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
import Charts

class StressViewController: UIViewController {

    
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var todayStress: UILabel!
    @IBOutlet weak var avgStress: UILabel!
    var weeklyStress : [Int] = []
    var average_stress : String = ""
    var today_stress : String = ""
    var currentUser: User?
    
    func configureView() {
        if let tStress = self.todayStress {
            tStress.text = today_stress
        }
        if let aStress = self.avgStress {
            aStress.text = average_stress
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeeklyStress()
    }
    
    func setChartValues() {
        let dataEntries = weeklyStress
        let size = dataEntries.count
        let values = (0..<size).map { (i) -> BarChartDataEntry in
            let val = dataEntries[i]
            return BarChartDataEntry(x: Double(i), y: Double(val))
        }
        let dates = self.getDates()
        
        let set1 = BarChartDataSet(values: values, label: "Stress")
        set1.colors = [UIColor(red: 184/255, green: 27/255, blue: 17/255, alpha: 1.0)]
        set1.valueFormatter = DigitValueFormatter()
        let data = BarChartData(dataSet: set1)
        
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
        
        self.barChartView.leftAxis.axisMaximum = 10
        self.barChartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
    }
    
    // gets a date array of the past week, formatted for the bar chart
    // https://stackoverflow.com/questions/26996330/swift-get-last-7-days-starting-from-today-in-array
    func getDates() -> [String] {
        let cal = Calendar.current
        var date = cal.startOfDay(for: Date())
        var days = [String]()
        for _ in 1 ... 7 {
            let day = cal.component(.day, from: date)
            let month = cal.component(.month, from: date)
            days.append(String(month) + "/" + String(day))
            date = cal.date(byAdding: .day, value: -1, to: date)!
        }
        return days.reversed()
    }
    
    func getWeeklyStress() {
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
                    if let weeklyStress = JSON["daily_wellness_survey_weekly_objects"] as? [[String: Any]] {
                        for survey in weeklyStress {
                            if let this_stress = survey["life_stress"] {
                                self.weeklyStress.append(this_stress as! Int)
                            }
                        }
                    }
                }
                self.setChartValues()
                self.getAverageStress()
                self.getTodayStress()
                self.configureView()
            }
        }
    }
    
    func getTodayStress() {
        if weeklyStress.count < 7 {
            today_stress = "N/A"
        } else {
            today_stress = String(weeklyStress[6])
        }
    }
    
    func getAverageStress() {
        let weeklyStress = self.weeklyStress
        var total_stress = 0
        var days = 1
        for day in weeklyStress {
            total_stress = total_stress + day
            days = days + 1
        }
        average_stress = String(total_stress / days)
    }
}
